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
  flatten({
    ({SDMContinueScreeningAge} except { null }),
    ({SDMContinueScreeningLifeExp} except { null }),
    Actions."act-highriskexclusions",
    Actions."act-specialpop",
    ({SDMDelayScreeningLactating} except { null }),
    (if Count(Actions."act-highriskexclusions") = 0 and Count(Actions."act-specialpop") = 0
        then Actions."act-avgrisk" else null)
  })
  except { null }

define SDMContinueScreeningAge:
  if Events."eve-AgeOver74" is true
    then Actions."act-sdmcontinueage"
    else null

define ExistsSDMContinueScreeningAge:
  SDMContinueScreeningAge is not null

define SDMContinueScreeningAgeCode:
  SDMContinueScreeningAge.code

define SDMContinueScreeningAgeReason:
  SDMContinueScreeningAge.reason

define SDMContinueScreeningLifeExp:
  if Events."eve-LifeExp" is true
    then Actions."act-sdmcontinuelifexp" as Tuple{code Code, reason Code}
    else null

define ExistsSDMContinueScreeningLifeExp:
  SDMContinueScreeningLifeExp is not null

define SDMContinueScreeningLifeExpCode:
  SDMContinueScreeningLifeExp.code  

define SDMContinueScreeningLifeExpReason:
  SDMContinueScreeningLifeExp.reason  

define SDMDelayScreeningLactating:
  if Count(Actions."act-highriskexclusions") = 0 and Count(Actions."act-specialpop") = 0
      and Events."eve-lactating" is true
    then Actions."act-lactating" as Tuple{code Code, reason Code}
    else null

define ExistsSDMDelayScreeningLactating:
  SDMDelayScreeningLactating is not null

define SDMDelayScreeningLactatingCode:
  SDMDelayScreeningLactating.code   

define SDMDelayScreeningLactatingReason:
  SDMDelayScreeningLactating.reason    