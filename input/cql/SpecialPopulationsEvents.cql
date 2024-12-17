library SpecialPopulationsEvents version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers  version '4.0.1' called FHIRHelpers
include DataElements version '1.0.0' called DataElements

context Patient

define "eve-highlifetimerisk":
  DataElements."de-highlifetimerisk"

//define "eve-firstdeggenetic":
  // TODO: Implement logic for eve-firstdeggenetic

//define "eve-breastdensitycord":
  // TODO: Implement logic for eve-breastdensitycord

//define "eve-fhxbrca":
  // TODO: Implement logic for eve-fhxbrca
