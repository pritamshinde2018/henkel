trigger trg_onOpportunityTeam on OpportunityTeamMember (after insert,after update) {
    
    Map<ID, OpportunityTeamMember> parentOpps = new Map<ID, OpportunityTeamMember>(); //Making it a map instead of list for easier lookup
    List<Id> listIds = new List<Id>();
    List<Id> oppteamuser = new List<ID>();
    List<Opportunity> oppupdate =  new List<Opportunity>();

  for (OpportunityTeamMember oppTeam : Trigger.new) {
    listIds.add(oppTeam.OpportunityId);
    parentOpps.put(oppTeam.OpportunityId,oppTeam );
      oppteamuser.add(oppTeam.UserId);
      
  }
  Map<id,User> userlist = new Map<id,User>([Select Id ,Name From User Where Id =:oppteamuser]);
  list<Opportunity> opplist = [SELECT id,Senior_Sales_Engineer__c FROM Opportunity WHERE ID IN :listIds];

    for (Opportunity oppTeam: opplist){
        System.debug('User Name--->'+parentOpps.get(oppTeam.Id).User.FirstName+parentOpps.get(oppTeam.Id).User.LastName);
        if(parentOpps.get(oppTeam.id).TeamMemberRole =='Senior Digital Sales Engineer')
        oppTeam.Senior_Sales_Engineer__c = userlist.get(parentOpps.get(oppTeam.id).UserId).name;
        if(parentOpps.get(oppTeam.id).TeamMemberRole =='Digital Sales Engineer')
            oppTeam.Digital_Sales_Engineer__c=userlist.get(parentOpps.get(oppTeam.id).UserId).name;
        oppupdate.add(oppTeam);
    }
 update oppupdate;
}