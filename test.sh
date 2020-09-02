#!/bin/bash
# exit when any command fails
set -e

inpath=fsh/ig-data/input/resources/yaml/*.yml

if ls $inpath; then
echo "========================================================================"
echo "convert all yml files in examples directory to json files"
echo "Python 3.7 and PyYAML, json and sys modules are required"
for yaml_file in $inpath
do
echo $yaml_file
done
else
  echo 'no files'
fi
