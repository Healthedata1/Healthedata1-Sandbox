rm -r input output docs
sushi fsh -o .
cp fsh\ig-data\ig.bak ig.ini
java -Xmx2G -jar input-cache/org.hl7.fhir.publisher.jar -ig ig.ini