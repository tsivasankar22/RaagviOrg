@isTest
public class slack_tst_Candidate {
	@isTest 
	static void testTrigger() {
		Candidate__c obj0 = new Candidate__c(
			Candidate__c = 's'
		);
		insert obj0;
	}
}