library ScreeningDueEvents version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers  version '4.0.1' called FHIRHelpers
include DataElements version '1.0.0' called DataElements
include CSMCommonFunctions version '1.0.0' called CSMCommonFunctions

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED": 'http://snomed.info/sct'

// Standard codes
code "Breast cancer screening": '268547008' from "SNOMED" display 'Breast cancer screening'
code "MG Breast Screening": '24606-6' from "LOINC" display 'MG Breast Screening' 
code "MR Breast": '30794-2' from "LOINC" display 'MR Breast' 

context Patient

//modify L2 calculated nextdue logic:
//  +duedate, -interval, -lastreport or +lastreport < duedate = use duedate
//  +duedate, +interval, -lastreport or +lastreport < duedate = use duedate
//  +duedate, -interval, +lastreport > duedate = no prediction
//  +duedate, +interval, +lastreport > duedate = use lastreport + interval
//  -duedate, +interval, -lastreport = use interval.start or use today (still due until marked completed)
//  -duedate, +interval, +lastreport = use lastreport + interval
//  -duedate, -interval, +lastreport = no prediction
//  -duedate, -interval, -lastreport = use today (still due until marked completed)
// mammogram only and in age range:
//  +duedate, -interval, +lastreport > duedate = use lastreport + 24mos
//  -duedate, -interval, +lastreport = use lastreport + 24mos
//  no activity = use today
//return{
//  activity: FHIR.Activity
//  activityCode: FHIR.Activity.detail.code
//  nextdue: calculated date
//  scheduleddue: FHIR.Activity.detail.scheduled.event
//  scheduledstart: FHIR.Activity.detail.scheduled.repeat.boundsPeriod.start
//  scheduledrepeat: FHIR.Activity.detail.scheduled.repeat
//  lastReportDate: DiagnosticReport date
//  flag: "NOT DUE", "DUE", "OVERDUE", none
//}

define "eve-nextdueexists":
  ActivityScheduledDate(MammogramScheduledActivity.detail) is not null

define "eve-due":
  ActiveBreastCancerScreeningCarePlanActivities A
  return {
    activity: A,
    due: EvaluateDueDate(A.detail.scheduled as FHIR.Timing, ActivityScheduledDate(A.detail))
  }

//------------------------------------------------------------------------------
// Care plan
//------------------------------------------------------------------------------

define BreastCancerScreeningCarePlan:
  MostRecentActiveBreastCancerScreeningCarePlan

define MostRecentActiveBreastCancerScreeningCarePlan:
  Last(ActiveBreastCancerScreeningCarePlans C sort by Coalesce(
    start of period,
    created)
  )      

define ActiveBreastCancerScreeningCarePlans:
  [CarePlan] C
    where C.status = 'active'
      and exists C.category cat where cat ~ "Breast cancer screening"

//------------------------------------------------------------------------------
// Activity
//------------------------------------------------------------------------------

define MammogramScheduledActivity:
  NextDueActivity(ActiveBreastCancerScreeningCarePlanActivities A
    where A.detail.code ~ "MG Breast Screening")    

define ActiveBreastCancerScreeningCarePlanActivities:
  BreastCancerScreeningCarePlan.activity A
    where A.detail.status in {'not-started', 'scheduled', 'in-progress'}

define function NextDueActivity(activities List<FHIR.CarePlan.Activity>):
  Last(activities A sort by ActivityScheduledDate(detail))    

//------------------------------------------------------------------------------
// calculated next due
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// scheduled due date
//------------------------------------------------------------------------------

define function ActivityScheduledDate(detail FHIR.CarePlan.Activity.Detail):
  Coalesce(
    MostRecentTimingEvent(detail.scheduled as FHIR.Timing),
    (detail.scheduled as FHIR.Period)."start".value,
    (detail.scheduled as FHIR.Period)."end".value
  )

define function MostRecentTimingEvent(timing FHIR.Timing):
  Last(timing.event E sort asc).value 

//------------------------------------------------------------------------------
// scheduled frequency
//------------------------------------------------------------------------------

define function TimingIsAnnual(timing FHIR.Timing):
  if timing.repeat.frequency = 1 and timing.repeat.period = 1 and timing.repeat.periodUnit = 'a' 
  then true else false

define function TimingIsBiennial(timing FHIR.Timing):
  if timing.repeat.frequency = 1 and timing.repeat.period = 2 and timing.repeat.periodUnit = 'a' 
  then true else false

//------------------------------------------------------------------------------
// last report date
//------------------------------------------------------------------------------

define CodeList: {
  Code '12345-6' from "LOINC",
  Code '67890-1' from "LOINC",
  Code '23456-7' from "LOINC"
}

define DiagnosticReportsActivityCodes:
  [DiagnosticReport] R
    where FHIRHelpers.ToConcept(R.code) in CodeList

define MostRecentReportPerCode:
  distinct (DiagnosticReportsActivityCodes R return R.code) C
    return 
    CSMCommonFunctions.MostRecentDiagnosticReport(DiagnosticReportsActivityCodes R2 where R2.code = C)

//------------------------------------------------------------------------------
// flag due/overdue
//------------------------------------------------------------------------------

define function EvaluateDueDate(timing FHIR.Timing, nextDueDate DateTime):
  case
    when TimingIsAnnual(timing)
      then EvaluateDueDateAnnual(nextDueDate)
    when TimingIsBiennial(timing)
      then EvaluateDueDateBiennial(nextDueDate)
    else EvaluateDueDateDefault(nextDueDate)
  end

define function EvaluateDueDateDefault(nextDueDate DateTime):
  if nextDueDate < Today() - 3 months then
    'OVERDUE'
  else if nextDueDate <= Today() + 2 months or nextDueDate >= Today() - 3 months then
    'DUE'
  else
    'NOT DUE'  

define function EvaluateDueDateBiennial(nextDueDate DateTime):
  EvaluateDueDateDefault(nextDueDate)

define function EvaluateDueDateAnnual(nextDueDate DateTime):
  if nextDueDate < Today() - 2 months then
    'OVERDUE'
  else if nextDueDate <= Today() + 2 months or nextDueDate >= Today() - 3 months then
    'DUE'
  else
    'NOT DUE'   

