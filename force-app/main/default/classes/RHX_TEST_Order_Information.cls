@isTest(SeeAllData=true)
public class RHX_TEST_Order_Information {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM Order_Information__c LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new Order_Information__c()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}