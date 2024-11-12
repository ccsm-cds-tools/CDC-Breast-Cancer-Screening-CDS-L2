library DataElements version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers  version '4.0.1' called FHIRHelpers

//------------------------------------------------------------------------------
// CODE SYSTEMS, VALUE SETS, AND CODES
//------------------------------------------------------------------------------

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "RXNORM": 'http://www.nlm.nih.gov/research/umls/rxnorm'
codesystem "ICD-9": 'http://hl7.org/fhir/sid/icd-9-cm'
codesystem "ICD-10": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "GENDER-IDENTITY": 'http://hl7.org/fhir/gender-identity'

// Standard codes
code "Gender Identity": '76691-5' from "LOINC" display 'Gender identity'
code "Transgender Male Code": 'transgender-male' from "GENDER-IDENTITY" display 'transgender male'
code "Female-to-male Transsexual": '407377005' from "SNOMED-CT" display 'Female-to-male transsexual (finding)'

/***** BEGIN CDS LOGIC ********************************************************/

context Patient

//------------------------------------------------------------------------------
// PERTINENT DEMOGRAPHICS
//------------------------------------------------------------------------------

// Sex assigned at birth
define "de-female":
  Female or TransgenderMale
    
define BirthSex:
  (Patient.extension) E
    where E.url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex'

define BirthSexPresent:
  Exists(BirthSex)

define FemaleBirthSex:
  Exists(
    (BirthSex) E
      where E.value = 'F'
  )

define UnknownBirthSex:
  exists(
    (BirthSex) E
      where (
        E.value = 'ASKU' or
        E.value = 'OTH' or
        E.value = 'UNK'
      )
  )

define BirthSexMissingOrUnknown:
  not BirthSexPresent or
  UnknownBirthSex

define BirthSexCode:
  if BirthSexMissingOrUnknown then 'Unknown'
  else Coalesce(BirthSex.value.value)

define BirthSexText:
  if BirthSexCode = 'F' then 'Female'
  else if BirthSexCode = 'M' then 'Male'
  else 'Unknown'

// Patient Gender
define FemaleGender:
  Patient.gender.value = 'female'

define Female:
  FemaleBirthSex or
  (BirthSexMissingOrUnknown and FemaleGender)

define GenderIdentityExtension:
  (Patient.extension) E
    where
      E.url = 'http://hl7.org/fhir/StructureDefinition/patient-genderIdentity' or
      E.url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-genderIdentity'

define TransgenderMaleExtension:
  (GenderIdentityExtension) E
    where
      E.value as FHIR.CodeableConcept ~ "Transgender Male Code" or
      E.value as FHIR.CodeableConcept ~ "Female-to-male Transsexual"

define GenderIdentityObservation:
  [Observation: "Gender Identity"]

define TransgenderMaleObservation:
  (GenderIdentityObservation) O
  where O.value as FHIR.CodeableConcept ~ "Transgender Male Code"
  or O.value as FHIR.CodeableConcept ~ "Female-to-male Transsexual"

define TransgenderMale:
  Exists(TransgenderMaleExtension) or Exists(TransgenderMaleObservation)

define FemaleorTransgenderMale:
  Female or TransgenderMale

define GenderText:
  if Exists(GenderIdentityExtension) then GenderIdentityExtension[0].value.coding[0].code.value
  else Patient.gender.value

