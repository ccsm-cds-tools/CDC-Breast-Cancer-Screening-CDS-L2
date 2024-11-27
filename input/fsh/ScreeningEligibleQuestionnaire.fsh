Instance: ScreeningEligibleQuestionnaire
InstanceOf: http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire
Title: "Screening Eligible"
Usage: #definition
// -----------------------------------------------------------------------------
// This Questionnaire is for screening eligible.
// -----------------------------------------------------------------------------
* meta.profile[+] = "http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire"
* url = Canonical(ScreeningEligibleQuestionnaire)
* version = "1.0.0"
* name = "ScreeningEligible"
* status = http://hl7.org/fhir/publication-status#draft "Draft"
* subjectType = http://hl7.org/fhir/resource-types#Patient "Patient"

* item[+].linkId = "age-in-years"
* item[=].text = "Age in years"
* item[=].type = $ITEMTYPE#integer
* item[=].code = $LNC#30525-0
* item[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
* item[=].extension[=].valueCoding = $UCUM#[a]

* item[+].linkId = "breast-symptoms"
* item[=].text = "New or worsening breast symptoms"
* item[=].type = $ITEMTYPE#boolean
* item[=].code = $SOCS#BreastSymptoms

* item[+].linkId = "breast-findings"
* item[=].text = "New or worsening breast exam findings"
* item[=].type = $ITEMTYPE#boolean
* item[=].code = $SOCS#BreastFindings
