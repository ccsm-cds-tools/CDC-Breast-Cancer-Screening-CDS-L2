library SpecialPopulationsActions version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers  version '4.0.1' called FHIRHelpers

include DataElements version '1.0.0' called DataElements

codesystem "ActCode": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/plan-definition-action-code-system'
codesystem "ReasonCode": 'http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/plan-definition-action-reason-code-system'
codesystem "LOINC": 'http://loinc.org'

// Act Codes
code "Refer to specialist recommendations": 'specialtyreferral' from "ActCode" display 'Refer to specialist recommendations'
// Reason Codes
code "High lifetime risk": 'highlifetimerisk' from "ReasonCode" display 'High lifetime risk'

// Standard codes
code "MG Breast Screening": '24606-6' from "LOINC" display 'MG Breast Screening' 
code "MR Breast": '30794-2' from "LOINC" display 'MR Breast' 

context Patient

define mammo_annual:
  {
		code: "MG Breast Screening",
    timingTiming: {
      event: {ToString(@2025-01-25)}, //TODO: placeholder for testing nextduedate
      repeat: {
        frequency: 1,
        period: 1,
        periodUnit: 'a'
      }
    }
	} 

define mri_annual:
  {
		code: "MR Breast",
    timingTiming: {
      event: {ToString(@2025-01-25)}, //TODO: placeholder for testing nextduedate
      repeat: {
        frequency: 1,
        period: 1,
        periodUnit: 'a'
      }
    }
	}

define "act-acshighriskmammo":  
  SetRecommendationReasonTimingAge(mammo_annual, "High lifetime risk", {value: 30.0, code: 'a'})  

define "act-acshighriskmri":
  SetRecommendationReasonTimingAge(mri_annual, "High lifetime risk", {value: 30.0, code: 'a'})  

//define "act-performriskassessment":
  // TODO: Implement logic for act-performriskassessment

define function SetRecommendationReasonTimingAge(
    recommendation Tuple{code System.Code,
      timingTiming Tuple{event List<System.String>,repeat Tuple{frequency System.Integer,period System.Integer,periodUnit System.String}}},
    reason System.Code,
    timingAge Tuple{value Decimal, code String}) 
    returns Tuple {code System.Code,reason System.Code,timingAge Tuple{value Decimal, code String},
      timingTiming Tuple{event List<System.String>,repeat Tuple{boundsPeriod Tuple{start System.String},frequency System.Integer,period System.Integer,periodUnit System.String}}}: 
  Tuple {
    code: recommendation.code,
    reason: reason,
    timingAge: timingAge,
    timingTiming: {
      event: recommendation.timingTiming.event,
      repeat: {
        boundsPeriod: {
          start: ToString(Patient.birthDate + System.Quantity{value: timingAge.value, unit: FHIRHelpers.ToCalendarUnit(timingAge.code)})
        },
        frequency: recommendation.timingTiming.repeat.frequency,
        period: recommendation.timingTiming.repeat.period,
        periodUnit: recommendation.timingTiming.repeat.periodUnit
      }
    }
  }  