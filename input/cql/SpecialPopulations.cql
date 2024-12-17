library SpecialPopulations version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers  version '4.0.1' called FHIRHelpers

include SpecialPopulationsEvents version '1.0.0' called Events
include SpecialPopulationsActions version '1.0.0' called Actions
include DataElements version '1.0.0' called DataElements

context Patient

define "flow-SpecialPopulations":
  {    
    ACSMammoHighRisk,
    ACSMriHighRisk
  }   
  except { null }

define ACSMammoHighRisk:
  if Events."eve-highlifetimerisk" is true
  then Actions."act-acshighriskmammo" else null       

define ExistsACSMammoHighRisk:
  ACSMammoHighRisk is not null

define ACSMammoHighRiskCode:    
  ACSMammoHighRisk R return R.code

define ACSMammoHighRiskTiming:    
  ACSMammoHighRisk R return R.timingTiming

define ACSMammoHighRiskTimingEvent:    
  ACSMammoHighRiskTiming R return First(R.event)  

define ACSMriHighRisk:
  if Events."eve-highlifetimerisk" is true
  then Actions."act-acshighriskmri" else null       

define ExistsACSMriHighRisk:
  ACSMriHighRisk is not null

define ACSMriHighRiskCode:    
  ACSMriHighRisk R return R.code

define ACSMriHighRiskTiming:    
  ACSMriHighRisk R return R.timingTiming

define ACSMriHighRiskTimingEvent:    
  ACSMriHighRiskTiming R return First(R.event)   