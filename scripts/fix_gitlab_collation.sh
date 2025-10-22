#!/bin/bash
# ---------------------------------------------------------------------------
#  GitLab Collation Version Fix Script
# ---------------------------------------------------------------------------
#  Description:
#   - Checks GitLab service health
#   - Checks if the GitLab database exists
#   - Creates a full GitLab backup
#   - Refreshes the collation version
#   - Reindexes the GitLab database
#   - Restarts GitLab services
#
#  Safe for production: includes all checks, logging, and error handling
# ---------------------------------------------------------------------------

LOG_FILE="/var/log/gitlab/fix_gitlab_collation.log"
DB_NAME="gitlabhq_production"

echo "=== Starting GitLab collation fix: $(date) ===" | tee -a "$LOG_FILE"

# --- 0. Check GitLab service health ----------------------------------------
echo "[Step 0] Checking GitLab service status..." | tee -a "$LOG_FILE"
if sudo gitlab-ctl status > /dev/null 2>&1; then
  UNHEALTHY=$(sudo gitlab-ctl status | grep -v "run:" | grep -v "supervisor")
  if [ -n "$UNHEALTHY" ]; then
    echo "⚠️  Some GitLab services are not running properly:" | tee -a "$LOG_FILE"
    echo "$UNHEALTHY" | tee -a "$LOG_FILE"
    echo "❌ Please fix GitLab service issues before proceeding." | tee -a "$LOG_FILE"
    exit 1
  else
    echo "✅ All GitLab services are running correctly." | tee -a "$LOG_FILE"
  fi
else
  echo "❌ Unable to check GitLab status. 'gitlab-ctl' command failed." | tee -a "$LOG_FILE"
  exit 1
fi

# --- 1. Check if the database exists ---------------------------------------
echo "[Step 1] Checking if database '$DB_NAME' exists..." | tee -a "$LOG_FILE"
if ! sudo gitlab-psql -lqt | cut -d \| -f 1 | grep -qw "$DB_NAME"; then
  echo "❌ Database '$DB_NAME' not found. Aborting process." | tee -a "$LOG_FILE"
  exit 1
else
  echo "✅ Database '$DB_NAME' exists. Proceeding..." | tee -a "$LOG_FILE"
fi

# --- 2. Backup GitLab data --------------------------------------------------
echo "[Step 2] Creating GitLab backup..." | tee -a "$LOG_FILE"
if sudo gitlab-backup create >> "$LOG_FILE" 2>&1; then
  echo "✅ Backup completed successfully." | tee -a "$LOG_FILE"
else
  echo "❌ Backup failed! Aborting process." | tee -a "$LOG_FILE"
  exit 1
fi

# --- 3. Refresh collation version ------------------------------------------
echo "[Step 3] Refreshing database collation version..." | tee -a "$LOG_FILE"
if sudo gitlab-psql -d "$DB_NAME" -c "ALTER DATABASE $DB_NAME REFRESH COLLATION VERSION;" >> "$LOG_FILE" 2>&1; then
  echo "✅ Collation version refreshed successfully." | tee -a "$LOG_FILE"
else
  echo "❌ Failed to refresh collation version. Aborting." | tee -a "$LOG_FILE"
  exit 1
fi

# --- 4. Reindex GitLab database --------------------------------------------
echo "[Step 4] Reindexing all database objects (this may take a while)..." | tee -a "$LOG_FILE"
if sudo gitlab-rake gitlab:db:reindex >> "$LOG_FILE" 2>&1; then
  echo "✅ Database reindex completed successfully." | tee -a "$LOG_FILE"
else
  echo "❌ Reindex operation failed. Please check the log." | tee -a "$LOG_FILE"
  exit 1
fi

# --- 5. Restart GitLab services --------------------------------------------
echo "[Step 5] Restarting GitLab services..." | tee -a "$LOG_FILE"
if sudo gitlab-ctl restart >> "$LOG_FILE" 2>&1; then
  echo "✅ GitLab services restarted successfully." | tee -a "$LOG_FILE"
else
  echo "⚠️ GitLab restart failed — please restart manually." | tee -a "$LOG_FILE"
fi

echo "=== GitLab collation fix completed at $(date) ===" | tee -a "$LOG_FILE"
