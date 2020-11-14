/*
Extension:   DEQMMeasureScoring
Id:          extension-measureScoring
Title:       "DEQM Measure Scoring Extension"
Description: "Indicates how the calculation is performed for the measure, including proportion, ratio, continuous-variable, and cohort. The value set is extensible, allowing additional measure scoring types to be represented. It is expected to be the same as the scoring element on the referenced Measure"
* ^context.type = #element
* ^context.expression = "MeasureReport"
* value[x] only CodeableConcept
* valueCodeableConcept.coding.code from http:hl7.org/fhir/ValueSet/measure-scoring (extensible)

Extension:   DEQMSubmitDataUpdateType
Id:          extension-submitDataUpdateType
Title:       "DEQM Submit Data Update Type Extension"
Description: "This Extension supports the concepts 'incremental' and 'snapshot'. The DEQM Consumer Server **SHALL** use this Extension to advertise whether it supports [snapshot](index.html#incremental-update) or [incremental](index.html#snapshot-update) updates for the [DEQM Submit Data transaction](datax.html#submit-data). The DEQM Producer **SHALL** use this Extension to indicate whether the payload is a snapshot or incremental update for Submit Data transactiosn."
* ^context[0].type = #element
* ^context[0].expression = "CapabiltityStatement.rest.resource.operation"
* ^context[1].type = #element
* ^context[1].expression = "MeasureReport"
* value[x] only code
* valueCode from DEQMUpdateTypeValueSet

CodeSystem:  DEQMUpdateTypeCodeSystem
Id:          update-type
Title:       "DEQM Update Type Code System"
Description: "Concepts for how a DEQM Consumer supports data exchange updates. The choices are snapshot or incremental updates"
* #incremental         "Incremental"         "In contrast to the Snapshot Update, the FHIR Parameters resource used in a Submit Data or the Collect Data scenario contains only the new and updated DEQM and QI Core Profiles since the last transaction. If the Consumer supports incremental updates, the contents of the updated payload updates the previous payload data."
* #snapshot       "Snapshot"       "In contrast to the Incremental Update, the FHIR Parameters resource used in a Submit Data or the Collect Data scenario contains all the DEQM and QI Core Profiles for each transaction.  If the Consumer supports snapshot updates, the contents of the updated payload entirely replaces the previous payload"

ValueSet:  DEQMUpdateTypeValueSet
Id:          update-type
Title:       "DEQM Update Type Value Set"
Description: "Concepts for how a DEQM Consumer supports data exchange updates. The choices are snapshot or incremental updates"
* codes from system DEQMUpdateTypeCodeSystem
*/

Extension:   PatientListQuestionnaire
Id:          patientlistquestionnaire
Title:       "Argonaut Patient List Questionnaire"
Description: "A reference to a form definition that is bound to certain types of lists and defines each column for the purpose of providing additional data for each member"
* ^context.type = #element
* ^context.expression = "Group"
* value[x] only Reference
* valueReference only Reference(Questionnaire)

Extension:   PatientListQuestionnaireResponse
Id:          patientlistquestionnaireresponse
Title:       "Argonaut Patient List QuestionnaireResponse"
Description: "A reference to a QuestionnaireResponse of prepopulated data based on a Patient List Questionnaire that is bound to certain types of lists and provides additional data for a Group.member"
* ^context.type = #element
* ^context.expression = "Group.member"
* value[x] only Reference
* valueReference only Reference(QuestionnaireResponse)

Extension:   ResourceDescription
Id:          resourcedescription
Title:       "Resource Description"
Description: "A markdown text natural language description of the resource instance and its use

*Note: The Primary intent of this extension is to illustrate to readers how the implementation guide examples are intended to be used. Production systems SHOULD NOT use this extension.*
"
* ^context.type = #element
* ^context.expression = "Resource.meta"
* value[x] only markdown

Extension:   ResourceName
Id:          resourcename
Title:       "Resource Name"
Description: "A natural language description of the resource instance

*Note: The Primary intent of this extension is to provide natural language names for implementation guide examples. Production systems SHOULD NOT use this extension.*
"
* ^context.type = #element
* ^context.expression = "Resource.meta"
* value[x] only string
