Alias: PDACS = http://example.org/CodeSystem/plan-definition-action-code-system
Alias: PDARCS = http://example.org/CodeSystem/plan-definition-action-reason-code-system

////////////////////////////////////////////////////////////////////////////////////////////////////

CodeSystem: PlanDefinitionActionCodeSystem
Id: plan-definition-action-code-system
Title: "Plan Definition Action Code System"
Description: "Code representing plan definition action codes"

* ^experimental = true

* #eligible "Eligible for screening"
* #noteligible "Not eligible for screening"
* #error "An error occurred"

ValueSet:    PlanDefinitionActionCodes
Id:          plan-definition-action-codes
Title:       "Plan Definition Action Codes"
Description: "This value set includes action codes for Plan Definitions within this implementation guide."
* ^experimental = true
* include codes from system PDACS

////////////////////////////////////////////////////////////////////////////////////////////////////

CodeSystem: PlanDefinitionActionReasonCodeSystem
Id: plan-definition-action-reason-code-system
Title: "Plan Definition Action Reason Code System"
Description: "Code representing plan definition action reason codes"

* ^experimental = true

* #eligibleforscreening "Eligible for screening"
* #missingageorbirthdate "Missing patient age in years or birth date"
* #notassignedfemaleatbirth "Not assigned female at birth"

ValueSet:    PlanDefinitionActionReasonCodes
Id:          plan-definition-action-reason-codes
Title:       "Plan Definition Action Reason Codes"
Description: "This value set includes action reason codes for Plan Definitions within this implementation guide."
* ^experimental = true
* include codes from system PDARCS

////////////////////////////////////////////////////////////////////////////////////////////////////