library HighRiskExclusionsEvents version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers  version '4.0.1' called FHIRHelpers
include DataElements version '1.0.0' called DataElements

context Patient

define "eve-geneticrisk":
  DataElements."de-geneticrisk"

//define "eve-chestxrt":
  // TODO: Implement logic for eve-chestxrt

//define "eve-ageatleast25and8yafterRT":
  // TODO: Implement logic for eve-ageatleast25and8yafterRT

//define "eve-hxbreastca":
  // TODO: Implement logic for eve-hxbreastca

//define "eve-hxbreastcawithin5y":
  // TODO: Implement logic for eve-hxbreastcawithin5y

//define "eve-atypicalbx":
  // TODO: Implement logic for eve-atypicalbx

//define "eve-highlifetimerisk":
  // TODO: Implement logic for eve-highlifetimerisk

define "eve-acsgeneticrisk":
  DataElements."de-acsgeneticrisk"

define "eve-ageatleast30":
  AgeInYears() >= 30

