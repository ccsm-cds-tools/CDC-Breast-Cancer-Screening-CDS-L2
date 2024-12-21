library ScreeningDue version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers  version '4.0.1' called FHIRHelpers

include ScreeningDueEvents version '1.0.0' called Events
include ScreeningDueActions version '1.0.0' called Actions
include DataElements version '1.0.0' called DataElements

context Patient

define "flow-ScreeningDue":
  true

