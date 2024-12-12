library HighRiskExclusions version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers  version '4.0.1' called FHIRHelpers

include HighRiskExclusionsEvents version '1.0.0' called Events
include HighRiskExclusionsActions version '1.0.0' called Actions

context Patient

//------------------------------------------------------------------------------
// RECOMMENDATIONS
//------------------------------------------------------------------------------

define "flow-HighRiskExclusions":
  {
    if Events."eve-geneticrisk" is true
    then if Events."eve-acsgeneticrisk" is true
      then Actions."act-acshighriskmammo"
      else Actions."act-othergeneticrisk"
    else null,
    if Events."eve-geneticrisk" is true and Events."eve-acsgeneticrisk" is true
    then Actions."act-acshighriskmri"
    else null    
  }   
  except { null }

define ACSHighRiskMammo:
  "flow-HighRiskExclusions" R 
    where R.code = Actions."MG Breast Screening" and R.reason = Actions."High risk exclusion"

define ExistsACSHighRiskMammo:
  exists ACSHighRiskMammo

define ACSHighRiskMammoCode:    
  First(ACSHighRiskMammo R return R.code)

define ACSHighRiskMammoTiming:    
  First(ACSHighRiskMammo R return R.timingTiming)

define ACSHighRiskMammoTimingEvent:    
  ACSHighRiskMammoTiming R return First(R.event)

define ACSHighRiskMri:
  "flow-HighRiskExclusions" R 
    where R.code = Actions."MR Breast" and R.reason = Actions."High risk exclusion"

define ExistsACSHighRiskMri:
  exists ACSHighRiskMri

define ACSHighRiskMriCode:    
  First(ACSHighRiskMri R return R.code)

  define ACSHighRiskMriTiming:    
  First(ACSHighRiskMri R return R.timingTiming)

define ACSHighRiskMriTimingEvent:    
  ACSHighRiskMriTiming R return First(R.event)

define SpecialtyReferral:
  "flow-HighRiskExclusions" R where R.code = Actions."Refer to specialist recommendations"

define ExistsSpecialtyReferral:  
  exists SpecialtyReferral

define SpecialtyReferralReason:
  First(SpecialtyReferral R return R.reason)
    


