global class CaseBatchApexTaskSchedular implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        CaseBatchApexTask caseSchedule= new CaseBatchApexTask();
        Database.executeBatch(caseSchedule);
    }
}