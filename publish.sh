#!/bin/bash
# exit when any command fails
set -e
trap "echo '================================================================='; echo '=================== publish.sh DONE! ==================='; echo '================================================================='" EXIT
trap "echo '================================================================='; echo '=================== publish.sh ERROR! ==================='; echo '================================================================='" ERR
# trap "echo '=== rename the input/_fsh folder to input/fsh  ==='; mv input/_fsh input/fsh" EXIT
# trap "echo '=== rename the input/_fsh folder to input/fsh  ==='; mv input/_fsh input/fsh" ERR
NA='http://tx.fhir.org'
GEN_OFF=''
VAL_OFF=''
while getopts abcdefghikmnopqrstvxyz option;
do
 case "${option}"
 in
 a) COPY_SPS=1;;
 b) DEBUG_ON='-debug';;
 c) COPY_CSV=1;;
 d) IN_DOCS=1;;
 e) APP_VERSION=1;;
 f) TERMINOLOGY_TABLES=1;;
 g) GEN_OFF='-generation-off';;
 h) VAL_OFF='-validation-off';;
 i) IG_PUBLISH=1;;
 k) NO_PROFILE=1;;
#  l) LOAD_TEMPLATE=1;;
 m) MERGE_CSV=1;;
 n) NO_META=1;;
 o) PUB=1;;
 p) UPDATE=1;;
 q) VIEW_QA=1;;
 r) CLEAR_JSON=1;;
 s) SUSHI=1;;
 t) NA='N/A';;
#  u) TEST_TEMPLATE=$OPTARG;;
 v) VIEW_OUTPUT=1;;
#  w) WATCH=1;;
 x) RECENT_YAML=1;;
 y) YAML_JSON=1;;
 z) ZIP_SCH=1;;
 esac
 
done

inpath=input
if [[ $IN_DOCS ]]; then
  outpath=docs
else
  outpath=output
fi

if [[ $RECENT_YAML ]]; then
  YAML_JSON=1
  All_YAML=0
  days=1
elif [[ $YAML_JSON ]]; then
  All_YAML=1
  days=400 # 400 days is about 1 year
fi


echo "================================================================="
echo "-d flag if output in "docs" folder =  $IN_DOCS"
echo "current directory = $PWD"
echo "outpath=$outpath"
echo "inpath=$inpath"
echo "================================================================="

echo "================================================================="
echo === Publish $SOURCE IG!!! $(date -u) ===
echo "================================================================="
echo "Optional Parameters"
echo "================================================================="
echo "-a copy searchparameter excel sheet to data folder as csv file for creating SP artifacts = $COPY_SPS"
echo "-b Turns on debugging (this produces extra logging, and can be verbose) = $DEBUG_ON"
echo "-c copy data csv files to the image folder and create excel file too (currently only input/data/uscdi-table.csv,assessments-valuesets.csv) = $COPY_CSV"
echo "-d flag if output in "docs" folder = $IN_DOCS"
echo "-e flag to add current profile version to all examples = $APP_VERSION"
echo "-f flag to add valueset-ref-all-list.csv and valueset-ref-all-list.csv to data folders to process as tables = $TERMINOLOGY_TABLES"
echo "-g flag to turn off narrative generation to speed up build times = $GEN_OFF"
echo "-h flag to turn off validation to speed up build times = $VAL_OFF"
echo "-i parameter for running only ig-publisher = $IG_PUBLISH"
echo "-k remove the meta.profile elements from all the examples = $NO_PROFILE"
echo "-m merge all StructureDefinition csv files with single header = $MERGE_CSV"
echo "-n remove the meta.extension elements from all the examples = $NO_META"
echo "-o parameter for running previous version of the igpublisher= $PUB"
echo "-p parameter for downloading latest version of the igpublisher from source = $UPDATE"
echo "-q view qa output in current browser = ./$outpath/qa.html  =  $VIEW_QA"
echo "-r remove all generated json files = $CLEAR_JSON"
echo "-s parameter for running only sushi = $SUSHI"
echo "-t parameter for no terminology server (run faster and offline)= $NA"
echo "-v view ig home page  in current browser = ./$outpath/index.html  =  $VIEW_OUTPUT"
echo "-x tranform all yaml that changed in the last day to json files  = $RECENT_YAML"
echo "-y tranform all yaml that changed in the last year to json files = $All_YAML"
echo "-z zip up all schematrons = $ZIP_SCH"
#echo "-w parameter for using watch on igpublisher from source default is off = $WATCH"
#echo '-l parameter for downloading HL7 ig template from source = ' $LOAD_TEMPLATE
#echo '-u parameter for downloading test ig template from source or file= ' $TEST_TEMPLATE
echo "================================================================="
echo getting rid of .DS_Store files since they gum up the igpublisher....
find $PWD -name '.DS_Store' -type f -delete
sleep 1

if [[ $COPY_CSV ]]; then
echo "================================================================="
echo cp input/data/*.csv input/images/tables
echo "================================================================="
cp input/data/*.csv input/images/tables
echo "================================================================="
echo convert input/data/*.csv to excel and move to input/images/tables
echo "================================================================="
for csv_file in $(find input/data/*.csv -type f)
do
echo convert $csv_file to ...
excel_file=input/images/tables/$(basename $csv_file)
excel_file=${excel_file%.*}.xlsx
pyexcel transcode $csv_file $excel_file
echo $excel_file
done
fi

# if [[ $COPY_SPS ]]; then
# echo "================================================================="
# echo copy searchparameter excel sheet to data folder as csv file for creating SP artifacts
# echo MAKE SURE THE SP SHEET IS UNFILTERED IN EXCEL BEFORE RUNNING THIS COMMAND
# echo "================================================================="
# echo "================================================================="
# echo "=== hit 'Y' to confirm that the sheet is unfiltered ===="
# echo "=== else 'N' or ctrl-c to exit ==="
# echo "================================================================="

# read var1

# echo "================================================================="
# echo "==================== you typed '$var1' ============================"
# echo "================================================================="
# if [ $var1 == "Y" ]; then
# echo "================================================================="
# echo "=== pyexcel transcode --sheet-name sps input/resources_spreadsheets/uscore-server.xlsx input/data/uscore-sps.csv ==="
# pyexcel transcode --sheet-name sps input/resources_spreadsheets/uscore-server.xlsx input/data/uscore-sps.csv
# fi
# fi

# if [[ $CLEAR_JSON ]]; then
# echo "================================================================="
# echo "remove all generated files in /examples and /resources folders"
# echo "=====MAKE SURE YOU TO DO THIS BEFORE CONTINUING===="
# echo "================================================================="
# echo "================================================================="
# echo "=== hit 'Y' to continue ===="
# echo "=== else 'N' or ctrl-c to exit ==="
# echo "================================================================="

# read var1

# echo "================================================================="
# echo "==================== you typed '$var1' ============================"
# echo "================================================================="
# if [ $var1 == "Y" ]; then
# rm  -f $inpath/resources/*.* $inpath/examples/*.*
# fi
# fi

if [[ $YAML_JSON ]] && ls -U $inpath/resources-yaml/*.yml; then
echo "========================================================================"
echo "convert all yml files in resources-yaml directory to json files"
echo "outgoingPython 3.7 and PyYAML, json and sys modules are required"
for yaml_file in $(find $inpath/resources-yaml/*.yml -type f -mtime -$days)
do
echo convert $yaml_file to ...
json_file=$inpath/resources/$(basename $yaml_file)
json_file=${json_file%.*}.json
python3.7 -c 'import sys, yaml, json, datetime; json.dump(yaml.full_load(sys.stdin), sys.stdout, indent=4, default = lambda self:(self.isoformat() if isinstance(self, (datetime.datetime, datetime.date)) else f"YAML to JSON for {self} not serializable"))' < $yaml_file > $json_file
echo $json_file
done
fi

if [[ $YAML_JSON ]] && ls -U $inpath/examples-yaml/*.yml; then
echo "========================================================================"
echo "convert all yml files in examples-yaml directory to examples/json files"
echo "outgoingPython 3.7 and PyYAML, json and sys modules are required"
for yaml_file in $(find $inpath/examples-yaml/*.yml -type f -mtime -$days)
do
echo convert $yaml_file to ...
json_file=$inpath/examples/$(basename $yaml_file)
json_file=${json_file%.*}.json
python3.7 -c 'import sys, yaml, json, datetime; json.dump(yaml.full_load(sys.stdin), sys.stdout, indent=4, default = lambda self:(self.isoformat() if isinstance(self, (datetime.datetime, datetime.date)) else f"YAML to JSON for {self} not serializable"))' < $yaml_file > $json_file
echo $json_file
done
fi

if [[ $YAML_JSON ]] && ls -U $inpath/includes-yaml/*.yml; then
echo "======================================================================="
echo "convert all yml files in includes-yaml directory to json files"
echo "outgoingPython 3.7 and PyYAML, json and sys modules are required"
for yaml_file in $(find $inpath/includes-yaml/*.yml -type f -mtime -$days)
do
echo convert $yaml_file to ...
json_file=$inpath/includes/$(basename $yaml_file)
json_file=${json_file%.*}.json
python3.7 -c 'import sys, yaml, json, datetime; json.dump(yaml.full_load(sys.stdin), sys.stdout, indent=4, default = lambda self:(self.isoformat() if isinstance(self, (datetime.datetime, datetime.date)) else f"YAML to JSON for {self} not serializable"))' < $yaml_file > $json_file
echo $json_file
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
    python3.7 -c 'import sys, yaml, json; yaml.dump(json.load(sys.stdin), sys.stdout, sort_keys=False, indent=2,)' < $ig_json > $ig_yaml
    echo "========== ig_yaml = $ig_yaml =========="
    done

  echo "================================================================="

fi

if [[ $NO_META ]]; then
    echo "================================================================="
    echo "===remove the meta extension element from all the examples==="
    echo "================================================================="
    examples=./input/examples
    echo "======== example folder is $examples ==========="
    tmp=$(mktemp -d -d ./input/_examples)
    # echo "========= tmp is $tmp ==========="
    for file in $examples/*.json
      do
        # echo "file is $file"
        # echo "basename is $(basename $file)"
                jq 'if (.meta.profile or .meta.lastUpdated) then del(.meta.extension) else del(.meta) end' < $file > $tmp/$(basename $file)

      done
    mv -f $tmp/*.json $examples
    rm -rf $tmp
fi

if [[ $NO_PROFILE ]]; then
    echo "================================================================="
    echo "===remove the meta profile element from all the examples==="
    echo "================================================================="
    examples=./input/examples
    echo "======== example folder is $examples ==========="
    tmp=$(mktemp -d -d ./input/_examples)
    # echo "========= tmp is $tmp ==========="
    for file in $examples/*.json
      do
        # echo "file is $file"
        # echo "basename is $(basename $file)"
                jq 'if (.meta.extension or .meta.lastUpdated) then del(.meta.profile) else del(.meta) end' < $file > $tmp/$(basename $file)

      done
    mv -f $tmp/*.json $examples
    rm -rf $tmp
fi

if [[ $APP_VERSION ]]; then
    echo "================================================================="
    echo "=== append current version to each json example file meta profiles ==="
    echo "=== and update IG.json file exampleCanonicals to teh current version =="
    echo "================================================================="
    examples=$inpath/examples
    echo "======== example folder is $examples ==========="
    IGJSON=$(echo fsh-generated/resources/ImplementationGuide*.json)
    echo "========= IGJSON is $IGJSON ==========="
    tmp=$(mktemp -d -d $inpath/_examples)
    echo "========= tmp is $tmp ==========="
    ver=$(jq -r '.version' $IGJSON)
    canon=$(jq -r '.url | split("/ImplementationGuide/")[0]' $IGJSON)
    echo "========= canon is $canon ==========="
    echo "========= current version is $ver ==========="
    for file in $examples/*.json
      do
        # echo "file is $file"
        # echo "basename is $(basename $file)"
                jq --arg ver "$ver" --arg canon "$canon" 'if (.meta.profile and (.meta.profile[0] | contains($canon)) ) then .meta.profile[0] += "|"+ $ver else . end' < $file > $tmp/$(basename $file)
      done
    mv -f $tmp/*.json $examples
    # update ig json file
    jq --arg ver "$ver" --arg canon "$canon" '.definition.resource = [.definition.resource[] | if .exampleCanonical then if .exampleCanonical | contains($canon) then .exampleCanonical += "|" + $ver else . end else . end]' $IGJSON > $tmp/ig.json 
    mv $tmp/ig.json $IGJSON
    rm -rf $tmp
fi


if [[ $IG_PUBLISH ]]; then
  echo "================================================================="
  echo "=== run the just the igpublisher ==="
  echo "==To run in command line mode, run the IG Publisher like this:=="
  echo "===java -Xmx4G -Dfile.encoding=UTF-8 -jar publisher.jar -ig [source] -no-sushi (-tx [url]) (-packages [directory]) (-generation-off) 
(-validation-off) (-debug)
parameters:==="
  echo "================================================================="

  # echo "================================================================="
  # echo "=== rename the 'input/fsh' folder to 'input/_fsh'  ==="
  # echo "================================================================="
  # [[ -d input/fsh ]] && mv input/fsh input/_fsh

    echo java -Xmx6G -Dfile.encoding=UTF-8 -jar ${path} -ig ig.ini -tx $NA -no-sushi $GEN_OFF $VAL_OFF $DEBUG_ON
    java -Xmx6G -Dfile.encoding=UTF-8 -jar ${path} -ig ig.ini -tx $NA -no-sushi $GEN_OFF $VAL_OFF $DEBUG_ON
fi

  # else
  #   echo "================================================================="
  #   echo "=== run sushi and igpublisher (default) ===="
  #   echo "================================================================="
  #   echo "start sushi ......................................................"
  #   rm -rf output docs
  #   sushi .
  #   inpath=fsh-generated/resources
  #   echo "========================================================================"
  #   echo "convert ig.json to ig.yml and copy to input/data"
  #   echo "outgoingPython 3.7 and PyYAML, json and sys modules are required"
  #   for ig_json in $inpath/ImplementationGuide*.json
  #     do
  #     echo "========== ig_json = $ig_json =========="
  #     ig_yaml='input/data/ig.yml'
  #     python3.7 -c 'import sys, yaml, json, datetime; yaml.dump(json.load(sys.stdin), sys.stdout, indent=2, sort_keys=False)' < $ig_json > $ig_yaml
  #     echo "========== ig_yaml = $ig_yaml =========="
  #     done

  #   if [[ $WATCH ]]; then
  #     echo "================================================================="
  #     echo === run most recent version of the igpublisher with watch on ===
  #     echo "================================================================="
  #     java -Xmx4G -jar ${path} -ig ig.ini -watch -tx $NA

  #   else
  #     echo "================================================================="
  #     echo "===run igpublisher just once \(no watch option\)==="
  #     echo "================================================================="
  #     echo java -jar ${path} -ig ig.ini -tx $NA
  #     java -Xmx4G -jar ${path} -ig ig.ini -tx $NA
  #   fi

  # fi

# fi

if [[ $TERMINOLOGY_TABLES ]]; then
    echo "================================================================="
    echo "======= cp $outpath/valueset-ref-all-list.csv $inpath/data ======"
    echo "======= cp $outpath/codesystem-ref-all-list.csv $inpath/data ===="
    echo "================================================================="
    cp $outpath/valueset-ref-all-list.csv $inpath/data
    cp $outpath/codesystem-ref-all-list.csv $inpath/data
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
    echo "=============== open $PWD/$outpath/index.html ================"
    open ./$outpath/index.html
fi

if [[ $VIEW_QA ]]; then
    echo "============ open $PWD/$outpath/qa.html ============"
    open ./$outpath/qa.html
fi
