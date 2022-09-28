{% include new_page.md %}

**Example Usage Scenarios:**

The following are example usage scenarios for the this profile:

- Query for a patient's insurance coverage
- [Record or update] a past or present nsurance coverages

### Mandatory and Must Support Data Elements

The following data-elements must always be present ([Mandatory] definition) or must be supported if the data is present in the sending system ([Must Support] definition). They are presented below in a simple human-readable explanation.  Profile specific guidance and examples are provided as well.  The [Formal Profile Definition] below provides the  formal summary, definitions, and  terminology requirements.

**Each Coverage must have:**

1.  health insurance member or subscriber id
2.  a status
3.  the health insurance beneficiary (patient)
4.  beneficiary's relationship to the subscriber
5.  the health insurance issuer (payer)

**Each Coverage must support:**

1. health insurance coverage type (e.g., Medicare)
2. coverage start and/or end date
3. health insurance group and/or plan


**Profile specific implementation guidance:**

<!-- - For representing the patient's *pregnancy status* use the [US Core Pregnancy Status Coverage Profile]. -->

{% include link-list.md %}
