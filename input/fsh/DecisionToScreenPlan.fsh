////////////////////////////////////////////////////////////////////////////////////////////////////

Instance: flow-DecisionToScreen
InstanceOf: http://hl7.org/fhir/uv/cpg/StructureDefinition/cpg-computableplandefinition
Title: "Decision to Screen"
Usage: #definition

* insert CPGKnowledgeExtensions
* insert CommonMetadata
* meta.profile[+] = "http://hl7.org/fhir/uv/cpg/StructureDefinition/cpg-computableplandefinition"
* name = "flow-DecisionToScreen"
* description = "Decision to screen logic path."
* type = $PDTYPE#eca-rule
* library[+] = "Library/DecisionToScreen|1.0.0"
// -----------------------------------------------------------------------------
// Action #1: SDM to continue screening for age
// -----------------------------------------------------------------------------
* action[+].id = "SDMContinueScreeningAge"
* action[=].condition[+].kind = $ACKIND#applicability "Applicability"
* action[=].condition[=].expression.language = $EXLANG|4.0.1#text/cql "CQL"
* action[=].condition[=].expression.expression = "ExistsSDMContinueScreeningAge"
* action[=].definitionCanonical = Canonical(CommunicateSDMContinueScreening|1.0.0)
* action[=].dynamicValue[+].path = "reasonCode[0].coding[0]"
* action[=].dynamicValue[=].expression.language = $EXLANG|4.0.1#text/cql "CQL"
* action[=].dynamicValue[=].expression.expression = "SDMContinueScreeningAgeReason"
// -----------------------------------------------------------------------------
// Action #2: SDM to continue screening for age
// -----------------------------------------------------------------------------
* action[+].id = "SDMContinueScreeningLifeExp"
* action[=].condition[+].kind = $ACKIND#applicability "Applicability"
* action[=].condition[=].expression.language = $EXLANG|4.0.1#text/cql "CQL"
* action[=].condition[=].expression.expression = "ExistsSDMContinueScreeningLifeExp"
* action[=].definitionCanonical = Canonical(CommunicateSDMContinueScreening|1.0.0)
* action[=].dynamicValue[+].path = "reasonCode[0].coding[0]"
* action[=].dynamicValue[=].expression.language = $EXLANG|4.0.1#text/cql "CQL"
* action[=].dynamicValue[=].expression.expression = "SDMContinueScreeningLifeExpReason"
// -----------------------------------------------------------------------------
// Action #3: SDM to delay screening for lactation
// -----------------------------------------------------------------------------
* action[+].id = "SDMDelayScreeningLactating"
* action[=].condition[+].kind = $ACKIND#applicability "Applicability"
* action[=].condition[=].expression.language = $EXLANG|4.0.1#text/cql "CQL"
* action[=].condition[=].expression.expression = "ExistsSDMDelayScreeningLactating"
* action[=].definitionCanonical = Canonical(CommunicateSDMDelayScreening|1.0.0)
* action[=].dynamicValue[+].path = "reasonCode[0].coding[0]"
* action[=].dynamicValue[=].expression.language = $EXLANG|4.0.1#text/cql "CQL"
* action[=].dynamicValue[=].expression.expression = "SDMDelayScreeningLactatingReason"

////////////////////////////////////////////////////////////////////////////////////////////////////

Instance: CommunicateSDMContinueScreening
InstanceOf: http://hl7.org/fhir/uv/cpg/StructureDefinition/cpg-computableactivity
Title: "Communicate Shared Decision Making to Continue Screening"
Usage: #definition

* insert CPGKnowledgeExtensions
* insert CommonMetadata
* meta.profile[+] = "http://hl7.org/fhir/uv/cpg/StructureDefinition/cpg-computableactivity"
// * cpg-partOf = Canonical(TopLevelPlanDefinition) // TODO: Tie this into the entire pathway
* url = Canonical(CommunicateSDMContinueScreening)
* name = "CommunicateSDMContinueScreening"
* description = "This ActivityDefinition generates a CommunicationRequest recommending shared decision making on the decision to continue screening."
* kind = $RRTYPE#CommunicationRequest "CommunicationRequest"
* intent = $RINTENT#proposal "Proposal"
* priority = $RPRIOR#routine "Routine"
* code = $PDACS#sdmcontinue "Shared decision making to continue screening"
* code.text = "Shared decision making to continue screening"

////////////////////////////////////////////////////////////////////////////////////////////////////

Instance: CommunicateSDMDelayScreening
InstanceOf: http://hl7.org/fhir/uv/cpg/StructureDefinition/cpg-computableactivity
Title: "Communicate Shared Decision Making to Delay Screening"
Usage: #definition

* insert CPGKnowledgeExtensions
* insert CommonMetadata
* meta.profile[+] = "http://hl7.org/fhir/uv/cpg/StructureDefinition/cpg-computableactivity"
// * cpg-partOf = Canonical(TopLevelPlanDefinition) // TODO: Tie this into the entire pathway
* url = Canonical(CommunicateSDMDelayScreening)
* name = "CommunicateSDMDelayScreening"
* description = "This ActivityDefinition generates a CommunicationRequest recommending shared decision making on the decision to delay screening."
* kind = $RRTYPE#CommunicationRequest "CommunicationRequest"
* intent = $RINTENT#proposal "Proposal"
* priority = $RPRIOR#routine "Routine"
* code = $PDACS#sdmdelay "Shared decision making to delay screening"
* code.text = "Shared decision making to delay screening"

////////////////////////////////////////////////////////////////////////////////////////////////////