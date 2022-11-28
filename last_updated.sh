inpath=input
for yaml_file in $(find $inpath/resources-yaml/*.yml -type f -mtime -1)
do
echo $yaml_file
#json_file=$inpath/resources/$(basename $yaml_file)
#json_file=${json_file%.*}.json
#echo $json_file
#python3.7 -c 'import sys, yaml, json, datetime; json.dump(yaml.full_load(sys.stdin), sys.stdout, indent=4, default = lambda self:(self.isoformat() if isinstance(self, (datetime.datetime, datetime.date)) else f"YAML to JSON for {self} not serializable"))' < $yaml_file > $json_file
done
fi