library HighRiskExclusionsActions version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers  version '4.0.1' called FHIRHelpers
include DataElements version '1.0.0' called DataElements

codesystem "ActCode": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/plan-definition-action-code-system'
codesystem "ReasonCode": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/plan-definition-action-reason-code-system'
codesystem "LOINC": 'http://loinc.org'

// Act Codes
code "Refer to specialist recommendations": 'specialtyreferral' from "ActCode" display 'Refer to specialist recommendations'
// Reason Codes
code "Other genetic marker or syndrome associated with breast cancer": 'othergeneticrisk' from "ReasonCode" display 'Other genetic marker or syndrome associated with breast cancer'
code "High risk exclusion": 'highriskexclusion' from "ReasonCode" display 'High risk exclusion'

// Standard codes
code "MG Breast Screening": '24606-6' from "LOINC" display 'MG Breast Screening' 
code "MR Breast": '30794-2' from "LOINC" display 'MR Breast' 

context Patient

define "act-othergeneticrisk":
  {
		code: "Refer to specialist recommendations",
    reason: "Other genetic marker or syndrome associated with breast cancer"
	}  

define "act-acshighriskmammo":
  {
		code: "MG Breast Screening",
    reason: "High risk exclusion",
    timingAge: {value: 30, code: 'a'},
    timingTiming: {
      event: {ToString(@2025-01-25)}, //TODO: placeholder for testing nextduedate
      repeat: {
        boundsPeriod: {start: ToString(Patient.birthDate + 30 years)},
        frequency: 1,
        period: 1,
        periodUnit: 'a'
      }
    }
	} 

define "act-acshighriskmri":
  {
		code: "MR Breast",
    reason: "High risk exclusion",
    timingAge: {value: 30, code: 'a'},
    timingTiming: {
      event: {ToString(@2025-01-25)}, //TODO: placeholder for testing nextduedate
      repeat: {
        boundsPeriod: {start: ToString(Patient.birthDate + 30 years)},
        frequency: 1,
        period: 1,
        periodUnit: 'a'
      }
    }
	} 

//define "act-acsintriskmammo":
  // TODO: Implement logic for act-acsintriskmammo

//define "act-startat25yand8yafterRT":
  // TODO: Implement logic for act-startat25yand8yafterRT

//define "act-hxbreastcawithin5y":
  // TODO: Implement logic for act-hxbreastcawithin5y

//define "act-startdateacsrisk":
  // TODO: Implement logic for act-startdateacsrisk

//define "act-noexclusions":
  // TODO: Implement logic for act-noexclusions

