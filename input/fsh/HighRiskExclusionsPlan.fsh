////////////////////////////////////////////////////////////////////////////////////////////////////

Instance: flow-HighRiskExclusions
InstanceOf: http://hl7.org/fhir/uv/cpg/StructureDefinition/cpg-computableplandefinition
Title: "High Risk Exclusions"
Usage: #definition

* insert CPGKnowledgeExtensions
* insert CommonMetadata
* meta.profile[+] = "http://hl7.org/fhir/uv/cpg/StructureDefinition/cpg-computableplandefinition"
* name = "flow-HighRiskExclusions"
* description = "High risk exclusions logic path."
* type = $PDTYPE#eca-rule
* library[+] = "Library/HighRiskExclusions|1.0.0"
// -----------------------------------------------------------------------------
// Action #1: Annual screeening mammogram starting age 30 recommendation
// -----------------------------------------------------------------------------
* action[+].id = "acshighriskmammo"
* action[=].title = "Annual screeening mammogram starting age 30"
* action[=].condition[+].kind = $ACKIND#applicability "Applicability"
* action[=].condition[=].expression.language = $EXLANG|4.0.1#text/cql "CQL"
* action[=].condition[=].expression.expression = "ExistsACSHighRiskMammo"
* action[=].definitionCanonical = Canonical(BreastScreeningServiceRequest|1.0.0)
* action[=].dynamicValue[+].path = "%action.code[0].coding[0]"
* action[=].dynamicValue[=].expression.language = $EXLANG|4.0.1#text/cql "CQL"
* action[=].dynamicValue[=].expression.expression = "ACSHighRiskMammoCode"
* action[=].dynamicValue[+].path = "%action.timingTiming"
* action[=].dynamicValue[=].expression.language = $EXLANG|4.0.1#text/cql "CQL"
* action[=].dynamicValue[=].expression.expression = "ACSHighRiskMammoTiming"
* action[=].dynamicValue[+].path = "code.coding[0]"
* action[=].dynamicValue[=].expression.language = $EXLANG|4.0.1#text/cql "CQL"
* action[=].dynamicValue[=].expression.expression = "ACSHighRiskMammoCode"
* action[=].dynamicValue[+].path = "occurrenceDateTime"
* action[=].dynamicValue[=].expression.language = $EXLANG|4.0.1#text/cql "CQL"
* action[=].dynamicValue[=].expression.expression = "ACSHighRiskMammoTimingEvent"
// -----------------------------------------------------------------------------
// Action #2: Annual screeening MRI starting age 30 recommendation
// -----------------------------------------------------------------------------
* action[+].id = "acshighriskmri"
* action[=].title = "Annual screeening MRI starting age 30"
* action[=].condition[+].kind = $ACKIND#applicability "Applicability"
* action[=].condition[=].expression.language = $EXLANG|4.0.1#text/cql "CQL"
* action[=].condition[=].expression.expression = "ExistsACSHighRiskMri"
* action[=].definitionCanonical = Canonical(BreastScreeningServiceRequest|1.0.0)
* action[=].dynamicValue[+].path = "%action.code[0].coding[0]"
* action[=].dynamicValue[=].expression.language = $EXLANG|4.0.1#text/cql "CQL"
* action[=].dynamicValue[=].expression.expression = "ACSHighRiskMriCode"
* action[=].dynamicValue[+].path = "%action.timingTiming"
* action[=].dynamicValue[=].expression.language = $EXLANG|4.0.1#text/cql "CQL"
* action[=].dynamicValue[=].expression.expression = "ACSHighRiskMriTiming"
* action[=].dynamicValue[+].path = "code.coding[0]"
* action[=].dynamicValue[=].expression.language = $EXLANG|4.0.1#text/cql "CQL"
* action[=].dynamicValue[=].expression.expression = "ACSHighRiskMriCode"
* action[=].dynamicValue[+].path = "occurrenceDateTime"
* action[=].dynamicValue[=].expression.language = $EXLANG|4.0.1#text/cql "CQL"
* action[=].dynamicValue[=].expression.expression = "ACSHighRiskMriTimingEvent"
// -----------------------------------------------------------------------------
// Action #3: Recommendation for speciality referral
// -----------------------------------------------------------------------------
* action[+].id = "othergeneticrisk"
* action[=].condition[+].kind = $ACKIND#applicability "Applicability"
* action[=].condition[=].expression.language = $EXLANG|4.0.1#text/cql "CQL"
* action[=].condition[=].expression.expression = "ExistsSpecialtyReferral"
* action[=].definitionCanonical = Canonical(CommunicateSpecialtyReferral|1.0.0)
* action[=].dynamicValue[+].path = "reasonCode[0].coding[0]"
* action[=].dynamicValue[=].expression.language = $EXLANG|4.0.1#text/cql "CQL"
* action[=].dynamicValue[=].expression.expression = "SpecialtyReferralReason"

////////////////////////////////////////////////////////////////////////////////////////////////////

Instance: BreastScreeningServiceRequest
InstanceOf: http://hl7.org/fhir/uv/cpg/StructureDefinition/cpg-computableactivity
Title: "Breast Screening Service Request"
Usage: #definition

* insert CPGKnowledgeExtensions
* insert CommonMetadata
* meta.profile[+] = "http://hl7.org/fhir/uv/cpg/StructureDefinition/cpg-computableactivity"
// * cpg-partOf = Canonical(TopLevelPlanDefinition) // TODO: Tie this into the entire pathway
* url = Canonical(BreastScreeningServiceRequest)
* name = "BreastScreeningServiceRequest"
* description = "This ActivityDefinition generates a ServiceRequest for screening study."
* kind = $RRTYPE#ServiceRequest "ServiceRequest"
* intent = $RINTENT#proposal "Proposal"
* priority = $RPRIOR#routine "Routine"
* library[+] = "Library/HighRiskExclusions|1.0.0"
* dynamicValue[+].path = "occurrenceDateTime"
* dynamicValue[=].expression.language = $EXLANG|4.0.1#text/cql "CQL"
* dynamicValue[=].expression.expression = "ACSHighRiskMammoTimingEvent"

////////////////////////////////////////////////////////////////////////////////////////////////////

Instance: CommunicateSpecialtyReferral
InstanceOf: http://hl7.org/fhir/uv/cpg/StructureDefinition/cpg-computableactivity
Title: "Communicate Recommendation to refer to specialist"
Usage: #definition

* insert CPGKnowledgeExtensions
* insert CommonMetadata
* meta.profile[+] = "http://hl7.org/fhir/uv/cpg/StructureDefinition/cpg-computableactivity"
* url = Canonical(CommunicateSpecialtyReferral)
* name = "CommunicateSpecialtyReferral"
* description = "This ActivityDefinition generates a CommunicationRequest recommending specialty referral."
* kind = $RRTYPE#CommunicationRequest "CommunicationRequest"
* intent = $RINTENT#proposal "Proposal"
* priority = $RPRIOR#routine "Routine"
* code = $PDACS#specialtyreferral "Refer to specialist recommendations"
* code.text = "Refer to specialist recommendations"