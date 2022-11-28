#!/bin/bash
# exit when any command fails
set -e


echo "================================================================="
echo "=== check which files changes in remote master before pulling ==="
echo "================================================================="
echo "=== git fetch ==="
echo "=== git diff --name-status ...origin ==="
echo "=== -r parameter for checking only yaml-generated files = $RFILES ==="
echo "=== git diff --name-status ...origin -- input/resources -- input/examples ==="
echo "================================================================="

git fetch
git diff --name-status ...origin

echo "================================================================="
echo "=== hit 'y' to pull ===="
echo "=== else any other key to abort ==="
echo "================================================================="

read var1

echo "================================================================="
echo "==================== you typed '$var1' ============================"
echo "================================================================="

if [ $var1 == "y" ]; then
  git pull
fi



