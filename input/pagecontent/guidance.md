### Guidance

**Profile specific implementation guidance:**
- Note that *Previous Name* and *Suffix* are listed in the U.S. Core Data for Interoperability.
  - Suffix is represented using the `Patient.name.suffix` element.
  - Previous name is represented by providing an end date in the `Patient.name.period` element for a previous name.
  - The patient example below demonstrates the usage of both of these elements.
- \*The [FHIR Specification]({{site.data.fhir.path}}patient.html#gender) provides guidance and background for representing patient gender. The American Clinical Laboratory Association (ACLA) has published [best practice guidelines](http://www.acla.com/acla-best-practice-recommendation-for-administrative-and-clinical-patient-gender-used-for-laboratory-testing-and-reporting/) for administrative and clinical gender related to laboratory testing and reporting which implementers may find helpful as well.
-  {:.new-content #F24903}The Patient's Social Security Numbers **SHOULD NOT** be used as a patient identifier in `Patient.identifier.value`. There is increasing concern over the use of Social Security Numbers in healthcare due to the risk of identity theft and related issues. Many payers and providers have actively purged them from their systems and filter them out of incoming data.
