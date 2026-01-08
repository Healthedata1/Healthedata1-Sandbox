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
# git diff --name-status ...origin
changed_files=$(git diff-tree -r --name-only --no-commit-id ORIG_HEAD HEAD)

for file in $changed_files; do

if file == input/resources/*.json then
    if ! echo "$changed_files" | grep -q "^${file%.json}.yaml"; then
        echo "⚠️  $file was edited directly! convert to YAML and overwrite the YAML in resources-yaml"
    else echo "changed file = $file"
    fi
done


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



