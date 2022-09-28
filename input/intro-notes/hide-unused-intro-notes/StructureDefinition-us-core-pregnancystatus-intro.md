{% include new_page.md %}

**Example Usage Scenarios:**

The following are example usage scenarios for the this profile:

- Query for a patient's pregnancy status
- [Record or update] a past or present pregnancy status

### Mandatory and Must Support Data Elements

The following data-elements must always be present ([Mandatory] definition) or must be supported if the data is present in the sending system ([Must Support] definition). They are presented below in a simple human-readable explanation.  Profile specific guidance and examples are provided as well.  The [Formal Profile Definition] below provides the  formal summary, definitions, and  terminology requirements.

**Each Observation must have:**

1.  a status
2.  a code for pregnancy status observation
3.  a patient
4.  when the observation occurred
5.  the pregnancy status

**Each Observation must support:**

1. a category code of ‘social-history’


**Profile specific implementation guidance:**

- For representing the patient's  *intent* to become pregnant use the [US Core Pregnancy Intent Observation Profile].
- The [US Core Pregnancy Status Codes] value set includes SNOMED CT codes and the HL7 V3 code for the concept "unknown". These codes have historically been used to communicate the pregnancy status of a patient.

{% include link-list.md %}
