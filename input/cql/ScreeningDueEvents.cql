library ScreeningDueEvents version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers  version '4.0.1' called FHIRHelpers
include DataElements version '1.0.0' called DataElements
include CSMCommonFunctions version '1.0.0' called CSMCommonFunctions
include BCSMCommonFunctions version '1.0.0' called BCSMCommonFunctions

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED": 'http://snomed.info/sct'

// Standard codes
code "Breast cancer screening": '268547008' from "SNOMED" display 'Breast cancer screening'
code "MG Breast Screening": '24606-6' from "LOINC" display 'MG Breast Screening' 
code "MR Breast": '30794-2' from "LOINC" display 'MR Breast' 

context Patient

//calculated nextdue logic:
//  +duedate, -interval, -lastreport or +lastreport < duedate = use duedate
//  +duedate, +interval, -lastreport or +lastreport < duedate = use duedate
//  +duedate, -interval, +lastreport > duedate = no prediction
//  +duedate, +interval, +lastreport > duedate = use lastreport + interval
//  -duedate = use CalculateNextDueByCodeAndInterval
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
  CarePlanActivitiesDue A where A.flag in {'DUE', 'OVERDUE'}

define CarePlanActivitiesDue:
  ActiveBreastCancerScreeningCarePlanActivities A
  let lastReport: BCSMCommonFunctions.MostRecentDiagnosticReportByCode(FHIRHelpers.ToConcept(A.detail.code)),
  lastReportDate: FHIRHelpers.ToDateTime(lastReport.effective) as DateTime,
  nextdue: CalculateActivityNextDue(A)
  return {
    activity: A,
    activityCode: A.detail.code,
    nextDue: nextdue,
    scheduledDue: ActivityScheduledDate(A.detail),
    scheduledStart: ((A.detail.scheduled as Timing).repeat.bounds as Period).start,
    scheduledRepeat: (A.detail.scheduled as Timing).repeat,
    lastReportDate: lastReportDate,
    flag: EvaluateFlag(A.detail.scheduled as FHIR.Timing, nextdue)
  } 

//------------------------------------------------------------------------------
// calculated next due
//------------------------------------------------------------------------------

define function CalculateActivityNextDue(activity FHIR.CarePlan.Activity):
  activity A
  let lastReport: BCSMCommonFunctions.MostRecentDiagnosticReportByCode(FHIRHelpers.ToConcept(A.detail.code)),
  lastReportDate: FHIRHelpers.ToDateTime(lastReport.effective) as DateTime,
  duedate: ActivityScheduledDate(A.detail),
  repeat: Tuple{frequency: FHIRHelpers.ToInteger((activity.detail.scheduled as Timing).repeat.frequency),
        period: FHIRHelpers.ToDecimal((activity.detail.scheduled as Timing).repeat.period),
        periodUnit: FHIRHelpers.ToString((activity.detail.scheduled as Timing).repeat.periodUnit)}
  return
    case
      // -duedate = use CalculateNextDueByCodeAndInterval
      when duedate is null then 
        BCSMCommonFunctions.CalculateNextDueByCodeAndInterval(
          FHIRHelpers.ToConcept(A.detail.code), 
          FHIRHelpers.ToDateTime(((activity.detail.scheduled as Timing).repeat.bounds as Period).start),
          repeat)
      // +duedate, -repeat, -lastreport or +lastreport < duedate = use duedate
      when BCSMCommonFunctions.RepeatIsValid(repeat) is false and (lastReport is null or lastReportDate < duedate) then duedate
      // +duedate, +repeat, -lastreport or +lastreport < duedate = use duedate
      when BCSMCommonFunctions.RepeatIsValid(repeat) and (lastReport is null or lastReportDate < duedate) then duedate
      // +duedate, -repeat, +lastreport > duedate = no prediction
      when BCSMCommonFunctions.RepeatIsValid(repeat) is false and lastReport is not null and lastReportDate > duedate then null
      // +duedate, +repeat, +lastreport > duedate = use lastreport + repeat
      when BCSMCommonFunctions.RepeatIsValid(repeat) and lastReport is not null and lastReportDate > duedate then
        date from BCSMCommonFunctions.AddIntervalToDateTime(lastReportDate, repeat)
      // Default case if none of the above conditions are met      
      else null
    end    

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
  NextScheduledActivityByCode(ActiveBreastCancerScreeningCarePlanActivities, "MG Breast Screening")    

define ActiveBreastCancerScreeningCarePlanActivities:
  BreastCancerScreeningCarePlan.activity A
    where A.detail.status in {'not-started', 'scheduled', 'in-progress'}

define function NextScheduledActivityByCode(activities List<FHIR.CarePlan.Activity>, code Code):
  NextScheduledActivity(ActiveBreastCancerScreeningCarePlanActivities A
    where A.detail.code ~ code)  

define function NextScheduledActivity(activities List<FHIR.CarePlan.Activity>):
  Last(activities A sort by ActivityScheduledDate(detail))

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
// flag due/overdue
//------------------------------------------------------------------------------

define function EvaluateFlag(timing FHIR.Timing, nextDueDate DateTime):
  case
    when TimingIsAnnual(timing)
      then EvaluateFlagAnnual(nextDueDate)
    when TimingIsBiennial(timing)
      then EvaluateFlagBiennial(nextDueDate)
    else EvaluateFlagDefault(nextDueDate)
  end

define function EvaluateFlagDefault(nextDueDate DateTime):
  if nextDueDate < Today() - 3 months then
    'OVERDUE'
  else if nextDueDate <= Today() + 2 months or nextDueDate >= Today() - 3 months then
    'DUE'
  else
    'NOT DUE'  

define function EvaluateFlagBiennial(nextDueDate DateTime):
  EvaluateFlagDefault(nextDueDate)

define function EvaluateFlagAnnual(nextDueDate DateTime):
  if nextDueDate < Today() - 2 months then
    'OVERDUE'
  else if nextDueDate <= Today() + 2 months or nextDueDate >= Today() - 3 months then
    'DUE'
  else
    'NOT DUE'   

