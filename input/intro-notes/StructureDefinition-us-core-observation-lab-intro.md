
**Example Usage Scenarios:**

The following are example usage scenarios for the this profile:

-   Query for lab results belonging to a Patient
-  [Record or update] lab results belonging to a Patient

### Mandatory and Must Support Data Elements


The following data-elements must always be present ([Mandatory] definition) or must be supported if the data is present in the sending system ([Must Support] definition). They are presented below in a simple human-readable explanation.  Profile specific guidance and examples are provided as well.  The [Formal Profile Definition] below provides the  formal summary, definitions, and  terminology requirements.  

**Each Observation must have:**

1.   a status
1.   a category code of 'laboratory'
1.   a [LOINC] code, if available, which tells you what is being measured
1.   a patient

**Each Observation must support:**

1. a time indicating when the measurement was taken
1. a result value or a reason why the data is absent*
   - <span class="bg-success" markdown="1">if the result value is coded, a [SNOMED CT] code is one is available</span><!-- new-content -->
   - if the result value is a numeric quantity, a standard [UCUM] unit
2. <span class="bg-success" markdown="1">a specimen type</span><!-- new-content -->

*see guidance below

**Profile specific implementation guidance:**

{% include observation_guidance_1.md category="laboratory" example1=" such as 'chemistry'" example2=" (for example, a 24-Hour Urine Collection test)" %}

{% include link-list.md %}
