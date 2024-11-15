library ScreeningEligibleActions version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers  version '4.0.1' called FHIRHelpers

include DataElements version '1.0.0' called DataElements

codesystem "ActCode": 'http://example.org/CodeSystem/plan-definition-action-code-system'
codesystem "ReasonCode": 'http://example.org/CodeSystem/plan-definition-action-reason-code-system'

// Act Codes
code "Eligible for screening": 'eligible' from "ActCode"
code "Not eligible for screening": 'noteligible' from "ActCode"
// Reason Codes
code "Eligible for screening reason": 'eligibleforscreening' from "ReasonCode"
code "Not assigned female at birth": 'notassignedfemaleatbirth' from "ReasonCode"
code "Current breast cancer": 'currentbreastcancer' from "ReasonCode"

context Patient

define "act-eligible":
  {
    result: true,
		code: "Eligible for screening",
    reason: "Eligible for screening reason"
	}

define "end-noteligible-notassignedfemaleatbirth":
  {
    result: false,
		code: "Not eligible for screening",
    reason: "Not assigned female at birth"
	}

define "end-noteligible-currentbreastcancer":
  {
    result: false,
		code: "Not eligible for screening",
    reason: "Current breast cancer"
	}  

//define "act-dxtesting":
  // TODO: Implement logic for act-dxtesting

