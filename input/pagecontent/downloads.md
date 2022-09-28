![Meow](cat.jpg)  

![Meow](custom_org_logo.jpg)  

here is the master file tree

{% include foo.md %}

~~~
.
├── INSTALLATION.md
├── README.md
├── SUSHI-GENERATED-FILES.md
├── _genonce.bat
├── _updatePublisher.bat
├── build-vars.cmd
├── build.bat
├── build.sh
├── fsh
│   ├── SUSHI-GENERATED-FILES.md
│   ├── config.yaml
│   ├── ig-data
│   │   └── input
│   │       ├── examples
│   │       ├── images
│   │       │   ├── cat.jpg
│   │       │   ├── custom_org_logo.jpg
│   │       │   └── liquid
│   │       │       ├── Bundle.liquid
│   │       │       └── Subscription.liquid
│   │       └── pagecontent
│   │           ├── StructureDefinition-backport-subscription-intro.md
│   │           ├── downloads.md
│   │           └── index.md
│   ├── my-extensions.fsh
│   ├── package-list.json
│   ├── package.json
│   └── sample-fsh-files
│       ├── BackportNotification.fsh
│       └── BackportSubscription.fsh
├── ig.ini
├── input-cache
│   ├── schemas
│   │   ├── R4
│   │   │   ├── fhir-single.xsd
│   │   │   ├── fhir-xhtml.xsd
│   │   │   ├── xml.xsd
│   │   │   └── xmldsig-core-schema.xsd
│   │   └── R5
│   │       ├── fhir-single.xsd
│   │       ├── fhir-xhtml.xsd
│   │       ├── xml.xsd
│   │       └── xmldsig-core-schema.xsd
│   └── txcache
│       ├── all-systems.cache
│       └── version.ctl
├── package-list.json
├── package.json
└── publish.sh
~~~

I put all my pages etc in input folder but that is not the right place it should go in the optional ig-data/input.  The input folder is generated output and belongs it root. This is confusing to simplify FSH is now:

~~~
.
├── BackportNotification.fsh
├── BackportSubscription.fsh
├── SUSHI-GENERATED-FILES.md
├── config.yaml  <- NEW in Beta Sushi- see http://build.fhir.org/ig/HL7/fhir-shorthand/branches/beta/sushi.html#configuration-file  obviates the need for a separate ig.ini ( which I removed ), menu.xml (which I edited) and package-list.json (which I did not remove)
├── ig-data
│   └── input
│       ├── examples
│       ├── images
│       │   ├── cat.jpg
│       │   ├── custom_org_logo.jpg
│       │   └── liquid
│       │       └── Subscription.liquid
│       └── pagecontent
│           ├── actors_and_transactions.md
│           ├── downloads.md
│           ├── errors.md
│           ├── index.md
│           └── overview.md
├── package-list.json
└── package.json
~~~


<!-- ### Cross Version Comparisons

The table below summarizes the different profiles and resource types between Argonaut Data Query and major releases of US Core :

{ % include dstu2-r4-table.md % } -->



