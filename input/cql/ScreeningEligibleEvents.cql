library ScreeningEligibleEvents version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers  version '4.0.1' called FHIRHelpers

include DataElements version '1.0.0' called DataElements

context Patient

define "eve-female":
  DataElements."de-female"

//define "eve-breastca":
  // TODO: Implement logic for eve-breastca

//define "eve-mastectomy":
  // TODO: Implement logic for eve-mastectomy

//define "eve-breastsymptoms":
  // TODO: Implement logic for eve-breastsymptoms

//define "eve-breastfindings":
  // TODO: Implement logic for eve-breastfindings

