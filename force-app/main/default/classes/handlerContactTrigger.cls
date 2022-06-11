public class handlerContactTrigger 
{
    static List<User> userList = [SELECT id,Pin_codes__c,Email,Contact.Account.Name FROM User WHERE Profile.Name = 'Partner Community User - Custom'];
    static Map<String,user> pinCodeUserMap = new Map<String,user>();
	public static void createOffer(List<Contact> cntList)
    {
        for(User u  : userList)
        {
            if(u.Pin_codes__c!=null)
            pinCodeUserMap.put(u.Pin_codes__c,u); 
        }
        for( Contact l: cntList)
        {
                Offer__c offer = new Offer__c();
                offer.Comment__c = l.pi__comments__c;
                offer.Company_Name__c = l.Company__c;
                offer.Company_Size__c =l.Number_of_Employees_Custom__c;
                offer.Designation__c = l.title;
                offer.Email__c = l.Email;
                offer.First_Name__c = l.FirstName;
                offer.Last_Name__c = l.LastName;
                offer.GST__c = l.GST__c;
                offer.GST_Amount__c = l.GST_Amount__c;
                offer.Industry__c = l.Industry__c;
                offer.Net_Payable_Amount__c = l.Net_Payable_Amount__c;
                offer.Offer_Product__c = l.Offer_Product__c;
                offer.OTP__c = string.valueof(l.OTP__c);
                offer.Pincode_Status__c = l.Pincode_Status__c;
                offer.Role_In_Organisation__c = l.Role_in_organisation_c__c;
                offer.Quantity__c = l.Quantity__c;
                offer.Total_Amount__c = l.Total_Amount__c;
                offer.MRP_inclusive_of_all_taxes__c = l.MRP_inclusive_of_all_taxes__c;
                offer.Total_price_after_50_discount__c = l.Total_price_after_50_discount__c;
                offer.Phone__c = l.Phone;
                offer.Order_Requested_Date__c = system.today();
                offer.Stauts__c = 'Active';
                for(String s :pinCodeUserMap.keySet())
                {
                    if(l.MailingPostalCode!=null)
                    {
                        if(s!=null && s.contains (l.MailingPostalCode))   
                        {
                            offer.OwnerId=pinCodeUserMap.get(s).id; 
                        }  
                    }     
                }  
                offer.Customer_Contact__c=l.id;
                offer.Customer__c=l.AccountId;
                Insert offer;  
        }
         
    }
}