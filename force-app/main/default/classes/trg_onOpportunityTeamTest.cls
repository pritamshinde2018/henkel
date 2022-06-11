@isTest
public class trg_onOpportunityTeamTest 
{
    @isTest
    public static void testOpportunityTeam()
    {
        Test.startTest();
        Account acc = new Account(name='test1',Industry='Banking');
        insert acc;
        Contact c = new Contact(Lastname = 'test1',MailingPostalcode = '110001', MailingCountry='India',AccountId=acc.id,Email='test@nanostuffs.com');
        insert c;
        Opportunity opp = new Opportunity(Contact2__c = c.id,AccountId = acc.id,StageName = 'First delivery in purchase order',CloseDate = System.today(),Name='test');
        insert opp;
        opp.Adhesive_Potential_Basis_Annual_Turnover__c=256363636943.00;
        opp.Is_it_a_focus_industry__c=true;
        opp.Appointment_Date_with_SSE__c = System.today();
        
        update opp;
        
        User user = new User();
        user.FirstName = 'test';
        user.LastName = 'demo';
        user.Email = 'test.demo@henkel.com';
        user.PostalCode = '110001';
        user.Phone = '+91 8329380527';
        user.MobilePhone = '+91 8329380527';
        user.Username = 'test.demo@henkel.com.newdev';
        user.Alias = 'swathika';
        user.TimeZoneSidKey = 'Asia/Kolkata';
        user.LocaleSidKey = 'en_US';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = '00e7F000000ZrsVQAS';
        user.LanguageLocaleKey = 'en_US';
        insert user;
        
        
        OpportunityTeamMember oppTymember = new OpportunityTeamMember();
        oppTymember.UserId = user.id;
        oppTymember.TeamMemberRole = 'Digital Sales Engineer';
        oppTymember.OpportunityAccessLevel = 'Edit';
        oppTymember.OpportunityId = opp.Id;
        insert oppTymember;
        
        oppTymember.TeamMemberRole = 'Senior Digital Sales Engineer';
        update oppTymember;
        Test.stopTest();
    }
}