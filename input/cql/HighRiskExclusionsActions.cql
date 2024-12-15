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
code "Genetic risk exclusion": 'geneticriskexclusion' from "ReasonCode" display 'Genetic risk exclusion'
code "History of chest radiation ages 10-30 y": 'chestxrt' from "ReasonCode" display 'History of chest radiation ages 10-30 y'
code "Previous breast cancer": 'hxbreastca' from "ReasonCode" display 'Previous breast cancer'
code "Breast cancer in remission < 5 years": 'hxbreastcawithin5y' from "ReasonCode" display 'Breast cancer in remission < 5 years'
code "Atypical biopsy high lifetime risk": 'atypicalbxhighlifetimerisk' from "ReasonCode" display 'Atypical biopsy high lifetime risk'

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
    timingTiming: {
      event: {ToString(@2025-01-25)}, //TODO: placeholder for testing nextduedate
      repeat: {
        frequency: 1,
        period: 1,
        periodUnit: 'a'
      }
    }
	} 

define "act-acshighriskmri":
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

define "act-acsgeneticriskmammo":
  SetRecommendationReasonTimingAge("act-acshighriskmammo", "Genetic risk exclusion", {value: 30.0, code: 'a'})  

define "act-acsgeneticriskmri":
  SetRecommendationReasonTimingAge("act-acshighriskmri", "Genetic risk exclusion", {value: 30.0, code: 'a'})  

define "act-acsmammoafterRT":
  SetRecommendationReasonTimingAge("act-acshighriskmammo", "History of chest radiation ages 10-30 y", {value: Ageatleast25and8yafterRT, code: 'a'})

define "act-acsmriafterRT":
  SetRecommendationReasonTimingAge("act-acshighriskmri", "History of chest radiation ages 10-30 y", {value: Ageatleast25and8yafterRT, code: 'a'})  

define "act-acsmammoafterbrca":
  SetRecommendationReasonTimingAge("act-acshighriskmammo", "Previous breast cancer", {value: AgeInYears() * 1.0, code: 'a'})

define "act-hxbreastcawithin5y":
  {
		code: "Refer to specialist recommendations",
    reason: "Breast cancer in remission < 5 years"
	}

define "act-acsmammoatypicalbx":
  SetRecommendationReasonTimingAge("act-acshighriskmammo", "Atypical biopsy high lifetime risk", {value: AgeInYears() * 1.0, code: 'a'})  

define "act-acsmriatypicalbx":
  SetRecommendationReasonTimingAge("act-acshighriskmri", "Atypical biopsy high lifetime risk", {value: AgeInYears() * 1.0, code: 'a'})  

define "RadiationTherapyCompletionAge":
  First(DataElements."de-chestxrtage10to30" C).abatement as Age //TODO: support for other choice types (dateTime, Period, etc)
  // note these can't be sorted by abatement due to choice types

//TODO: handling for unavailable dates
define Ageatleast25and8yafterRT:
  if 25 years < Age8yafterRT then
    Age8yafterRT.value
  else
    25  

define Age8yafterRT:    
  "RadiationTherapyCompletionAge" + 8 years    

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