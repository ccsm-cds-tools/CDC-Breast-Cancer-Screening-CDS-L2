library DecisionToScreen version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers  version '4.0.1' called FHIRHelpers
include DecisionToScreenEvents version '1.0.0' called Events
include DecisionToScreenActions version '1.0.0' called Actions

context Patient

//------------------------------------------------------------------------------
// RECOMMENDATIONS
//------------------------------------------------------------------------------

define "flow-DecisionToScreen":  
  {
    (if Events."eve-AgeOver74" is true
    then Actions."act-sdmcontinueage" as Tuple{code Code, reason Code}
    else null),
    (if Events."eve-LifeExp10" is true
    then Actions."act-sdmcontinuelifexp" as Tuple{code Code, reason Code}
    else null),
    flatten({Actions."act-highriskexclusions"}),
    flatten({Actions."act-specialpop"}),
    (if Count(Actions."act-highriskexclusions") = 0 and Count(Actions."act-specialpop") = 0
      and Events."eve-lactating"
    then Actions."act-lactating" as Tuple{code Code, reason Code}
    else null),
    (if Count(Actions."act-highriskexclusions") = 0 and Count(Actions."act-specialpop") = 0
    then flatten({Actions."act-avgrisk"})
    else null)
  }   
  except { null, {} }