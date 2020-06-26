#!/bin/bash
# exit when any command fails
set -e
while getopts twoplisu: option
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
 esac
done
echo "================================================================="
echo === Publish $SOURCE IG!!! $(date -u) ===
echo see 'local workflow.md' file for how to use
echo "Optional Parameters"
echo '-t parameter for no terminology server (run faster and offline)= ' $NA
echo '-w parameter for using watch on igpublisher from source default is off = ' $WATCH
echo '-o parameter for running previous version of the igpublisher= ' $PUB
echo '-p parameter for downloading latest version of the igpublisher from source = ' $UPDATE
#echo '-l parameter for downloading HL7 ig template from source = ' $LOAD_TEMPLATE
#echo '-u parameter for downloading test ig template from source or file= ' $TEST_TEMPLATE
echo '-i parameter for running only ig-publisher = ' $IG_PUBLISH
echo '-s parameter for running only sushi = ' $SUSHI
echo ' current directory =' $PWD
echo "================================================================="
echo getting rid of .DS_Store files since they gum up the igpublisher....
find . -name '.DS_Store' -type f -delete
sleep 1
echo "================================================================="

if [[ $UPDATE ]]; then
echo "========================================================================"
echo "Downloading most recent publisher to:"
echo ~/Downloads/org.hl7.fhir.igpublisher.jar
echo "... it's ~100 MB, so this may take a bit"
mv ~/Downloads/org.hl7.fhir.igpublisher.jar ~/Downloads/org.hl7.fhir.igpublisher-old.jar \
|| mv ../../../Downloads/org.hl7.fhir.igpublisher.jar ../../../Downloads/org.hl7.fhir.igpublisher-old.jar
curl -L https://storage.googleapis.com/ig-build/org.hl7.fhir.publisher.jar \
-o ~/Downloads/org.hl7.fhir.igpublisher.jar \
|| curl -L https://storage.googleapis.com/ig-build/org.hl7.fhir.publisher.jar \
-o ../../../Downloads/org.hl7.fhir.igpublisher.jar
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
rm -rf input output docs
sushi fsh -o .
echo "================================================================="

else

  if [[ $IG_PUBLISH ]]; then
    echo "================================================================="
    echo "=== run the just the igpublisher ==="
    echo "================================================================="

    echo "================================================================="
    echo "=== rename the 'fsh' folder to '_fsh'  ==="
    echo "================================================================="
    [[ -d fsh ]] && mv fsh _fsh

    if [[ $WATCH ]]; then
      echo "================================================================="
      echo === run most recent version of the igpublisher with watch on ===
      echo "================================================================="
      java -Xmx2G -jar ${path} -ig ig.ini -watch -tx $NA

    else
      echo "================================================================="
      echo "===run igpublisher just once \(no watch option\)==="
      echo "================================================================="
      echo java -jar ${path} -ig ig.ini -tx $NA
      java -Xmx2G -jar ${path} -ig ig.ini -tx $NA

      echo "================================================================="
      echo "=== rename the '-fsh' folder to 'fsh'  ==="
      echo "================================================================="
      [[ -d _fsh ]] && mv _fsh fsh

    fi

  else
    echo "================================================================="
    echo "=== run sushi and igpublisher (default) ===="
    echo "================================================================="
    echo "start sushi ......................................................"
    rm -rf input output docs
    sushi fsh -o .
    if [[ $WATCH ]]; then
      echo "================================================================="
      echo === run most recent version of the igpublisher with watch on ===
      echo "================================================================="
      java -Xmx2G -jar ${path} -ig ig.ini -watch -tx $NA

    else
      echo "================================================================="
      echo "===run igpublisher just once \(no watch option\)==="
      echo "================================================================="
      echo java -jar ${path} -ig ig.ini -tx $NA
      java -Xmx2G -jar ${path} -ig ig.ini -tx $NA
    fi

  fi


fi
