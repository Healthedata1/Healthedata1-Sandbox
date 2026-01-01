#!/bin/bash
# exit when any command fails
set -e
trap "echo '================================================================='; echo '=================== publish.sh DONE! ==================='; echo '================================================================='" EXIT
trap "echo '================================================================='; echo '=================== publish.sh ERROR! ==================='; echo '================================================================='" ERR

while getopts abcdefghijklmnopqrstuvwxyzC option;
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
 j) RAPIDO='-rapido';;
 k) NO_PROFILE=1;;
 l) PAGE_LINKS=1;;
 n) NO_META=1;;
 o) PUB=1;;
 p) UPDATE=1;;
 q) VIEW_QA=1;;
 r) CLEAR_JSON=1;;
 s) SUSHI=1;;
 t) NA='N/A';;
 v) VIEW_OUTPUT=1;;
 x) REM_HIGHLIGHT=1;;
 y) YAML_JSON=1;;
 z) DEL_TEMP=1;;
 C) DEL_CACHE=1;;
 esac

done

# ========= Globals  =================
NA='http://tx.fhir.org'
# GEN_OFF=''
# VAL_OFF=''
inpath=input
examples="$inpath"/examples
resources="$inpath"/resources

if [[ $IN_DOCS ]]; then
  outpath=docs
else
  outpath=output
fi
# Defines the strings to remove
my_strings=(
    '<span class="bg-success" markdown="1">'
    '</span><!-- new-content -->'
    '<div class="bg-success" markdown="1">'
    '</div><!-- new-content -->'
)
# ===================================

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
echo "-c copy data csv files and created excel files to the image/tables folder = $COPY_CSV"
echo "-d flag if output in "docs" folder = $IN_DOCS"
echo "-e flag to add current version to canonicals 'meta.profile' in examples, 'exampleCanonical' in IG resources and 'definitions' and 'supportedProfiles' in CapStatements = $APP_VERSION"
echo "-f flag to add codesystem-ref-all-list.csv and valueset-ref-all-list.csv to data folders to process as tables = $TERMINOLOGY_TABLES"
echo "-g flag to turn off narrative generation to speed up build times = $GEN_OFF"
echo "-h flag to turn off validation to speed up build times = $VAL_OFF"
echo "-i parameter for running only ig-publisher = $IG_PUBLISH"
echo "-j parameter for speeding up the build = $RAPIDO"
echo "-k remove the meta.profile elements from all the examples = $NO_PROFILE"
echo "-l flag to add or update the page-link-list to the input/includes folder (run after successful build before new build) = $PAGE_LINKS"
echo "-n remove the meta.extension elements from all the examples = $NO_META"
echo "-o parameter for running previous version of the igpublisher= $PUB"
echo "-p parameter for downloading latest version of the igpublisher from source = $UPDATE"
echo "-q view qa output in current browser = ./$outpath/qa.html  =  $VIEW_QA"
echo "-r remove all generated json files = $CLEAR_JSON"
echo "-s parameter for running only sushi = $SUSHI"
echo "-t parameter for no terminology server (run faster and offline)= $NA"
echo "-v view ig home page  in current browser = ./$outpath/index.html  =  $VIEW_OUTPUT"
echo "-x remove change highlighting from all markdown files =  $REM_HIGHLIGHT"
echo "-y delete all json files and tranform all yaml files to json files = $YAML_JSON"
echo "-z delete the template and temp directories before publishing (slows build but needed when rename files and change templates)= $DEL_TEMP"
echo "-C delete the input-cache before publishing (slows build but needed when rename files and change templates)= $DEL_TEMP"
echo "================================================================="
echo getting rid of .DS_Store files since they gum up the igpublisher....
find $PWD -name '.DS_Store' -type f -delete
sleep 1

echo "# ================================================="
echo "# ==== checking if All JSON files are valid.  ====="
echo "# ================================================="

for file in "$examples"/*.json "$resources"/*.json fsh-generated/resources/*.json
do
    [ -f "$file" ] || continue # Skip if the glob didn't match any files (the pattern itself is returned)
    if ! jq . "$file" > /dev/null; then
        echo "ERROR: Invalid JSON in $file"
        echo "jq says: $(jq . "$file" 2>&1 >/dev/null | sed 's/^/    /')"
        exit 1
    fi
done
echo "All JSON files are valid."
sleep 1

echo "# ================================================="
echo "# ==== checking for nulls in JSON files.  ====="
echo "# ================================================="

for file in "$examples"/*.json "$resources"/*.json fsh-generated/resources/*.json
do
    [ -f "$file" ] || continue # Skip if the glob didn't match any files (the pattern itself is returned)
    path=$(jq -r 'paths(type == "null" or (type == "array" and length == 0)) | join(".")' "$file" 2>/dev/null | head -1)
    if [ -n "$path" ]; then
        # Found something bad
        echo "Error: Found null or empty array in $file at: $path"
        exit 1
    fi
done
   echo "No null values or empty arrays."
sleep 1

CSV_FILE="input/data/profile_metadata.csv"
if [ -f "$CSV_FILE" ]; then
  echo ""
  echo "===================================================================="
  echo "Checking for missing resources in $CSV_FILE..."
  missing_count=0
  for filepath in "$resources"/StructureDefinition-*.json; do
      resource_id=$(jq -r '.id' "$filepath")
      if ! awk -F',' -v id="$resource_id" '$2 == id {found=1; exit} END {exit !found}' "$CSV_FILE"; then
          echo "❌ Missing: $resource_id (from $(basename "$filepath"))"
          ((missing_count++))
      fi
  done
  echo ""
  [ $missing_count -eq 0 ] && echo "✅ All resource IDs are present in the CSV_FILE!" || echo "⚠️  Found $missing_count resource(s) missing from CSV_FILE"
  echo "====================================================================="
  echo ""
  sleep 1
fi


if [[ $DEL_TEMP ]]; then
echo "================================================================="
echo rm -r template temp
read -p "Do you want to continue? (y/N) " answer
echo "================================================================="
if [[ "$answer" == "y" ]]; then
    echo "Continuing..."
    rm -r template temp
else
    echo "Operation cancelled by user."
    exit 1
fi
fi

if [[ $DEL_CACHE ]]; then
echo "================================================================="
echo rm -r input-cache
read -p "Do you want to continue? (y/N) " answer
echo "================================================================="
if [[ "$answer" == "y" ]]; then
    echo "Continuing..."
    rm -r input-cache
else
    echo "Operation cancelled by user."
    exit 1
fi
fi

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

if [[ $REM_HIGHLIGHT ]]; then
echo "================================================================="
echo "remove change highlighting from all markdown files"
echo "================================================================="
find "$inpath" -type f -name "*.md" | while read -r file_path; do
    # Skip files with "generator" or "tabler" in their names
    if [[ "$file_path" == *"generator"* || "$file_path" == *"tabler"* ]]; then
        echo "Skipping file: $file_path"
        continue
    fi

    # Process each file
    temp_file=$(mktemp)
    cp "$file_path" "$temp_file"
    for string_to_remove in "${my_strings[@]}"; do
        # Use sed to remove the string from the file (macOS-compatible)
        sed -i '' "s|$string_to_remove||g" "$file_path"
    done
    if ! cmp -s "$file_path" "$temp_file"; then
        echo "Tags removed successfully from file: $file_path!"
    fi
done
echo "================================================================="
echo "Tags removed successfully. Check for any remaining tags manually"
echo " and clear the new stuff file..."
echo "================================================================="
fi

if [[ $PAGE_LINKS ]]; then
  echo "================================================================="
  echo "Add or update the page-link-list to the input/includes folder"
  echo "SINCE IT READS THE PAGES DATA FILES, RUN AFTER SUCCESSFUL BUILD AND BEFORE SUSHI"
  echo "jq -r 'to_entries[] | \"[\(.value | .title)]: \(.key)\"' temp/pages/_data/pages.json > input/includes/page-link-list.md"
  echo "================================================================="

  # Write boilerplate warning and jq output to the file
  {
    echo "<!--"
    echo "WARNING: This file is auto-generated by the page-link-list script"
    echo "at https://github.com/Healthedata1/Healthedata1-Sandbox/blob/master/publish.sh"
    echo "It is created from temp/pages/_data/pages.json using jq to extract page titles and relative URLs"
    echo "to create a link-list file."
    echo "DO NOT EDIT THIS FILE MANUALLY, as changes will be overwritten on the next build."
    echo "To update links, modify the source data in the pages and sushi-config.yaml file and rebuild the site."
    echo "-->"
    echo ""
    jq -r 'to_entries[] | "[\(.value | .title)]: \(.key)"' temp/pages/_data/pages.json
  } > input/includes/page-link-list.md
fi

if [[ $YAML_JSON ]] && test -d  $inpath/resources-yaml; then
echo "========================================================================"
echo "delete all yaml created json files is resources directory and"
echo "convert all yml files in resources-yaml directory to json files"
echo "outgoingPython 3.7 and PyYAML, json and sys modules are required"
echo "rm -f $inpath/resources/StructureDefinition*.json"
echo "rm -f $inpath/resources/OperationDefinition*.json"
echo "rm -f $inpath/resources/CodeSystem*.json"
echo "rm -f $inpath/resources/ValueSet*.json"
echo "========================================================================"

rm -f $inpath/resources/StructureDefinition*.json
rm -f $inpath/resources/OperationDefinition*.json
rm -f $inpath/resources/CodeSystem*.json
rm -f $inpath/resources/ValueSet*.json

rm  -f $inpath/resources/structuredefinition*.json
rm  -f $inpath/resources/operationdefinition*.json
rm  -f $inpath/resources/codesystem*.json
rm  -f $inpath/resources/valueset*.json

for yaml_file in $(find $inpath/resources-yaml/*.yml -type f) # -mtime -$days)
do
echo convert $yaml_file to ...
json_file=$inpath/resources/$(basename $yaml_file)
json_file=${json_file%.*}.json
python3.7 -c 'import sys, yaml, json, datetime; json.dump(yaml.full_load(sys.stdin), sys.stdout, indent=4, default = lambda self:(self.isoformat() if isinstance(self, (datetime.datetime, datetime.date)) else f"YAML to JSON for {self} not serializable"))' < $yaml_file > $json_file
echo $json_file
done
fi


if [[ $YAML_JSON ]] && test -d $inpath/examples-yaml; then
echo "========================================================================"
echo "delete all json files in $examples and"
echo "convert all yml files in examples-yaml directory to json files and move to $examples"
echo "outgoingPython 3.7 and PyYAML, json and sys modules are required"
echo "rm -f $examples/*.json"
echo #========================================================================"

rm -f $examples/*.json
for yaml_file in $(find $inpath/examples-yaml/*.yml -type f) # -mtime -$days)
do
echo convert $yaml_file to ...
json_file=$examples/$(basename $yaml_file)
json_file=${json_file%.*}.json
python3.7 -c 'import sys, yaml, json, datetime; json.dump(yaml.full_load(sys.stdin), sys.stdout, indent=4, default = lambda self:(self.isoformat() if isinstance(self, (datetime.datetime, datetime.date)) else f"YAML to JSON for {self} not serializable"))' < $yaml_file > $json_file
echo $json_file
done
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

if [[ $NO_META ]]
then
  if compgen -G "$examples/*.json" = /dev/null
  then
    echo "================================================================="
    echo "===remove the meta extension element from all the examples in $examples==="
    echo "================================================================="
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
  else
      echo "================================================================="
      echo "===no files in the $examples folder ==="
      echo "================================================================="
  fi
fi

if [[ $NO_PROFILE ]]
then
  if compgen -G "$examples/*.json" = /dev/null
  then
    echo "=========================================================================="
    echo "===remove the meta profile element from all the examples in $examples ==="
    echo "===side effect is removal of meta extension if no source or lastupdated?  ======"
    echo "========================================================================="
    tmp=$(mktemp -d -d ./input/_examples)
    # echo "========= tmp is $tmp ==========="
    for file in $examples/*.json
      do
      jq  'walk(if type=="object" and  (.source or .lastUpdated)
        then del(.profile)
        else if type=="object" and .meta.profile
        then del(.meta)
        else . end
         end)' < $file > $tmp/$(basename $file)
      done
    mv -f $tmp/*.json $examples
    rm -rf $tmp
  else
      echo "================================================================="
      echo "=== no files in the $examples folder ==="
      echo "================================================================="
  fi
fi

if [[ $APP_VERSION ]]; then
    echo "================================================================="
    echo "=== update example files meta profiles to the current version  ==="
    echo "=== and update IG.yml file example Canonicals to the current version =="
    echo "=== and update CapabilityStatement canonicals to the current version =="
    echo "================================================================="
    IGJSON=$(echo fsh-generated/resources/ImplementationGuide*.json)
    echo "========= IGJSON is $IGJSON ==========="
    tmp=$(mktemp -d _examples)

    trap 'rm -rf "$tmp"' EXIT # Clean up on exit
    echo "========= tmp is $tmp ==========="
    ver=$(jq -r '.version' $IGJSON)
    # canon=$(jq -r '.url | split("/ImplementationGuide/")[0]' $IGJSON)
    canon=http://hl7.org/fhir/us/core/
    echo "========= canon is $canon ==========="
    echo "========= current version is $ver ==========="
    for file in $examples/*.json
      do
        [ -f "$file" ] || continue     # Skip if the glob didn't match any files (the pattern itself is returned)
        jq --arg ver "$ver" --arg canon "$canon" '
          if .meta.profile? then
            .meta.profile |= map(
              if contains($canon) then sub("(\\|[^|]*$)|$"; "|" + $ver) else . end
            )
          else . end
          ' < "$file" > "$tmp/$(basename "$file")"
        done
    if ls "$tmp"/*.json >/dev/null 2>&1; then  # Skip if glob didn't match (no examples)
        mv -f "$tmp"/*.json "$examples"
    fi
    echo "========= example files meta.profile updated to $ver ==========="
    # update ig json file
    jq --arg ver "$ver" --arg canon "$canon" '
      .definition?.resource[] |=
        if .exampleCanonical != null and (.exampleCanonical | contains($canon)) then
         .exampleCanonical |= sub("(\\|[^|]*$)|$"; "|" + $ver)
        else . end
           ' "$IGJSON" > "$tmp/ig.json"
    mv -f "$tmp"/*.json "$IGJSON"
    echo "========= IG.json definition.resource.exampleCanonicals updated to $ver ==========="
    # update capstatement supportedProfile[], operation[].definition  ,and searchParam[].definition
    for file in input/resources/CapabilityStatement*.json
      do
        [ -f "$file" ] || continue     # Skip if the glob didn't match any files (the pattern itself is returned)
        jq --arg ver "$ver" --arg canon "$canon" '
          ( .rest[]?.resource[]?.operation[]?.definition,
          .rest[]?.resource[]?.searchParam[]?.definition,
          .rest[]?.resource[]?.supportedProfile[]? ) |=
            if . != null and contains($canon) then
              sub("(\\|[^|]*$)|$"; "|" + $ver)
            else . end
            ' < "$file" > "$tmp/$(basename "$file")"
      done
    if ls "$tmp"/*.json >/dev/null 2>&1; then  # Skip if glob didn't match (no capstatements)
        mv -f "$tmp"/*.json "$resources"
    fi
    echo "========= Cap Statement files canonicals updated to $ver ==========="
    # rm -rf "$tmp"
fi

if [[ $IG_PUBLISH ]]; then
  echo "================================================================="
  echo "=== run the just the igpublisher ==="
  echo "==To run in command line mode, run the IG Publisher like this:=="
  echo "===java -Xmx12G -Dfile.encoding=UTF-8 -jar publisher.jar -ig [source] -no-sushi (-tx [url]) (-packages [directory]) (-generation-off)
(-validation-off) (-debug)
parameters:==="
  echo "================================================================="

    echo java -Xmx12G -Dfile.encoding=UTF-8 -jar ${path} -ig ig.ini -tx $NA -no-sushi $GEN_OFF $VAL_OFF $DEBUG_ON $RAPIDO
    java -Xmx12G -Dfile.encoding=UTF-8 -jar ${path} -ig ig.ini -tx $NA -no-sushi $GEN_OFF $VAL_OFF $DEBUG_ON $RAPIDO
fi


if [[ $TERMINOLOGY_TABLES ]]; then
    echo "================================================================="
    echo "======= cp $outpath/valueset-ref-all-list.csv $inpath/data ======"
    echo "======= cp $outpath/codesystem-ref-all-list.csv $inpath/data ===="
    echo "================================================================="
    cp $outpath/valueset-ref-all-list.csv $inpath/data
    cp $outpath/codesystem-ref-all-list.csv $inpath/data
fi

if [[ $VIEW_OUTPUT ]]; then
    echo "=============== open $PWD/$outpath/index.html ================"
    open ./$outpath/index.html
fi

if [[ $VIEW_QA ]]; then
    echo "============ open $PWD/$outpath/qa.html ============"
    open ./$outpath/qa.html
fi

