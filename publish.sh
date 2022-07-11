#!/bin/bash
# exit when any command fails
set -e
NA='http://tx.fhir.org'
while getopts twoplisvqdryzmu: option
do
 case "${option}"
 in
 t) NA='N/A';;
 w) WATCH=1;;
 o) PUB=1;;
 p) UPDATE=1;;
 l) LOAD_TEMPLATE=1;;
 u) TEST_TEMPLATE=$OPTARG;;
 i) IG_PUBLISH=1;;
 s) SUSHI=1;;
 v) VIEW_OUTPUT=1;;
 q) VIEW_QA=1;;
 d) IN_DOCS=1;;
 y) YAML_JSON=1;;
 z) ZIP_SCH=1;;
 r) CLEAR_JSON=1;;
 m) MERGE_CSV=1;;
 esac
done

inpath=input
if [[ $IN_DOCS ]]; then
  outpath=docs
else
  outpath=output
fi

echo "================================================================="
echo "-d flag if output in "docs" folder =  $IN_DOCS"
echo "current directory = $PWD"
echo "outpath=$outpath"
echo "inpath=$inpath"
echo "================================================================="

echo "================================================================="
echo === Publish $SOURCE IG!!! $(date -u) ===
echo "see local workflow.md file for how to use"
echo "Optional Parameters"
echo "-t parameter for no terminology server (run faster and offline)= $NA"
echo "-w parameter for using watch on igpublisher from source default is off = $WATCH"
echo "-o parameter for running previous version of the igpublisher= $PUB"
echo "-p parameter for downloading latest version of the igpublisher from source = $UPDATE"
#echo '-l parameter for downloading HL7 ig template from source = ' $LOAD_TEMPLATE
#echo '-u parameter for downloading test ig template from source or file= ' $TEST_TEMPLATE
echo "-i parameter for running only ig-publisher = $IG_PUBLISH"
echo "-s parameter for running only sushi = $SUSHI"
echo "-v view ig home page  in current browser = ./$outpath/index.html  =  $VIEW_OUTPUT"
echo "-q view qa output in current browser = ./$outpath/qa.html  =  $VIEW_QA"
echo "-d flag if output in "docs" folder = $IN_DOCS"
echo "-r remove all generated json files = $CLEAR_JSON"
echo "-y tranform all yaml to json files = $YAML_JSON"
echo "-z zip up all schematrons = $ZIP_SCH"
echo "-m merge all StructureDefinition csv files with single header = $MERGE_CSV"
echo "================================================================="
echo getting rid of .DS_Store files since they gum up the igpublisher....
find $PWD -name '.DS_Store' -type f -delete
sleep 1

if [[ $CLEAR_JSON ]]; then
echo 'remove all generated files in /examples and /resources folders'
rm  -f $inpath/resources/*.* $inpath/examples/*.*
fi

if [[ $YAML_JSON ]] && ls $inpath/resources-yaml/*.yml; then
echo "========================================================================"
echo "convert all yml files in resources-yaml directory to json files"
echo "outgoingPython 3.7 and PyYAML, json and sys modules are required"
for yaml_file in $inpath/resources-yaml/*.yml
do
echo $yaml_file
json_file=$inpath/resources/$(basename $yaml_file)
json_file=${json_file%.*}.json
echo $json_file
python3.7 -c 'import sys, yaml, json, datetime; json.dump(yaml.full_load(sys.stdin), sys.stdout, indent=4, default = lambda self:(self.isoformat() if isinstance(self, (datetime.datetime, datetime.date)) else f"YAML to JSON for {self} not serializable"))' < $yaml_file > $json_file
done
fi

if [[ $YAML_JSON ]] && ls $inpath/examples-yaml/*.yml; then
echo "========================================================================"
echo "convert all yml files in examples-yaml directory to examples/json files"
echo "outgoingPython 3.7 and PyYAML, json and sys modules are required"
for yaml_file in $inpath/examples-yaml/*.yml
do
echo $yaml_file
json_file=$inpath/examples/$(basename $yaml_file)
json_file=${json_file%.*}.json
echo $json_file
python3.7 -c 'import sys, yaml, json, datetime; json.dump(yaml.full_load(sys.stdin), sys.stdout, indent=4, default = lambda self:(self.isoformat() if isinstance(self, (datetime.datetime, datetime.date)) else f"YAML to JSON for {self} not serializable"))' < $yaml_file > $json_file
done
fi

if [[ $YAML_JSON ]] && ls $inpath/includes-yaml/*.yml; then
echo "======================================================================="
echo "convert all yml files in includes-yaml directory to json files"
echo "outgoingPython 3.7 and PyYAML, json and sys modules are required"
for yaml_file in $inpath/includes-yaml/*.yml
do
echo $yaml_file
json_file=$inpath/includes/$(basename $yaml_file)
json_file=${json_file%.*}.json
echo $json_file
python3.7 -c 'import sys, yaml, json, datetime; json.dump(yaml.full_load(sys.stdin), sys.stdout, indent=4, default = lambda self:(self.isoformat() if isinstance(self, (datetime.datetime, datetime.date)) else f"YAML to JSON for {self} not serializable"))' < $yaml_file > $json_file
done
echo "========================================================================"
fi

if [[ $UPDATE ]]; then
puburl=https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar
path1=~/Downloads/org.hl7.fhir.igpublisher.jar
path2=~/Downloads/org.hl7.fhir.igpublisher-old.jar
path3=../../../Downloads/org.hl7.fhir.igpublisher.jar
path4=../../../Downloads/org.hl7.fhir.igpublisher-old.jar
echo "========================================================================"
echo "Downloading most recent publisher from $puburl to:"
echo ~/Downloads/org.hl7.fhir.igpublisher.jar
echo "... it's ~100 MB, so this may take a bit"
echo "========================================================================"
mv $path1 $path2 || mv $path3 $path4
curl -L $puburl -o $path1 || curl -L $puburl -o $path3
echo "===========================   Done  ===================================="
sleep 3
fi

# default is to use local my_framework as template
#template=$PWD/my_framework
#if [[ $LOAD_TEMPLATE ]]; then
#template=hl7.fhir.template
#fi

#if [[ $TEST_TEMPLATE ]]; then
#template=$TEST_TEMPLATE
#fi

#echo "================================================================="
#echo === load the hl7 template by setting $PWD/ig.ini ===
#echo === template parameter to .................................... ===
#echo === $template ===
#echo "================================================================="
#sed -i'.bak' -e "s|^template = .*|template = ${template}|" $PWD/ig.ini

echo "================================================================="
echo getting path = ...................................................
path=~/Downloads/org.hl7.fhir.igpublisher.jar
if [[ $PUB ]]; then
path=~/Downloads/org.hl7.fhir.igpublisher-old.jar
fi
echo $path
echo "================================================================="

if [[ $SUSHI ]]; then
  echo "================================================================="
  echo "start sushi ......................................................"
  rm -rf output docs
  sushi .
  inpath=fsh-generated/resources
  echo "========================================================================"
  echo "convert ig.json to ig.yml and copy to input/data"
  echo "Python 3.7 and PyYAML, json and sys modules are required"
  for ig_json in fsh-generated/resources/ImplementationGuide*.json
    do
    echo "========== ig_json = $ig_json =========="
    ig_yaml='input/data/ig.yml'
    python3.7 -c 'import sys, yaml, json; yaml.dump(json.load(sys.stdin), sys.stdout, sort_keys=False)' < $ig_json > $ig_yaml
    echo "========== ig_yaml = $ig_yaml =========="
    done

  echo "================================================================="

else

  if [[ $IG_PUBLISH ]]; then
    echo "================================================================="
    echo "=== run the just the igpublisher ==="
    echo "==To run in command line mode, run the IG Publisher like this:=="
    echo "===java -jar publisher.jar -ig [source] (-tx [url]) (-packages [directory]) (-watch)
parameters:==="
    echo "================================================================="

    echo "================================================================="
    echo "=== rename the 'input/fsh' folder to 'input/_fsh'  ==="
    echo "================================================================="
    trap "echo '=== rename the input/_fsh folder to input/fsh  ==='; mv input/_fsh input/fsh" EXIT
    [[ -d input/fsh ]] && mv input/fsh input/_fsh

    if [[ $WATCH ]]; then
      echo "================================================================="
      echo === run most recent version of the igpublisher with watch on ===
      echo "================================================================="
      java -Xmx4G -jar ${path} -ig ig.ini -watch -tx $NA

    else
      echo "================================================================="
      echo "===run igpublisher just once \(no watch option\)==="
      echo "================================================================="
      echo java -jar ${path} -ig ig.ini -tx $NA
      java -Xmx4G -jar ${path} -ig ig.ini -tx $NA

    fi

  else
    echo "================================================================="
    echo "=== run sushi and igpublisher (default) ===="
    echo "================================================================="
    echo "start sushi ......................................................"
    rm -rf output docs
    sushi .
    inpath=fsh-generated/resources
    echo "========================================================================"
    echo "convert ig.json to ig.yml and copy to input/data"
    echo "outgoingPython 3.7 and PyYAML, json and sys modules are required"
    for ig_json in $inpath/ImplementationGuide*.json
      do
      echo "========== ig_json = $ig_json =========="
      ig_yaml='input/data/ig.yml'
      python3.7 -c 'import sys, yaml, json, datetime; json.dump(yaml.full_load(sys.stdin), sys.stdout, indent=4, default = lambda self:(self.isoformat() if isinstance(self, (datetime.datetime, datetime.date)) else f"YAML to JSON for {self} not serializable"))' < $ig_json > $ig_yaml
      echo "========== ig_yaml = $ig_yaml =========="
      done

    if [[ $WATCH ]]; then
      echo "================================================================="
      echo === run most recent version of the igpublisher with watch on ===
      echo "================================================================="
      java -Xmx4G -jar ${path} -ig ig.ini -watch -tx $NA

    else
      echo "================================================================="
      echo "===run igpublisher just once \(no watch option\)==="
      echo "================================================================="
      echo java -jar ${path} -ig ig.ini -tx $NA
      java -Xmx4G -jar ${path} -ig ig.ini -tx $NA
    fi

  fi

fi

if [[ $ZIP_SCH ]]; then
    echo "================================================================="
    echo "===zip up schematrons and put in==="
    echo "===$outpath/input/images/schematrons.zip file for downloads==="
    echo "===zip -j input/images/schematrons.zip $outpath/*.sch==="
    echo "================================================================="
    zip -j input/images/schematrons.zip $outpath/*.sch
fi

if [[ $MERGE_CSV ]]; then
    echo "================================================================="
    echo "===merge all StructureDefinition CSV and output as Excel too  ==="
    echo "Python 3.7 and pyexcel-cli, pyexcel, and pyexcel-xlsx are required"
    echo "===require header file in $outpath/input/images-source/all_profiles.csv file ==="
    echo "===creates $outpath/input/images/all_profiles.csv file ==="
    echo "===creates $outpath/input/images/all_profiles.xlsx file ==="
    echo "================================================================="
    cp input/images-source/all_profiles.csv input/images/all_profiles.csv
    echo "===find $outpath -name StructureDefinition-*.csv -exec tail -qn +2 {} + >> input/images/all_profiles.csv==="
    find $outpath -name StructureDefinition-*.csv -exec tail -qn +2 {} + >> input/images/all_profiles.csv
    echo "===pyexcel merge input/images/all_profiles.csv input/images all_profiles.xlsx==="
    pyexcel merge input/images/all_profiles.csv input/images/all_profiles.xlsx
fi

if [[ $VIEW_OUTPUT ]]; then
    echo open $PWD/docs/index.html
    open ./$outpath/index.html
fi

if [[ $VIEW_QA ]]; then
    echo open $PWD/docs/qa.html
    open ./$outpath/qa.html
fi
