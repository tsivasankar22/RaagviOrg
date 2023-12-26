/* global class CompareCurrentTimeMetaDataCountyTime implements Database.Batchable<sObject> {
    global List<String> billingCountryLabels;

    global Database.QueryLocator start(Database.BatchableContext bc) {
        // Construct a dynamic SOQL query using the billing country labels
        String query = 'SELECT Id, BillingCountry FROM Account WHERE BillingCountry IN :billingCountryLabels';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<sObject> scope) {
        // Process each account in the current batch
        for (sObject obj : scope) {
            Account acc = (Account) obj;
            String billingCountry = acc.BillingCountry;
            compareBillingCountry(billingCountry);
        }
    }

    private void compareBillingCountry(String billingCountry) {
        List<BillingCountryTime__mdt> billingCountryTimes = [SELECT ClosingTime__c, TimeZone__c, MasterLabel FROM BillingCountryTime__mdt WHERE MasterLabel = :billingCountry];

        if (!billingCountryTimes.isEmpty()) {
            BillingCountryTime__mdt billingCountryTime = billingCountryTimes[0];
            Time metaDataTime = getTimeFromClosingTime(billingCountryTime.ClosingTime__c);
            Time adjustedCurrentTime = getAdjustedCurrentTime(billingCountryTime.TimeZone__c);

            if (metaDataTime == adjustedCurrentTime) {
                String matchTime = String.valueOf(metaDataTime.hour()) + ':' + String.valueOf(metaDataTime.minute());
                String matchdata = getMatchingBillingCountry(matchTime);

                List<Account> matchAccounts = [SELECT Id, BillingCountry FROM Account WHERE BillingCountry = :matchdata];
                System.debug('matchAccounts: ' + matchAccounts);
            }
        }
    }

    private Time getTimeFromClosingTime(String closingTime) {
        String[] strTimeSplit = closingTime.split(':');
        return Time.newInstance(Integer.valueOf(strTimeSplit[0]), Integer.valueOf(strTimeSplit[1]), 0, 0);
    }

    private String getMatchingBillingCountry(String matchTime) {
        List<BillingCountryTime__mdt> billingCountryTimes = [SELECT MasterLabel FROM BillingCountryTime__mdt WHERE ClosingTime__c = :matchTime];

        if (!billingCountryTimes.isEmpty()) {
            return billingCountryTimes[0].MasterLabel;
        }

        return null;
    }

    private Time getAdjustedCurrentTime(String timeZoneValue) {
        DateTime now = DateTime.now();
        TimeZone timeZone = TimeZone.getTimeZone(timeZoneValue);
        String adjustedTimeString = now.format('HH:mm', timeZoneValue);
        String[] adjustedTimeSplit = adjustedTimeString.split(':');
        return Time.newInstance(Integer.valueOf(adjustedTimeSplit[0]), Integer.valueOf(adjustedTimeSplit[1]), 0, 0);
    }

    global void finish(Database.BatchableContext bc) {
    }
}
 */
 global class CompareCurrentTimeMetaDataCountyTime implements Schedulable, Database.Batchable<sObject> {
    global List<String> billingCountryLabels;

    global void execute(SchedulableContext sc) {
        // Retrieve the metadata county names and store them in the billingCountryLabels variable
        billingCountryLabels = new List<String>();

        // Retrieve the metadata county names and add them to the billingCountryLabels list
        List<BillingCountryTime__mdt> metadataCounties = [SELECT MasterLabel FROM BillingCountryTime__mdt];
        for (BillingCountryTime__mdt county : metadataCounties) {
            billingCountryLabels.add(county.MasterLabel);
        }
        //  System.debug('billingCountryLabels----------------' + billingCountryLabels);
        // Retrieve the current time
        DateTime now = DateTime.now();        
        // Iterate over the billing country labels
        for (String billingCountry : billingCountryLabels) {
            List<BillingCountryTime__mdt> billingCountryTimes = [SELECT ClosingTime__c, TimeZone__c, MasterLabel FROM BillingCountryTime__mdt WHERE MasterLabel = :billingCountry];
            if (!billingCountryTimes.isEmpty()) {
                BillingCountryTime__mdt billingCountryTime = billingCountryTimes[0];
                Time metaDataTime = getTimeFromClosingTime(billingCountryTime.ClosingTime__c);
                Time adjustedCurrentTime = getAdjustedCurrentTime(billingCountryTime.TimeZone__c, now);
                if (metaDataTime == adjustedCurrentTime) {
                    String matchTime = String.valueOf(metaDataTime.hour()) + ':' + String.valueOf(metaDataTime.minute());
                    String matchData = getMatchingBillingCountry(matchTime);
                    if (matchData != null) {
                        List<Account> matchAccounts = [SELECT Id, BillingCountry FROM Account WHERE BillingCountry = :matchData];
                        System.debug('matchAccounts: ' + matchAccounts);
                        // Start the batch execution if there are matching accounts
                        if (!matchAccounts.isEmpty()) {
                            Database.executeBatch(this);
                            break; // Exit the loop after starting the batch
                        }
                        else{
                            System.debug('No records Found');
                        }
                    }
                }
            }
        }
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // Construct a dynamic SOQL query using the billing country labels
        String query = 'SELECT Id, BillingCountry FROM Account WHERE BillingCountry IN :billingCountryLabels';
     //   System.debug('query-------------------' + query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<sObject> scope) {
        // Process each account in the current batch
        for (sObject obj : scope) {
            Account acc = (Account) obj;
        }
    }
    private Time getTimeFromClosingTime(String closingTime) {
        String[] strTimeSplit = closingTime.split(':');
        return Time.newInstance(Integer.valueOf(strTimeSplit[0]), Integer.valueOf(strTimeSplit[1]), 0, 0);
    }
    private String getMatchingBillingCountry(String matchTime) {
        List<BillingCountryTime__mdt> billingCountryTimes = [SELECT MasterLabel FROM BillingCountryTime__mdt WHERE ClosingTime__c = :matchTime];
        if (!billingCountryTimes.isEmpty()) {
            return billingCountryTimes[0].MasterLabel;
        }
        return null;
    }
    private Time getAdjustedCurrentTime(String timeZoneValue, DateTime now) {
        TimeZone timeZone = TimeZone.getTimeZone(timeZoneValue);
        String adjustedTimeString = now.format('HH:mm', timeZoneValue);
        String[] adjustedTimeSplit = adjustedTimeString.split(':');
        return Time.newInstance(Integer.valueOf(adjustedTimeSplit[0]), Integer.valueOf(adjustedTimeSplit[1]), 0, 0);
    }
    global void finish(Database.BatchableContext bc) {
        // Perform any post-batch execution logic if needed
    }
}