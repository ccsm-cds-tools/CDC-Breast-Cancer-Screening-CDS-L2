Alias: $PDACS = http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/plan-definition-action-code-system
Alias: $PDARCS = http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/plan-definition-action-reason-code-system
Alias: $SOCS = http://cancerscreeningcds.github.io/bcsm-cds/CodeSystem/screening-observation-code-system

////////////////////////////////////////////////////////////////////////////////////////////////////

CodeSystem: PlanDefinitionActionCodeSystem
Id: plan-definition-action-code-system
Title: "Plan Definition Action Code System"
Description: "Code representing plan definition action codes"

* ^experimental = true

* #eligible "Eligible for screening"
* #noteligible "Not eligible for screening"
* #error "An error occurred"
* #sdmcontinue "Shared decision making to continue screening"
* #sdmdelay "Shared decision making to delay screening"

ValueSet:    PlanDefinitionActionCodes
Id:          plan-definition-action-codes
Title:       "Plan Definition Action Codes"
Description: "This value set includes action codes for Plan Definitions within this implementation guide."
* ^experimental = true
* include codes from system $PDACS

////////////////////////////////////////////////////////////////////////////////////////////////////

CodeSystem: PlanDefinitionActionReasonCodeSystem
Id: plan-definition-action-reason-code-system
Title: "Plan Definition Action Reason Code System"
Description: "Code representing plan definition action reason codes"

* ^experimental = true

* #eligibleforscreening "Eligible for screening"
* #missingageorbirthdate "Missing patient age in years or birth date"
* #notassignedfemaleatbirth "Not assigned female at birth"
* #currentbreastcancer "Current breast cancer"
* #bilatmastectomy "Bilateral mastectomy"
* #diagtesting "Diagnostic testing"
* #ageover74 "Age over 74 years"
* #lifeexp10 "Life expectancy <10 years"
* #currentlylactating "Currently lactating"

ValueSet:    PlanDefinitionActionReasonCodes
Id:          plan-definition-action-reason-codes
Title:       "Plan Definition Action Reason Codes"
Description: "This value set includes action reason codes for Plan Definitions within this implementation guide."
* ^experimental = true
* include codes from system $PDARCS

////////////////////////////////////////////////////////////////////////////////////////////////////

CodeSystem: ScreeningObservationCodeSystem
Id: screening-observation-code-system
Title: "Screening Observation Code System"
Description: "Code representing breast cancer screening related observations"

* ^experimental = true

* #BreastSymptoms "New or worsening breast symptoms"
* #BreastFindings "New or worsening breast exam findings"
* #LifeExpectancyUnder10Years "Life expectancy <10 years"