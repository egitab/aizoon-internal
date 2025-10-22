#!/bin/bash

this_minute=$(date +%Y%m%d-%H%M)
this_branch=$(git symbolic-ref --short HEAD)

echo "git checkout $this_branch"
git checkout $this_branch
echo -----------------------------------------------------------------
sleep 1
echo "git add -A ; git commit -m \"[$(hostname)] commit date: $this_minute\"; git push"
git add -A ; git commit -m "[$(hostname)] commit date: $this_minute"; git push
