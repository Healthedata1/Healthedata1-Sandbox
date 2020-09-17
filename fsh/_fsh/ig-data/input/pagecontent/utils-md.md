
## Transaction Bundler utility

- inputs = resource as pyfhir model to append to bundle and existing bundle as pyfhir model to append to.



```python
from fhir_model_generator.model import bundle, organization
from datetime import datetime, date, timedelta
import uuid
import FHIR_templates as f
from json import dumps
```


```python
def bundle_me(pyfhir_res, fhir_bundle=None):
    file_ts = datetime.utcnow().strftime('%Y%m%d%H%M%S%f')
    new_urn = uuid.uuid1().urn # new urn for resource
    pyfhir_res.id = new_urn[9:]
    e = bundle.BundleEntry()
    e.fullUrl = new_urn
    e.resource = pyfhir_res
    e.request = bundle.BundleEntryRequest()
    e.request.method = 'POST'
    e.request.url = pyfhir_res.resource_type
    if fhir_bundle: #add entry
        pass
    else:  # create transaction bundle
        bundle_type = 'transaction'
        bundle_id = f'transaction-bundle-{file_ts}'   
        fhir_bundle = bundle.Bundle(
            dict(
                id = bundle_id,
                type = bundle_type,
                timestamp = str(datetime.utcnow()),
                entry = [],
            )
        )
    fhir_bundle.entry.append(e)
    return(fhir_bundle)
```


```python
if __name__ == "__main__": 
    org = organization.Organization(f.example_org)
    tbundle = bundle_me(org)
    print(dumps(tbundle.as_json(),indent=2))
 
```

    {
      "resourceType": "Bundle",
      "id": "transaction-bundle-20200504204652182578",
      "type": "transaction",
      "timestamp": "2020-05-04 20:46:52.183069",
      "entry": [
        {
          "fullUrl": "urn:uuid:6209ee7e-8e48-11ea-9b63-a4d18ccf5172",
          "resource": {
            "resourceType": "Organization",
            "id": "6209ee7e-8e48-11ea-9b63-a4d18ccf5172",
            "meta": {
              "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization"
              ]
            },
            "text": {
              "status": "generated",
              "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative with Details</b></p><p><b>id</b>: example-organization-2</p><p><b>meta</b>: </p><p><b>identifier</b>: 1407071236, 121111111</p><p><b>active</b>: true</p><p><b>type</b>: Healthcare Provider <span style=\"background: LightGoldenRodYellow\">(Details : {http://terminology.hl7.org/CodeSystem/organization-type code 'prov' = 'Healthcare Provider', given as 'Healthcare Provider'})</span></p><p><b>name</b>: Acme Clinic</p><p><b>telecom</b>: ph: (+1) 734-677-7777, customer-service@acme-clinic.org</p><p><b>address</b>: 3300 Washtenaw Avenue, Suite 227 Amherst MA 01002 USA </p></div>"
            },
            "identifier": [
              {
                "system": "http://hl7.org.fhir/sid/us-npi",
                "value": "1407071236"
              },
              {
                "system": "http://example.org/fhir/sid/us-tin",
                "value": "121111111"
              }
            ],
            "active": true,
            "type": [
              {
                "coding": [
                  {
                    "system": "http://terminology.hl7.org/CodeSystem/organization-type",
                    "code": "prov",
                    "display": "Healthcare Provider"
                  }
                ]
              }
            ],
            "name": "Acme Clinic",
            "telecom": [
              {
                "system": "phone",
                "value": "(+1) 734-677-7777"
              },
              {
                "system": "email",
                "value": "customer-service@acme-clinic.org"
              }
            ],
            "address": [
              {
                "line": [
                  "3300 Washtenaw Avenue, Suite 227"
                ],
                "city": "Amherst",
                "state": "MA",
                "postalCode": "01002",
                "country": "USA"
              }
            ]
          },
          "request": {
            "method": "POST",
            "url": "Organization"
          }
        }
      ]
    }



```python

```
