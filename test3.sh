# for k in $(jq '.children.values | keys | .[]' file); do
#     ...
# done

# for k in $(jq ' .exampleCanonical |.definition.resource | .[]' fsh-generated/resources/ImplementationGuide*.json); do
#     echo "$k"

for k in $(jq '.definition.resource[]? | .exampleCanonical' fsh-generated/resources/ImplementationGuide-healthedata1-sandbox.json); do
   echo "$k"
done
