public class EcommerceDataIntegrationTest
{
    // @future (callout=true)
    //  public static void getEcommerceDataIntegration()
    public void getEcommerceDataIntegration(String user_id)
    {
        List<RecordType> recordtypelist = [select Id,Name from RecordType where sObjectType ='Contact' AND Name='Customers'];
        Id customerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customers').getRecordTypeId();
        List<User> ISTUser = [SELECT Id FROM User where UserRole.Name ='Inside Sales Team' and IsActive =true];
        if(recordtypelist != null &&  recordtypelist.size() > 0)
        {
            
            List< Searched_Keyword__c > SearchKeyList = new  List< Searched_Keyword__c >();
            List< Products_Viewed__c > ProductViewList = new  List< Products_Viewed__c >();
            List< Wish_List__c > WishList = new  List< Wish_List__c >();
            List<Last_Five_Logins__c> LoginList = new  List<Last_Five_Logins__c>();
            //List<Task> TaskList = new  List<Last_Five_Logins__c>();
            List< Products_on_Cart__c > ProductCartList = new  List< Products_on_Cart__c >();
            
            Map<String, Searched_Keyword__c > SearchKeyMap = new  Map<String, Searched_Keyword__c >();
            Map<String, Products_Viewed__c > ProductViewMap = new Map<String, Products_Viewed__c >();
            Map<String, Wish_List__c > WishListMap = new Map<String, Wish_List__c >();
            Map<String, Last_Five_Logins__c> LoginListMap = new Map<String, Last_Five_Logins__c>();
            
            
            HttpRequest httpRequest = new HttpRequest();
            //httpRequest.setEndpoint('http://13.127.110.224/user-order-info?user_id='+user_id); //+user_id
            httpRequest.setEndpoint('https://www.tryloctite.in/user-order-info?user_id='+user_id);
            httpRequest.setMethod('GET');
            httpRequest.setTimeout(120000);
            Http http = new Http();
            HttpResponse response = http.send(httpRequest);
            try
            {
                String jsonString;
                if(!System.Test.IsRunningTest())
                {
                    jsonString = '{"response":'+(response.getBodyAsBlob().toString())+'}';
                    //jsonString = '{"response":[{"userid":"81","visitor_id":"100051465","user_contact_detail":[{"name":"Piyush","email":"swarupa.doiphode@nanostuffs.com","company":"Digitas","phone":"8999528852","industry":"Agricultural Vehicles and Equipment","role_in_the_organisation":"I am involved in evaluating better manufacturing/repair/maintenance solutions to ensure better performance","no_of_employees":"100-500","what_is_the_purpose":"For use in product assembly or manufacturing","change_password_link":"https://www.tryloctite.in/change-password-guest?email=dUZpN2s2MERwb1M1ZDltaHlYSVlWZ3prLzlTeU5IZmFPRThHaUEvQmlGST0=","address":{"address_1":{"name":"Piyush","phone":"8999528852","email":"swarupa.doiphode@nanostuffs.com","company_name":"Digitas","street_address":"test","landmark":"asdfasdf","city":"Rajkot","zipcode":"360001","state":"Gujarat","country":"India","GSTIN_number":"123423ABCDFDEFR"}}}],"search_keywords":["loctite","threadlockers","threadsealants","gasketing"],"products_viewed":[{"product_name":"Loctite 243","category":"threadlockers","product_url":""}],"wish_lists":[{"product_name":"Loctite 243","category":"threadlockers"}],"last_five_logins":[{"date":"28-11-2018 09:00:00"}],"order":{"clientOrderNumber":"171","IBOrderNumber":"","IBOrderStatus":"","IBTrackingNumber":"","IBInvoiceUrl":"","IBShippingDate":"","IBArrivingDate":"","orderDate":"2019-01-09","email":"swarupa.doiphode@nanostuffs.com","shippingAddress":{"name":"","email":"","address":"","pincode":"","phone":"","city":"","state":"","country":"","landmark":"","gstinNumber":""},"billingAddress":{"name":"","email":"","address":"","pincode":"","phone":"","city":"","state":"","country":"","landmark":"","gstinNumber":""},"payment":{"paymentMode":"Cash on delivery","status":"","gateway":"","amount":"","transactionId":"","paymentRealizedOn":"","pgTransactionId":"","chequeNumber":"","chequeIssueBank":"","chequeDate":"","bankRefNumber":"","bank":"","paymentReceivedDate":""},"orderItems":[{"id":"","sku":"","quantity":"","itemTitle":"","image":"","tax":"","taxPercentage":"","strikedOffPrice":"","taxInclusivePrice":"","codCharge":"","shippingCharge":"","total":""}]},"cart_items":[{"sku":"AD.GA.195887","product_id":"8","product_name":"Loctite 510 - 50 ml","price":"884.00","category":"Instant bonding adhesives","size":"50 ml","quanitity":1}],"cart_payment_information":[{"org_total":"884.00","coupon_name":"","coupon_discount":"0.00","subtotal":884,"GST":"159.12","Total":1043.1199999999999,"total_saving":"0.00"}]},{"userid":"81","visitor_id":"100051465","user_contact_detail":[{"name":"Piyush","email":"swarupa.doiphode@nanostuffs.com","company":"Digitas","phone":"8999528852","industry":"Agricultural Vehicles and Equipment","role_in_the_organisation":"I am involved in evaluating better manufacturing/repair/maintenance solutions to ensure better performance","no_of_employees":"100-500","what_is_the_purpose":"For use in product assembly or manufacturing","change_password_link":"https://www.tryloctite.in/change-password-guest?email=dUZpN2s2MERwb1M1ZDltaHlYSVlWZ3prLzlTeU5IZmFPRThHaUEvQmlGST0=","address":{"address_1":{"name":"Piyush","phone":"8999528852","email":"swarupa.doiphode@nanostuffs.com","company_name":"Digitas","street_address":"test","landmark":"asdfasdf","city":"Rajkot","zipcode":"360001","state":"Gujarat","country":"India","GSTIN_number":"123423ABCDFDEFR"}}}],"search_keywords":["loctite","threadlockers","threadsealants","gasketing"],"products_viewed":[{"product_name":"Loctite 243","category":"threadlockers","product_url":""}],"wish_lists":[{"product_name":"Loctite 243","category":"threadlockers"}],"last_five_logins":[{"date":"28-11-2018 09:00:00"}],"order":{"clientOrderNumber":"170","IBOrderNumber":"105255337","IBOrderStatus":"Order Placed","IBTrackingNumber":"","IBInvoiceUrl":"","IBShippingDate":"","IBArrivingDate":"","orderDate":"2019-01-09","email":"swarupa.doiphode@nanostuffs.com","shippingAddress":{"name":"Piyush","email":"swarupa.doiphode@nanostuffs.com","address":"test","pincode":"360001","phone":"8999528852","city":"Rajkot","state":"Gujarat","country":"India","landmark":"asdfasdf","gstinNumber":"123423ABCDFDEFR"},"billingAddress":{"name":"Piyush","email":"swarupa.doiphode@nanostuffs.com","address":"test","pincode":"360001","phone":"8999528852","city":"Rajkot","state":"Gujarat","country":"India","landmark":"asdfasdf","gstinNumber":"123423ABCDFDEFR"},"payment":{"paymentMode":"Cash on delivery","status":"success","gateway":"","amount":"17.70","transactionId":"","paymentRealizedOn":"2019-01-09","pgTransactionId":"","chequeNumber":"","chequeIssueBank":"","chequeDate":"","bankRefNumber":"","bank":"","paymentReceivedDate":"2019-01-09"},"orderItems":[{"id":"447","sku":"ADH.THR.52012991","quantity":1,"itemTitle":"Loctite 243 - 0.5 ml","image":"https://www.tryloctite.in/sites/default/files/2019-01/LOCTITE-243-0.5-mL_3.jpg","tax":"2.70","taxPercentage":18,"strikedOffPrice":"","taxInclusivePrice":"15.00","codCharge":0,"shippingCharge":0,"total":"15.00"}]},"cart_items":[{"sku":"","product_id":"","product_name":"","price":"","category":"","size":"","quanitity":""}],"cart_payment_information":[{"org_total":"15.00","coupon_name":"","coupon_discount":"0.00","subtotal":15,"GST":"2.70","Total":17.699999999999999,"total_saving":"0.00"}]}]}';
                }
                else
                {
                    jsonString = '{"response":[{"userid":"227","visitor_id":"100051465","user_contact_detail":[{"name":"Anil","email":"anil.jha@nanostuffs.com","company":"abc","phone":"2323222332","industry":"Agriculture Implements and Tractor Trailer","role_in_the_organisation":"I evaluate production/repair/maintenance solutions to control quality and efficiency","no_of_employees":"100-500","what_is_the_purpose":"For use in product assembly or manufacturing","change_password_link":"http://13.127.110.224/change-password-guest?email=UWtuTkRtZ0laRFB3L09oVjJPMHhwMTUyVVF0WTNuSm1TVnZkU1NZNWlQcz0=","address":{"address_1":{"name":"amit prakash","phone":"2323222332","email":"anil.jha@nanostuffs.com","company_name":"AMIT PRAKASH.","street_address":"asdddwawddwanj, SAJSJAS#$ - SDJHSJHHDS & sjhdss. sdjhdhjfkhwefhfwlhfewfw","landmark":".SJDHS JRJksj $#- $&*","city":"New Del hi","zipcode":"112203","state":"Tamil Nadu","country":"India","GSTIN_number":"2132328779aASSA"},"address_3":{"name":"amit prakash3","phone":"32323222332","email":"anil.jha3@nanostuffs.com","company_name":"AMIT PRAKASH.3","street_address":"3asdddwawddwanj, SAJSJAS#$ - SDJHSJHHDS & sjhdss. sdjhdhjfkhwefhfwlhfewfw","landmark":"3.SJDHS JRJksj $#- $&*","city":"3New Del hi","zipcode":"3112203","state":"3Tamil Nadu","country":"3India","GSTIN_number":"32132328779aASSA"},"address_2":{"name":"amit prakash2","phone":"2323222332","email":"anil.jha2@nanostuffs.com","company_name":"AMIT PRAKASH.2","street_address":"2asdddwawddwanj, SAJSJAS#$ - SDJHSJHHDS & sjhdss. sdjhdhjfkhwefhfwlhfewfw","landmark":"2.SJDHS JRJksj $#- $&*","city":"2New Del hi","zipcode":"2112203","state":"2Tamil Nadu","country":"2India","GSTIN_number":"22132328779aASSA"}}}],"search_keywords":["loctite","threadlockers","threadsealants","gasketing"],"products_viewed":[{"product_name":"Loctite 243","category":"threadlockers","product_url":""}],"wish_lists":[{"product_name":"Loctite 243","category":"threadlockers"}],"last_five_logins":[{"date":"28-11-2018 09:00:00"}],"order":{"clientOrderNumber":"467","IBOrderNumber":"104222955","IBOrderStatus":"Order Placed","IBTrackingNumber":"","IBInvoiceUrl":"","IBShippingDate":"","IBArrivingDate":"","orderDate":"2019-01-08","email":"shbhnd.shekhar@gmail.com","shippingAddress":{"name":"SHUBHENDUECOMMERCETEST","email":"shbhnd.shekhar@gmail.com","address":"ADDADDRESS","pincode":"110070","phone":"9657857222","city":"DD","state":"KARNATAKA","country":"India","landmark":"DDDD","gstinNumber":"123123123123AAA"},"billingAddress":{"name":"SHUBHENDUECOMMERCETEST","email":"shbhnd.shekhar@gmail.com","address":"ADDADDRESS","pincode":"110070","phone":"9657857222","city":"DD","state":"KARNATAKA","country":"India","landmark":"DDDD","gstinNumber":"123123123123AAA"},"payment":{"paymentMode":"Online","status":"success","gateway":"PayU","amount":"1.00","transactionId":"0f8401111e3456bba140","paymentRealizedOn":"2019-01-08","pgTransactionId":"","chequeNumber":"","chequeIssueBank":"","chequeDate":"","bankRefNumber":"","bank":"","paymentReceivedDate":"2019-01-08"},"orderItems":[{"id":"2329","sku":"AD.SU.1545010","quantity":2,"itemTitle":"Loctite SF 7649 Primer - 100 ml","image":"http://13.127.110.224/sites/default/files/2018-12/LOCTITE-7649-Primer-100-mL%2001.jpg","tax":"0.18","taxPercentage":18,"strikedOffPrice":"","taxInclusivePrice":"786.00","codCharge":0,"shippingCharge":0,"total":"1,572.00"}]},"cart_items":[{"sku":"AD.TH.333221","product_id":"1","product_name":"Loctite 243 - 50 ml","price":"609.300000","category":"Threadlockers","size":"50 ml","quanitity":"11.00"}],"cart_payment_information":[{"subtotal":"7,447.00","coupon_name":"","coupon_discount":"744.70","GST":"1,206.41","Total":"7,908.71"}]}]}';
                }
                
                
                
                //f jsonString = '{"response":[{"userid":"308","visitor_id":"100051465","user_contact_detail":[{"name":"test datat","email":"zyree.yeshua@plutocow.com","company":"nanotedstjb","phone":"1234545787","industry":"Agriculture Implements and Tractor Trailer","role_in_the_organisation":"I take all decisions related to purchase of material parts used in manufacturing, repair and maintenance","no_of_employees":"100-500","what_is_the_purpose":"For use in product assembly or manufacturing","change_password_link":"http://13.127.110.224/change-password-guest?email=UXd0akZKRmFBZ1NtYkJEMkpUS093b29NUGE2TlhuR3E2NUpEY3RYZ1g2dz0=","address":{"address_1":{"name":"test datat","phone":"1234545787","email":"zyree.yeshua@plutocow.com","company_name":"nanotedstjb","street_address":"fddfddsfsdfs","landmark":"gfsxgsdg","city":"fgbsdgsd","zipcode":"110009","state":"fshgsfg","country":"India","GSTIN_number":"4cx465b4x6c4b65"}}}],"search_keywords":[""],"products_viewed":[{"product_name":"Loctite 243","category":"threadlockers","product_url":""}],"wish_lists":[{"product_name":"","category":""}],"last_five_logins":[{"date":"28-11-2018 09:00:00"}],"order":{"clientOrderNumber":"571","IBOrderNumber":"104223133","IBOrderStatus":"Order Placed","IBTrackingNumber":"","IBInvoiceUrl":"","IBShippingDate":"","IBArrivingDate":"","orderDate":"2019-01-22","email":"zyree.yeshua@plutocow.com","shippingAddress":{"name":"test datat","email":"zyree.yeshua@plutocow.com","address":"fddfddsfsdfs","pincode":"110009","phone":"1234545787","city":"fgbsdgsd","state":"fshgsfg","country":"India","landmark":"gfsxgsdg","gstinNumber":"4cx465b4x6c4b65"},"billingAddress":{"name":"test datat","email":"zyree.yeshua@plutocow.com","address":"fddfddsfsdfs","pincode":"110009","phone":"1234545787","city":"fgbsdgsd","state":"fshgsfg","country":"India","landmark":"gfsxgsdg","gstinNumber":"4cx465b4x6c4b65"},"payment":{"paymentMode":"Cash on delivery","status":"success","gateway":"","amount":"1793.82","transactionId":"","paymentRealizedOn":"2019-01-22","pgTransactionId":"","chequeNumber":"","chequeIssueBank":"","chequeDate":"","bankRefNumber":"","bank":"","paymentReceivedDate":"2019-01-22"},"orderItems":[{"id":"2560","sku":"ADH.SEA.41922510","quantity":2,"itemTitle":"Loctite SF 7070 ODC-Free Cleaner & Degreaser - 150 g","image":"http://13.127.110.224/sites/default/files/2018-07/LOCTITE-7070-Cleaner_0.jpg","tax":"288.04","taxPercentage":18,"strikedOffPrice":"889.000000","taxInclusivePrice":"800.10","codCharge":0,"shippingCharge":0,"total":"1600.2"}]},"cart_items":[{"sku":"","product_id":"","product_name":"","price":"","category":"","size":"","quanitity":""}],"cart_payment_information":[{"org_total":"1,778.00","coupon_name":"LOCTITE5","coupon_discount":"80.01","intro_discount":"177.80","subtotal":"1,520.19","GST":"273.63","Total":"1,793.82","total_saving":"257.81"}]}]}';
                jsonString  = (jsonString.replace('date', 'date1'));
                jsonString  = (jsonString.replace('"taxPercentage":""', '"taxPercentage":null'));
                jsonString  = (jsonString.replace('"codCharge":""', '"codCharge":null'));
                jsonString  = (jsonString.replace('"shippingCharge":""', '"shippingCharge":null'));
                
                System.debug('API Response----'+jsonString);
                
                
                
                EcommerceWrapper EcommersObj  = (EcommerceWrapper) System.JSON.deserialize(jsonString, EcommerceWrapper.class);
                List<EcommerceWrapper.Response> EcommersList = EcommersObj.response;
                
                Map<String,Contact> ExistingContact_Map = new Map<String,Contact>();
                Map<String,Products_on_Cart__c> ExistingProductCart_Map = new Map<String,Products_on_Cart__c>();
                Map<String,Ordered_Product__c > ExistingOrder_Map = new Map<String,Ordered_Product__c >();
                Map<String,List<Products_on_Cart__c>> ExistingOrderWithEmail_Map = new Map<String,List<Products_on_Cart__c>>();
                Map<String,String> ExistingAccount_Map = new Map<String,String>();  
                
                if(EcommersList != null)
                {
                    Set<String> resContact_List = new Set<String>();
                    Set<String> resProductCart_List = new Set<String>();
                    Set<String> resOrderProduct_List = new Set<String>();
                    Set<String> rescompany_List = new Set<String>();
                    
                    for(Integer i = 0 ;i < EcommersList.size(); i++)
                    {
                        if(EcommersList[i].user_contact_detail[0].email != null && EcommersList[i].user_contact_detail[0].email != '')
                        {
                            resContact_List.add(EcommersList[i].user_contact_detail[0].email);
                            rescompany_List.add(EcommersList[i].user_contact_detail[0].company);
                            if(EcommersList[i].cart_items != null && EcommersList[i].cart_items.size() > 0 )
                            {
                                for(Integer k =0 ;k<EcommersList[i].cart_items.size() ; k++)
                                {
                                    if(EcommersList[i].cart_items[k] != null  && EcommersList[i].cart_items[k].product_id  != null && EcommersList[i].cart_items[k].product_id  != '' && EcommersList[i].cart_items[k].product_name != null && EcommersList[i].cart_items[k].product_name != '')
                                        resProductCart_List.add(String.valueOf(EcommersList[i].cart_items[k].product_name)+String.valueOf(EcommersList[i].cart_items[k].product_id)+String.valueOf(EcommersList[i].user_contact_detail[0].email));
                                    else if(EcommersList[i].cart_items[k] != null  && EcommersList[i].cart_items[k].product_id  != null && EcommersList[i].cart_items[k].product_id  != '')
                                        resProductCart_List.add(String.valueOf(EcommersList[i].cart_items[k].product_id)+String.valueOf(EcommersList[i].user_contact_detail[0].email));
                                }
                            }
                        }
                        
                    }
                    
                    for(Account act : [select Id, Name from Account where Name IN : rescompany_List])
                    {
                        ExistingAccount_Map.put(act.Name, act.Id);
                    }
                    
                    for(Contact con : [select Id, Name,Bulk_Discount__c, Email,Phone,Company__c,E_Commerce_Phone__c,What_is_the_purpose_use__c, E_Commerce_User_Name__c,AccountId,Total_Saving__c,Coupon_Name__c,Coupon_Discount__c,Intro_Discount__c,Total__c,GST__c,Subtotal__c,Total_Price_After_Discount__c from Contact where Email IN : resContact_List])
                    {
                        ExistingContact_Map.put(con.Email, con);
                    }
                    for(Products_on_Cart__c  proObj : [select Id,External_Id__c,Product_id__c,Name,LastModifiedDate,CreatedDate,Active__c,sku__c  from Products_on_Cart__c  where External_Id__c IN : resProductCart_List])
                    {
                        ExistingProductCart_Map.put(proObj.External_Id__c, proObj);
                    }
                    
                    
                    for(Products_on_Cart__c  proObj : [SELECT Id,Active__c,Customer_Contact__c,External_Id__c,LastModifiedDate,Customer_Contact__r.Email FROM Products_on_Cart__c WHERE Customer_Contact__r.Email IN : resContact_List])
                    {
                        if(ExistingOrderWithEmail_Map.get(proObj.Customer_Contact__r.Email) != null)
                        {
                            List<Products_on_Cart__c> orderlist = ExistingOrderWithEmail_Map.get(proObj.Customer_Contact__r.Email);
                            orderlist.add(proObj);
                            ExistingOrderWithEmail_Map.put(proObj.Customer_Contact__r.Email, orderlist);
                        }
                        else
                        {
                            List<Products_on_Cart__c> orderlist = new List<Products_on_Cart__c>();
                            orderlist.add(proObj);
                            ExistingOrderWithEmail_Map.put(proObj.Customer_Contact__r.Email, orderlist);
                        }
                    }
                }
                
                if(EcommersList != null)
                {
                    for(Integer i = 0 ;i < EcommersList.size(); i++)
                    {
                        if(i > 6)
                            break;
                        
                        List<EcommerceWrapper.user_contact_detail> user_contact_detail_List = EcommersList[i].user_contact_detail;      //User Details
                        List<String> search_keywords_List = EcommersList[i].search_keywords;                                            //Search Keywords
                        List< EcommerceWrapper.Products_viewed > products_viewed_List = EcommersList[i].products_viewed;                //Products Viewed
                        List< EcommerceWrapper.Wish_lists> wish_lists_List = EcommersList[i].wish_lists;                                //Wish List
                        List<EcommerceWrapper.last_five_logins > last_five_logins_List = EcommersList[i].last_five_logins;              //Last Five Logins
                        List<EcommerceWrapper.Cart_payment_information > cart_Payment_List = EcommersList[i].cart_payment_information;  //Cart Payment Information
                        List<EcommerceWrapper.cart_items > cart_items_List = EcommersList[i].cart_items;                                //Cart Order List
                        
                        EcommerceWrapper.order orderObject = new EcommerceWrapper.order();
                        
                        if(EcommersList[i].order != null)
                            orderObject = EcommersList[i].order;
                        
                        Contact ContactObj = new Contact();
                        
                        if(ExistingContact_Map.get(user_contact_detail_List[0].email) != null)
                        {
                            
                            ContactObj = ExistingContact_Map.get(user_contact_detail_List[0].email);
                            
                            
                            if(user_contact_detail_List[0].address != null)
                            {
                                Map<String ,EcommerceWrapper.Address> AddressMap = new  Map<String ,EcommerceWrapper.Address>();
                                AddressMap = user_contact_detail_List[0].address;
                                set<String> keylst = AddressMap.keySet(); 
                                
                                for(String keyStr : keylst)
                                {
                                    if(keyStr.contains('address_1'))
                                    {
                                        if(AddressMap.get(keyStr) != null)
                                        {
                                            
                                            EcommerceWrapper.Address Add1 = AddressMap.get(keyStr);
                                            
                                            if(Add1.name != null && Add1.name != '')
                                                ContactObj.name1__c = Add1.name;
                                            
                                            if(Add1.phone != null && Add1.phone != '')
                                                ContactObj.phone1__c = Add1.phone;
                                            
                                            if(Add1.email != null && Add1.email != '')
                                                ContactObj.email1__c = Add1.email;
                                            
                                            if(Add1.company_name != null && Add1.company_name != '')
                                                ContactObj.company_name1__c = Add1.company_name;
                                            
                                            if(Add1.street_address != null && Add1.street_address != '')
                                                ContactObj.street_address1__c = Add1.street_address;
                                            
                                            if(Add1.landmark != null && Add1.landmark != '')
                                                ContactObj.landmark1__c = Add1.landmark;
                                            
                                            if(Add1.zipcode != null && Add1.zipcode != '')
                                                ContactObj.zipcode__c = Add1.zipcode;
                                            
                                            if(Add1.city != null && Add1.city != '')
                                                ContactObj.city1__c = Add1.city;
                                            
                                            if(Add1.state != null && Add1.state != '')
                                                ContactObj.state1__c = Add1.state;
                                            
                                            if(Add1.country != null && Add1.country != '')
                                                ContactObj.country1__c = Add1.country;
                                            
                                            if(Add1.GSTIN_number != null && Add1.GSTIN_number != '')
                                                ContactObj.GSTIN_number__c = Add1.GSTIN_number;
                                            
                                        }
                                    }
                                    else if(keyStr.contains('address_2'))
                                    {
                                        if(AddressMap.get(keyStr) != null)
                                        {
                                            
                                            EcommerceWrapper.Address Add2 = AddressMap.get(keyStr);
                                            
                                            if(Add2.name != null && Add2.name != '')
                                                ContactObj.name2__c = Add2.name;
                                            
                                            if(Add2.phone != null && Add2.phone != '')
                                                ContactObj.phone2__c = Add2.phone;
                                            
                                            if(Add2.email != null && Add2.email != '')
                                                ContactObj.email2__c = Add2.email;
                                            
                                            if(Add2.company_name != null && Add2.company_name != '')
                                                ContactObj.company_name2__c = Add2.company_name;
                                            
                                            if(Add2.street_address != null && Add2.street_address != '')
                                                ContactObj.street_address2__c = Add2.street_address;
                                            
                                            if(Add2.landmark != null && Add2.landmark != '')
                                                ContactObj.landmark2__c = Add2.landmark;
                                            
                                            if(Add2.zipcode != null && Add2.zipcode != '')
                                                ContactObj.zipcode2__c = Add2.zipcode;
                                            
                                            if(Add2.city != null && Add2.city != '')
                                                ContactObj.city2__c = Add2.city;
                                            
                                            if(Add2.state != null && Add2.state != '')
                                                ContactObj.state2__c = Add2.state;
                                            
                                            if(Add2.country != null && Add2.country != '')
                                                ContactObj.country2__c = Add2.country;
                                            
                                            if(Add2.GSTIN_number != null && Add2.GSTIN_number != '')
                                                ContactObj.GSTIN_number2__c = Add2.GSTIN_number;
                                            
                                        }
                                    }
                                    else if(keyStr.contains('address_3'))
                                    {
                                        if(AddressMap.get(keyStr) != null)
                                        {
                                            
                                            EcommerceWrapper.Address Add3 = AddressMap.get(keyStr);
                                            
                                            if(Add3.name != null && Add3.name != '')
                                                ContactObj.name3__c = Add3.name;
                                            
                                            if(Add3.phone != null && Add3.phone != '')
                                                ContactObj.phone3__c = Add3.phone;
                                            
                                            if(Add3.email != null && Add3.email != '')
                                                ContactObj.email3__c = Add3.email;
                                            
                                            if(Add3.company_name != null && Add3.company_name != '')
                                                ContactObj.company_name3__c = Add3.company_name;
                                            
                                            if(Add3.street_address != null && Add3.street_address != '')
                                                ContactObj.street_address3__c = Add3.street_address;
                                            
                                            if(Add3.landmark != null && Add3.landmark != '')
                                                ContactObj.landmark3__c = Add3.landmark;
                                            
                                            if(Add3.zipcode != null && Add3.zipcode != '')
                                                ContactObj.zipcode3__c = Add3.zipcode;
                                            
                                            if(Add3.city != null && Add3.city != '')
                                                ContactObj.city3__c = Add3.city;
                                            
                                            if(Add3.state != null && Add3.state != '')
                                                ContactObj.state3__c = Add3.state;
                                            
                                            if(Add3.country != null && Add3.country != '')
                                                ContactObj.country3__c = Add3.country;
                                            
                                            if(Add3.GSTIN_number != null && Add3.GSTIN_number != '')
                                                ContactObj.GSTIN_number3__c = Add3.GSTIN_number;
                                            
                                        }
                                    }
                                } 
                            }
                            
                            
                            if(user_contact_detail_List[0].phone != null && user_contact_detail_List[0].phone != '')
                                ContactObj.E_Commerce_Phone__c =  user_contact_detail_List[0].phone;
                            
                            if(user_contact_detail_List[0].company != null && user_contact_detail_List[0].company != '')
                                ContactObj.Company__c =  user_contact_detail_List[0].company;
                            
                            if(user_contact_detail_List[0].name != null)
                                ContactObj.E_Commerce_User_Name__c =  user_contact_detail_List[0].name;
                            
                            
                            if(user_contact_detail_List[0].industry != null)
                                ContactObj.Industry__c = user_contact_detail_List[0].industry;
                            
                            if(user_contact_detail_List[0].role_in_the_organisation != null)
                                ContactObj.Role_in_organisation__c = user_contact_detail_List[0].role_in_the_organisation;
                            
                            if(user_contact_detail_List[0].no_of_employees != null)
                                ContactObj.Number_of_Employees_Custom__c = user_contact_detail_List[0].no_of_employees;
                            
                            if(user_contact_detail_List[0].user_coupon != null)
                                ContactObj.couponcode__c = user_contact_detail_List[0].user_coupon;
                            
                            if(user_contact_detail_List[0].coupon_redeem != null)
                                ContactObj.coupon_redeem__c = user_contact_detail_List[0].coupon_redeem;
                            
                            if(user_contact_detail_List[0].what_is_the_purpose != null)
                                ContactObj.What_is_the_purpose_use__c = user_contact_detail_List[0].what_is_the_purpose;
                            
                            if(user_contact_detail_List[0].change_password_link != null)
                                ContactObj.Ecom_Reset_password__c = user_contact_detail_List[0].change_password_link;
                            
                            if(ContactObj.Phone == null )
                                ContactObj.Phone = user_contact_detail_List[0].phone;
                            
                            if(user_contact_detail_List[0].company != null && user_contact_detail_List[0].company != '')
                            {
                                System.debug('------****-----'+user_contact_detail_List[0].company+'&&&&&&&&&&&&&'+ExistingAccount_Map.get(user_contact_detail_List[0].company));
                                
                                if(ExistingAccount_Map.get(user_contact_detail_List[0].company) != null)
                                {
                                    ContactObj.AccountId = ExistingAccount_Map.get(user_contact_detail_List[0].company);
                                    
                                }
                                else
                                {
                                    Account acc = new Account();
                                    acc.Name = user_contact_detail_List[0].company;
                                    acc.RecordTypeId = customerRecordTypeId;
                                    try
                                    {
                                        insert acc;
                                        ExistingAccount_Map.put(acc.Name,acc.Id);
                                        ContactObj.AccountId = acc.Id;
                                    }
                                    catch (Exception e){}
                                }
                            }
                            
                            
                            if(cart_Payment_List != null && cart_Payment_List.size()>0) //User Cart Information
                            {
                                
                                
                                if(cart_Payment_List[0].coupon_name != null && cart_Payment_List[0].coupon_name != '')
                                    ContactObj.Coupon_Name__c = cart_Payment_List[0].coupon_name;
                                
                                if(cart_Payment_List[0].coupon_discount != null && cart_Payment_List[0].coupon_discount != '')
                                    ContactObj.Discount_Price__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].coupon_discount.replaceAll('[^.\\d]','')));
                                
                                if(cart_Payment_List[0].intro_discount != null && cart_Payment_List[0].intro_discount != '')
                                    ContactObj.Intro_Discount__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].intro_discount.replaceAll('[^.\\d]','')));
                                
                                if(cart_Payment_List[0].GST != null && cart_Payment_List[0].GST != '')
                                    ContactObj.GST__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].GST.replaceAll('[^.\\d]','')));
                                
                                if(cart_Payment_List[0].subtotal != null && cart_Payment_List[0].subtotal != '')
                                    ContactObj.Total_Price_After_Discount__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].subtotal.replaceAll('[^.\\d]','')));
                                
                                if(cart_Payment_List[0].Total != null && cart_Payment_List[0].Total != '')
                                    ContactObj.Total__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].Total.replaceAll('[^.\\d]','')));
                                
                                if(cart_Payment_List[0].org_total != null && cart_Payment_List[0].org_total != '')
                                    ContactObj.Subtotal__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].org_total.replaceAll('[^.\\d]','')));
                                
                                if(cart_Payment_List[0].total_saving != null && cart_Payment_List[0].total_saving != '')
                                    ContactObj.Total_Saving__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].total_saving.replaceAll('[^.\\d]','')));
                                
                                
                            }
                            
                            try
                            {
                                update ContactObj;
                            }
                            catch (Exception e){}
                            
                            
                            ExistingContact_Map.put(ContactObj.Email, ContactObj);
                        }
                        else
                        {
                            if(user_contact_detail_List[0].name != null && user_contact_detail_List[0].name != '')               //New User Created
                            {
                                
                                if(user_contact_detail_List[0].company != null && user_contact_detail_List[0].company != '')
                                {
                                    if(ExistingAccount_Map.get(user_contact_detail_List[0].company) != null)
                                    {
                                        ContactObj.AccountId = ExistingAccount_Map.get(user_contact_detail_List[0].company);
                                    }
                                    else
                                    {
                                        Account acc = new Account();
                                        acc.Name = user_contact_detail_List[0].company;
                                        acc.RecordTypeId = customerRecordTypeId;
                                        if(user_contact_detail_List[0].industry !=null)
                                            acc.Industry=user_contact_detail_List[0].industry;
                                        try
                                        {
                                            insert acc;
                                            ExistingAccount_Map.put(acc.Name,acc.Id);
                                            ContactObj.AccountId = acc.Id;
                                        }
                                        catch (Exception e){}
                                    }
                                    
                                }
                                
                                ContactObj.LastName = user_contact_detail_List[0].name;
                                ContactObj.E_Commerce_User_Name__c =  user_contact_detail_List[0].name;
                                
                                ContactObj.RecordTypeId = recordtypelist[0].Id;
                                ContactObj.Prospect_Interest_Type__c = 'E-Commerce';
                                
                                if(user_contact_detail_List[0].email != null)
                                    ContactObj.Email = user_contact_detail_List[0].email;
                                
                                if(user_contact_detail_List[0].phone != null && user_contact_detail_List[0].phone != '')
                                {
                                    ContactObj.Phone =  user_contact_detail_List[0].phone;
                                    ContactObj.E_Commerce_Phone__c =  user_contact_detail_List[0].phone;
                                }
                                
                                if(user_contact_detail_List[0].company != null)
                                    ContactObj.Company__c = user_contact_detail_List[0].company;
                                /********/  
                                if(user_contact_detail_List[0].Ecom_Source!=null)
                                    ContactObj.Ecom_Source__c = user_contact_detail_List[0].Ecom_Source;
                                
                                if(user_contact_detail_List[0].Ecom_URL_Params!=null)
                                    ContactObj.Ecom_URL_Params__c = user_contact_detail_List[0].Ecom_URL_Params;
                                
                                if(user_contact_detail_List[0].Ecom_campaign!=null)
                                    ContactObj.Ecom_campaign__c = user_contact_detail_List[0].Ecom_campaign;
                                
                                if(user_contact_detail_List[0]. Ecom_content!=null)
                                    ContactObj.Ecom_content__c = user_contact_detail_List[0].Ecom_content;
                                
                                if(user_contact_detail_List[0].Ecom_media!=null)
                                    ContactObj.Ecom_media__c = user_contact_detail_List[0].Ecom_media;
                                
                                if(user_contact_detail_List[0].Ecom_term!=null)
                                    ContactObj.Ecom_term__c = user_contact_detail_List[0].Ecom_term;
                                /********/  
                                if(user_contact_detail_List[0].industry != null)
                                    ContactObj.Industry__c = user_contact_detail_List[0].industry;
                                
                                if(user_contact_detail_List[0].role_in_the_organisation != null)
                                    ContactObj.Role_in_organisation__c = user_contact_detail_List[0].role_in_the_organisation;
                                
                                if(user_contact_detail_List[0].no_of_employees != null)
                                    ContactObj.Number_of_Employees_Custom__c = user_contact_detail_List[0].no_of_employees;
                                
                                if(user_contact_detail_List[0].what_is_the_purpose != null)
                                    ContactObj.What_is_the_purpose_use__c = user_contact_detail_List[0].what_is_the_purpose;
                                
                                if(user_contact_detail_List[0].user_coupon != null)
                                    ContactObj.couponcode__c = user_contact_detail_List[0].user_coupon;
                                
                                if(user_contact_detail_List[0].coupon_redeem != null)
                                    ContactObj.coupon_redeem__c = user_contact_detail_List[0].coupon_redeem;
                                
                                if(user_contact_detail_List[0].change_password_link != null)
                                    ContactObj.Ecom_Reset_password__c = user_contact_detail_List[0].change_password_link;
                                
                                if(cart_Payment_List != null && cart_Payment_List.size()>0)  //User Cart Information
                                {
                                    if(cart_Payment_List[0].coupon_name != null && cart_Payment_List[0].coupon_name != '')
                                        ContactObj.Coupon_Name__c = cart_Payment_List[0].coupon_name;
                                    
                                    if(cart_Payment_List[0].coupon_discount != null && cart_Payment_List[0].coupon_discount != '')
                                        ContactObj.Discount_Price__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].coupon_discount.replaceAll('[^.\\d]','')));
                                    
                                    if(cart_Payment_List[0].intro_discount != null && cart_Payment_List[0].intro_discount != '')
                                        ContactObj.Intro_Discount__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].intro_discount.replaceAll('[^.\\d]','')));
                                    
                                    /*if(cart_Payment_List[0].bulk_discount != null && cart_Payment_List[0].bulk_discount != '')
ContactObj.Bulk_Discount__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].bulk_discount.replaceAll('[^.\\d]','')));

//OrderInfo.bulk_discount__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].bulk_discount.replaceAll('[^.\\d]','')));
*/
                                    
                                    if(cart_Payment_List[0].bulk_discount != null && cart_Payment_List[0].bulk_discount != '')
                                        ContactObj.Bulk_Discount__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].bulk_discount.replaceAll('[^.\\d]','')));
                                    
                                    
                                    if(cart_Payment_List[0].GST != null && cart_Payment_List[0].GST != '')
                                        ContactObj.GST__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].GST.replaceAll('[^.\\d]','')));
                                    
                                    if(cart_Payment_List[0].subtotal != null && cart_Payment_List[0].subtotal != '')
                                        ContactObj.Total_Price_After_Discount__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].subtotal.replaceAll('[^.\\d]','')));
                                    
                                    if(cart_Payment_List[0].Total != null && cart_Payment_List[0].Total != '')
                                        ContactObj.Total__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].Total.replaceAll('[^.\\d]','')));
                                    
                                    if(cart_Payment_List[0].org_total != null && cart_Payment_List[0].org_total != '')
                                        ContactObj.Subtotal__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].org_total.replaceAll('[^.\\d]','')));
                                    
                                    if(cart_Payment_List[0].total_saving != null && cart_Payment_List[0].total_saving != '')
                                        ContactObj.Total_Saving__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].total_saving.replaceAll('[^.\\d]','')));
                                    
                                    
                                }
                                
                                if(user_contact_detail_List[0].address != null)
                                {
                                    Map<String ,EcommerceWrapper.Address> AddressMap = new  Map<String ,EcommerceWrapper.Address>();
                                    AddressMap = user_contact_detail_List[0].address;
                                    set<String> keylst = AddressMap.keySet(); 
                                    
                                    for(String keyStr : keylst)
                                    {
                                        if(keyStr.contains('address_1'))
                                        {
                                            if(AddressMap.get(keyStr) != null)
                                            {
                                                
                                                EcommerceWrapper.Address Add1 = AddressMap.get(keyStr);
                                                
                                                if(Add1.name != null && Add1.name != '')
                                                    ContactObj.name1__c = Add1.name;
                                                
                                                if(Add1.phone != null && Add1.phone != '')
                                                    ContactObj.phone1__c = Add1.phone;
                                                
                                                if(Add1.email != null && Add1.email != '')
                                                    ContactObj.email1__c = Add1.email;
                                                
                                                if(Add1.company_name != null && Add1.company_name != '')
                                                    ContactObj.company_name1__c = Add1.company_name;
                                                
                                                if(Add1.street_address != null && Add1.street_address != '')
                                                    ContactObj.street_address1__c = Add1.street_address;
                                                
                                                if(Add1.landmark != null && Add1.landmark != '')
                                                    ContactObj.landmark1__c = Add1.landmark;
                                                
                                                if(Add1.zipcode != null && Add1.zipcode != '')
                                                    ContactObj.zipcode__c = Add1.zipcode;
                                                
                                                if(Add1.city != null && Add1.city != '')
                                                    ContactObj.city1__c = Add1.city;
                                                
                                                if(Add1.state != null && Add1.state != '')
                                                    ContactObj.state1__c = Add1.state;
                                                
                                                if(Add1.country != null && Add1.country != '')
                                                    ContactObj.country1__c = Add1.country;
                                                
                                                if(Add1.GSTIN_number != null && Add1.GSTIN_number != '')
                                                    ContactObj.GSTIN_number__c = Add1.GSTIN_number;
                                                
                                            }
                                        }
                                        else if(keyStr.contains('address_2'))
                                        {
                                            if(AddressMap.get(keyStr) != null)
                                            {
                                                
                                                EcommerceWrapper.Address Add2 = AddressMap.get(keyStr);
                                                
                                                if(Add2.name != null && Add2.name != '')
                                                    ContactObj.name2__c = Add2.name;
                                                
                                                if(Add2.phone != null && Add2.phone != '')
                                                    ContactObj.phone2__c = Add2.phone;
                                                
                                                if(Add2.email != null && Add2.email != '')
                                                    ContactObj.email2__c = Add2.email;
                                                
                                                if(Add2.company_name != null && Add2.company_name != '')
                                                    ContactObj.company_name2__c = Add2.company_name;
                                                
                                                if(Add2.street_address != null && Add2.street_address != '')
                                                    ContactObj.street_address2__c = Add2.street_address;
                                                
                                                if(Add2.landmark != null && Add2.landmark != '')
                                                    ContactObj.landmark2__c = Add2.landmark;
                                                
                                                if(Add2.zipcode != null && Add2.zipcode != '')
                                                    ContactObj.zipcode2__c = Add2.zipcode;
                                                
                                                if(Add2.city != null && Add2.city != '')
                                                    ContactObj.city2__c = Add2.city;
                                                
                                                if(Add2.state != null && Add2.state != '')
                                                    ContactObj.state2__c = Add2.state;
                                                
                                                if(Add2.country != null && Add2.country != '')
                                                    ContactObj.country2__c = Add2.country;
                                                
                                                if(Add2.GSTIN_number != null && Add2.GSTIN_number != '')
                                                    ContactObj.GSTIN_number2__c = Add2.GSTIN_number;
                                                
                                            }
                                        }
                                        else if(keyStr.contains('address_3'))
                                        {
                                            if(AddressMap.get(keyStr) != null)
                                            {
                                                
                                                EcommerceWrapper.Address Add3 = AddressMap.get(keyStr);
                                                
                                                if(Add3.name != null && Add3.name != '')
                                                    ContactObj.name3__c = Add3.name;
                                                
                                                if(Add3.phone != null && Add3.phone != '')
                                                    ContactObj.phone3__c = Add3.phone;
                                                
                                                if(Add3.email != null && Add3.email != '')
                                                    ContactObj.email3__c = Add3.email;
                                                
                                                if(Add3.company_name != null && Add3.company_name != '')
                                                    ContactObj.company_name3__c = Add3.company_name;
                                                
                                                if(Add3.street_address != null && Add3.street_address != '')
                                                    ContactObj.street_address3__c = Add3.street_address;
                                                
                                                if(Add3.landmark != null && Add3.landmark != '')
                                                    ContactObj.landmark3__c = Add3.landmark;
                                                
                                                if(Add3.zipcode != null && Add3.zipcode != '')
                                                    ContactObj.zipcode3__c = Add3.zipcode;
                                                
                                                if(Add3.city != null && Add3.city != '')
                                                    ContactObj.city3__c = Add3.city;
                                                
                                                if(Add3.state != null && Add3.state != '')
                                                    ContactObj.state3__c = Add3.state;
                                                
                                                if(Add3.country != null && Add3.country != '')
                                                    ContactObj.country3__c = Add3.country;
                                                
                                                if(Add3.GSTIN_number != null && Add3.GSTIN_number != '')
                                                    ContactObj.GSTIN_number3__c = Add3.GSTIN_number;
                                                
                                            }
                                        }
                                    } 
                                }
                                System.debug('-------'+ContactObj);
                                try
                                {
                                    upsert ContactObj Email;
                                    SendSMS_Helper.SendResetPwdEmail(ContactObj);
                                }
                                catch (Exception e){}
                                
                                ExistingContact_Map.put(ContactObj.Email, ContactObj);
                            }
                            
                        }
                        if(ContactObj.Id != null)
                        {
                            
                            //Search keyword Record Insertion
                            
                            if(search_keywords_List != null && search_keywords_List.size() > 0)
                            {
                                Map<String,String> SearchMap = new Map<String,String>();
                                for(Integer k =0 ;k<search_keywords_List.size() ; k++)
                                {
                                    Searched_Keyword__c SearchKeyObj = new  Searched_Keyword__c();
                                    
                                    SearchKeyObj.Name = search_keywords_List[k];
                                    SearchKeyObj.External_Id__c = SearchKeyObj.Name+ContactObj.Id;
                                    SearchKeyObj.Customer_Contact__c = ContactObj.Id;
                                    SearchKeyMap.put(SearchKeyObj.External_Id__c,SearchKeyObj);
                                }
                            }
                            
                            //Products Viewed Record Insertion
                            
                            if(products_viewed_List != null && products_viewed_List.size() > 0)
                            {
                                for(Integer k =0 ;k<products_viewed_List.size() ; k++)
                                {
                                    Products_Viewed__c ProductViewObj = new  Products_Viewed__c();
                                    
                                    if(products_viewed_List[k].product_name != null)
                                        ProductViewObj.Name = products_viewed_List[k].product_name;
                                    
                                    if(products_viewed_List[k].category != null)
                                        ProductViewObj.Product_Category__c = products_viewed_List[k].category;
                                    
                                    if(products_viewed_List[k].product_url != null)
                                        ProductViewObj.Product_Url__c = products_viewed_List[k].product_url;
                                    
                                    ProductViewObj.External_Id__c = ProductViewObj.Name+ProductViewObj.Product_Category__c+ContactObj.Id;
                                    
                                    ProductViewObj.Customer_Contact__c = ContactObj.Id;
                                    ProductViewMap.put(ProductViewObj.External_Id__c,ProductViewObj);
                                }
                            }
                            
                            
                            //Wish List Record Insertion
                            if(wish_lists_List != null && wish_lists_List.size() > 0)
                            {
                                for(Integer k =0 ;k<wish_lists_List.size() ; k++)
                                {
                                    Wish_List__c WishObj = new  Wish_List__c();
                                    
                                    if(wish_lists_List[k].product_name != null)
                                        WishObj.Name = wish_lists_List[k].product_name;
                                    
                                    if(wish_lists_List[k].category != null)
                                        WishObj.Product_Category__c = wish_lists_List[k].category;
                                    
                                    WishObj.External_Id__c = WishObj.Name+WishObj.Product_Category__c+ContactObj.Id;
                                    
                                    WishObj.Customer_Contact__c = ContactObj.Id;
                                    WishListMap.put(WishObj.External_Id__c,WishObj);
                                }
                            }
                            
                            //Last Five Logins Record Insertion
                            
                            if(last_five_logins_List != null && last_five_logins_List.size() > 0)
                            {
                                LoginList = new  List<Last_Five_Logins__c>();
                                
                                for(Integer k =0 ;k<last_five_logins_List.size() ; k++)
                                {
                                    Last_Five_Logins__c lastFiveObj = new  Last_Five_Logins__c();
                                    
                                    if(last_five_logins_List[k].date1 != null)
                                        lastFiveObj.Name = last_five_logins_List[k].date1;
                                    
                                    lastFiveObj.External_Id__c = String.valueOf(ContactObj.Id)+'login'+String.valueOf(k);
                                    
                                    lastFiveObj.Customer_Contact__c = ContactObj.Id;
                                    LoginListMap.put(lastFiveObj.External_Id__c,lastFiveObj);
                                }
                            }
                            
                            //Products on Cart Record Insertion
                            
                            if(cart_items_List != null && cart_items_List.size() > 0)
                            {
                                
                                // List< Products_on_Cart__c > ProductCartList = new  List< Products_on_Cart__c >();
                                set<String> ProductIDSet = new set<String>();
                                
                                Map<String,String> ActiveProductMap = new Map<String,String>();
                                
                                for(Integer k =0 ;k<cart_items_List.size() ; k++)
                                {
                                    Products_on_Cart__c ProductObj = new  Products_on_Cart__c();
                                    
                                    if(cart_items_List[k].product_id != null)
                                    {
                                        ProductObj.Product_id__c = cart_items_List[k].product_id;
                                        ProductIDSet.add(cart_items_List[k].product_id);
                                    }
                                    
                                    String ExtId = null;
                                    
                                    if(cart_items_List[k].product_id != null && cart_items_List[k].product_id  != '' && cart_items_List[k].product_name != null && cart_items_List[k].product_name != '')
                                        ExtId = (String.valueOf(cart_items_List[k].product_name)+String.valueOf(cart_items_List[k].product_id)+String.valueOf(ContactObj.Email));
                                    else if(EcommersList[i].cart_items[k] != null  && EcommersList[i].cart_items[k].product_id  != null && EcommersList[i].cart_items[k].product_id  != '')
                                        ExtId = (String.valueOf(cart_items_List[k].product_id)+String.valueOf(ContactObj.Email));
                                    
                                    if(ExistingProductCart_Map.get(ExtId) == null && cart_items_List[k].Product_id != null && cart_items_List[k].Product_id != '')
                                    {
                                        
                                        ProductObj.Product_id__c = cart_items_List[k].product_id;
                                        
                                        if(cart_items_List[k].product_name != null)
                                            ProductObj.Name = cart_items_List[k].product_name;
                                        
                                        if(cart_items_List[k].category != null)
                                            ProductObj.Category__c = cart_items_List[k].category;
                                        
                                        if(cart_items_List[k].price != null && cart_items_List[k].price != '')
                                            ProductObj.Price__c = String.Valueof(Decimal.valueOf(cart_items_List[k].price.replaceAll('[^.\\d]','')));
                                        
                                        if(cart_items_List[k].quanitity != null && cart_items_List[k].quanitity != '')
                                            ProductObj.Quanitity__c = String.Valueof(Decimal.valueOf(cart_items_List[k].quanitity.replaceAll('[^.\\d]','')));
                                        
                                        if(cart_items_List[k].size != null)
                                            ProductObj.Size__c = cart_items_List[k].size;
                                        
                                        if(cart_items_List[k].sku != null && cart_items_List[k].sku != '')
                                            ProductObj.sku__c = cart_items_List[k].sku;
                                        
                                        ProductObj.Active__c = true;
                                        
                                        ProductObj.Customer_Contact__c = ContactObj.Id;
                                        ProductObj.External_Id__c = ExtId;
                                        
                                        ProductCartList.add(ProductObj);
                                    }
                                    else
                                    {
                                        if(ExistingProductCart_Map.get(ExtId) != null)
                                        {
                                            ProductObj = ExistingProductCart_Map.get(ExtId);
                                            ProductObj.Active__c = true;
                                            ProductCartList.add(ProductObj);
                                        }
                                    }
                                }
                                
                                try
                                {
                                    upsert ProductCartList External_Id__c;
                                    if(ProductCartList != null && ProductCartList.size()>0)
                                    { 
                                        /* List<Task> tlist = [SELECT Status,Subject,WhoCount,WhoId, Interested__c FROM Task where Subject=:'Abdondoned Cart' and WhoId =: ContactObj.Id And Interested__c =: false ];

if(tlist == null || tlist.size() == 0)  
{
Task t = new Task();
t.Subject = 'Validate Abandoned Cart Reason';
t.WhoId = ContactObj.Id;
t.OwnerId = ISTUser[0].Id;
t.ActivityDate = system.today();
t.Status = 'Open';
t.Priority = 'High';
try
{
insert t;
*/
                                        /*Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
mail.setTargetObjectId(ContactObj.Id); 
mail.setSenderDisplayName('Abandaon Cart'); 
mail.setUseSignature(false); 
mail.setBccSender(false); 
mail.setSaveAsActivity(false); 
EmailTemplate et=[Select id from EmailTemplate where Name=:'Abandaon Cart- Promo Code Mailer']; 
mail.setTemplateId(et.id); 
Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
*/
                                        /* System.debug('t------'+ProductCartList);
}
catch (Exception e){}
} */
                                    }
                                    
                                    
                                    /**** last3 days****/
                                    /*  Integer last3dayProduct = 0;
for(Integer l = 0 ; l< ProductCartList.size(); l++)
{
System.debug('ProductCartList[i]------'+ProductCartList[l]);
if((ProductCartList[l].CreatedDate != null) && (ProductCartList[l].LastModifiedDate != null))
{
if((Date.valueOf(ProductCartList[l].LastModifiedDate - 3)) >= Date.valueOf(ProductCartList[l].CreatedDate))
{
last3dayProduct = last3dayProduct + 1;
System.debug('last3dayProduct[------'+last3dayProduct);
}

}
else
{
break;
}
}

System.debug('ProductCartList------'+ProductCartList);

if(ProductCartList != null && ProductCartList.size() != 0 && last3dayProduct == ProductCartList.size())
{
System.debug('last3dayProduct****---'+last3dayProduct);
if(ISTUser != null && ISTUser.size()>0)
{

System.debug('ISTUser****---'+ISTUser);
Task t = new Task();
t.Subject = 'Abdondoned Cart';
t.WhoId = ContactObj.Id;
t.OwnerId = ISTUser[0].Id;
t.ActivityDate = system.today();
t.Status = 'Open';
t.Priority = 'High';
try
{
insert t;
System.debug('t------'+ProductCartList);
}
catch (Exception e){}

}
}

*/
                                    /**** End last3 days****/
                                    
                                }
                                catch (Exception e){}
                                if(ExistingOrderWithEmail_Map.get(ContactObj.Email) != null && (ExistingOrderWithEmail_Map.get(ContactObj.Email)).size()>0)
                                {
                                    List< Products_on_Cart__c > InActiveProductCartList = ExistingOrderWithEmail_Map.get(ContactObj.Email);
                                    
                                    Map<String,Products_on_Cart__c>  tempProductCartMap = new Map<String,Products_on_Cart__c>();
                                    for(Integer l = 0 ; l< InActiveProductCartList.size(); l++)
                                    {
                                        Products_on_Cart__c proObj = InActiveProductCartList[l];
                                        if(proObj.External_Id__c != null)
                                            tempProductCartMap.put(String.valueOf(proObj.External_Id__c),proObj);
                                    }
                                    
                                    for(Integer l = 0 ; l< ProductCartList.size(); l++)
                                    {
                                        if(tempProductCartMap.containsKey(ProductCartList[l].External_Id__c) == true)
                                        {
                                            tempProductCartMap.remove(ProductCartList[l].External_Id__c);
                                        }
                                    }
                                    
                                    
                                    InActiveProductCartList = new List< Products_on_Cart__c >();
                                    
                                    for(Products_on_Cart__c product: tempProductCartMap.values())
                                    {
                                        product.Active__c = false;
                                        InActiveProductCartList.add(product);
                                    }
                                    
                                    if(InActiveProductCartList != null && InActiveProductCartList.size()>0)
                                        try
                                    {
                                        update InActiveProductCartList;
                                    }
                                    catch (Exception e){}
                                    
                                }
                            }
                            
                            //Opportunity record insertion
                            if(!ProductCartList.isEmpty()){
                                string contactZip = ContactObj.zipcode__c;
                                List<User> allUesrs = [select Id, Pin_codes__c from User where UserRole.Name ='Inside Sales Team'];
                                List<String> allPinCodes = new List<String>();
                                List<ID> listOFID = new List<ID>();
                                for(User u : allUesrs)
                                {
                                    if(u.Pin_codes__c!=null)
                                    {
                                        allPinCodes.add(u.Pin_codes__c);
                                        listOFID.add(u.id);
                                    }
                                }
                                
                                Opportunity opp =new Opportunity();
                                //Code Added By Ajinkya
                                Integer cnt = [select count() from Opportunity where (Status__c='Active' OR Status__c='Completed') 
                                               And (LeadSource!='E-Commerce')  And StageName!='Maintaining/Closing' And Contact2__c =: ContactObj.Id];
                                if(cnt > 0)
                                {
                                    List<Opportunity> oppl = [select Id, Name, LeadSource, Status__c,MS__c,Flag_abandoned_cart__c,Prospect_Interest_Type__c ,Override90to100__c, Actual_Closing_Date__c,Flag_Sample_Requested__c,StageName from
                                                              Opportunity where (Status__c='Active' OR Status__c='Completed') And (LeadSource!='E-Commerce')  And StageName!='Maintaining/Closing' And Contact2__c =: ContactObj.Id Limit 1];
                                    if(oppl.size()>0)
                                        opp  = oppl[0];
                                    //opp.Flag_abandoned_cart__c = true;
                                    if(opp.Prospect_Interest_Type__c == 'Sample Requested')
                                        opp.Flag_Sample_Requested__c = true;
                                    if(oppl[0].Prospect_Interest_Type__c=='Sample Requested' )                                    
                                        opp.Flag_Sample_Requested__c = true;
                                    
                                    //opp.LeadSource = 'E-Commerce';
                                    //opp.StageName = 'Maintaining/Closing';
                                    opp.Actual_Closing_date__c = System.today();
                                    if(ContactObj.What_is_the_purpose_use__c != null && (ContactObj.What_is_the_purpose_use__c == 'Maintenance of Machinery or Facility' || ContactObj.What_is_the_purpose_use__c == 'Personal Use or Home equipment Repair'))
                                        opp.MS__c = 'MRO';
                                    else if(ContactObj.What_is_the_purpose_use__c != null && (ContactObj.What_is_the_purpose_use__c == 'For use in product assembly or manufacturing'))  
                                        opp.MS__c = 'GM';
                                    else if(ContactObj.What_is_the_purpose_use__c != null && (ContactObj.What_is_the_purpose_use__c == 'Automotive repair & maintenance'))  
                                        opp.MS__c = 'VRM'; 
                                    else 
                                    {
                                        opp.MS__c = ''; 
                                    opp.RecurringBusiness__c = 'One Time';
                                    opp.Status__c = 'Active';
                                    //opp.Ecommerce_TimeStamp__c = System.now();
                                    opp.External_Id__c = ContactObj.Email + orderObject.clientOrderNumber+orderObject.IBOrderNumber;
                                        }
                                    try
                                    {
                                        update opp ;
                                        
                                        system.debug('&&&&&&&opp&&'+opp);
                                    }
                                    catch (Exception e)
                                    {
                                        System.debug('Exception---'+e.getLineNumber());
                                    }
                                }
                                else
                                {
                                    opp.Contact2__c = ContactObj.Id;
                                    opp.AccountId = ContactObj.AccountId;
                                    opp.Name = 'DG-AG-SU-Product-Application';
                                    opp.StageName = 'Sample Sent/Inquiry Received';
                                    opp.Probability = 15;
                                    opp.CloseDate = Date.Today().addDays(60);
                                    //opp.LeadSource = 'E-Commerce';
                                    opp.Flag_Product_Check__c = true;
                                    if(ContactObj.What_is_the_purpose_use__c != null && (ContactObj.What_is_the_purpose_use__c == 'Maintenance of Machinery or Facility' || ContactObj.What_is_the_purpose_use__c == 'Personal Use or Home equipment Repair'))
                                        opp.MS__c = 'MRO';
                                    else if(ContactObj.What_is_the_purpose_use__c != null && (ContactObj.What_is_the_purpose_use__c == 'For use in product assembly or manufacturing'))  
                                        opp.MS__c = 'GM';
                                    else if(ContactObj.What_is_the_purpose_use__c != null && (ContactObj.What_is_the_purpose_use__c == 'Automotive repair & maintenance'))  
                                        opp.MS__c = 'VRM'; 
                                    else 
                                        opp.MS__c = ''; 
                                    opp.RecurringBusiness__c = 'One Time';    
                                    opp.Status__c = 'Active';
                                    Integer a = -1;
                                    for(String pinCode:allPinCodes)
                                    {
                                        a++;
                                        if(pinCode.Contains(contactZip))
                                        {
                                            opp.Assigned_IST_User__c = listOFID[a];
                                            break;
                                        }
                                    }
                                    insert opp;
                                }//Code Added By Ajinkya End
                                
                                
                                Set<String> allSkuId = new Set<String>();
                                List<Products_on_Cart__c> listId = [select sku__c,Quanitity__c,Price__c from Products_on_Cart__c where Customer_Contact__c =: ContactObj.Id];
                                for(Integer r = 0; r < listId.size(); r++){
                                    allSkuId.add(listId[r].sku__c);
                                }
                                Map<String,String> prodMap = new  Map<String,String>();
                                for(Product2 prod :  [SELECT IB_SKU__c,Id FROM Product2 where IB_SKU__c IN: allSkuId and IsActive=true])
                                {
                                    prodMap.put(prod.IB_SKU__c,prod.Id);
                                }
                                System.debug('Product Map is:..... '+prodMap);
                                List<OpportunityLineItem> oppItemList = new List<OpportunityLineItem>();
                                if(prodMap != null){
                                    for(Integer p = 0; p< listId.size(); p++){
                                        if(prodMap.get(listId[p].SKU__c) != null){
                                            List<OpportunityLineItem> prodPrice = [select Id,ListPrice,UnitPrice from OpportunityLineItem where Product2.IB_SKU__c=: listId[p].SKU__c limit 1];
                                            
                                            List<pricebookentry> priceidList = [select Id from pricebookentry where Product2Id =: prodMap.get(listId[p].SKU__c) limit 1];
                                            
                                            if(priceidList!=null && priceidList.size() >0){
                                                OpportunityLineItem oppItem = new OpportunityLineItem();
                                                oppItem.OpportunityId = opp.Id;
                                                oppItem.PricebookEntryId = priceidList[0].id;
                                                oppItem.Quantity = Decimal.valueOf(listId[p].Quanitity__c);
                                                oppItem.UnitPrice = prodPrice[0].ListPrice ;
                                                oppItemList.add(oppItem);
                                            }
                                        }
                                        
                                    }
                                    try
                                    {
                                        insert oppItemList;
                                    }
                                    catch(Exception e)
                                    {
                                        system.debug('exception...  '+e.getMessage()+'***line no*****'+e.getLineNumber());
                                    }
                                    
                                } 
                            }
                            
                            //Payment Information Record Insertion
                            
                            if(orderObject != null && orderObject.clientOrderNumber != null && orderObject.clientOrderNumber != '' && orderObject.IBOrderNumber != null && orderObject.IBOrderNumber != '')
                            {
                                
                               // system.debug('********Order*******'+ContactObj);
                                
                                Opportunity opp = new Opportunity();
                                Integer cnt = [select count() from Opportunity where (Status__c='Active' OR Status__c='Completed') 
                                               And (LeadSource!='E-Commerce')  And StageName!='Maintaining/Closing' And Contact2__c =: ContactObj.Id];
                               // System.debug('********count*****'+cnt);
                                if(cnt > 0)
                                {
                                    
                                    List<Opportunity> oppl = [select Id, Name, LeadSource, Status__c,MS__c,Flag_Product_Check__c,Flag_abandoned_cart__c,Prospect_Interest_Type__c ,Override90to100__c, Actual_Closing_Date__c,Flag_Sample_Requested__c,StageName from
                                                              Opportunity where (Status__c='Active' OR Status__c='Completed') And (LeadSource!='E-Commerce')  And StageName!='Maintaining/Closing' And Contact2__c =: ContactObj.Id Limit 1];
                                    if(oppl.size()>0)
                                        opp  = oppl[0];
                                    opp.Flag_Ecommerce__c = true;
                                    if(opp.Prospect_Interest_Type__c == 'Sample Requested')
                                        opp.Flag_Sample_Requested__c = true;
                                    if(oppl[0].Prospect_Interest_Type__c=='Sample Requested' )                                    
                                        opp.Flag_Sample_Requested__c = true;
                                    
                                    if(opp.Flag_Product_Check__c == true)
                                        opp.LeadSource = 'E-Commerce';
                                    
                                    opp.StageName = 'Maintaining/Closing';
                                    opp.Actual_Closing_date__c = System.today();
                                    if(ContactObj.What_is_the_purpose_use__c != null && (ContactObj.What_is_the_purpose_use__c == 'Maintenance of Machinery or Facility' || ContactObj.What_is_the_purpose_use__c == 'Personal Use or Home equipment Repair'))
                                        opp.MS__c = 'MRO';
                                    else if(ContactObj.What_is_the_purpose_use__c != null && (ContactObj.What_is_the_purpose_use__c == 'For use in product assembly or manufacturing'))  
                                        opp.MS__c = 'GM';
                                    else if(ContactObj.What_is_the_purpose_use__c != null && (ContactObj.What_is_the_purpose_use__c == 'Automotive repair & maintenance'))  
                                        opp.MS__c = 'VRM'; 
                                    else 
                                        opp.MS__c = ''; 
                                    opp.RecurringBusiness__c = 'One Time';
                                    opp.Status__c = 'Completed';
                                    opp.Ecommerce_TimeStamp__c = System.now();
                                    opp.External_Id__c = ContactObj.Email + orderObject.clientOrderNumber+orderObject.IBOrderNumber;
                                    try
                                    {
                                        update opp ;
                                        
                                        system.debug('&&&&&&&opp&&'+opp);
                                    }
                                    catch (Exception e){
                                        System.debug('*******'+e);
                                        System.debug('Line Number-------->'+e.getLineNumber());
                                    }
                                }
                                else
                                {
                                    
                                    opp.Name = 'DG-AG-SU-Product-Application'; //'Order No. ' + orderObject.clientOrderNumber;
                                    opp.LeadSource = 'E-Commerce';
                                    opp.Contact2__c = ContactObj.Id;
                                    opp.AccountId = ContactObj.AccountId;
                                    opp.StageName = 'Maintaining/Closing';
                                    opp.Status__c = 'Completed';
                                    opp.CloseDate = System.today();
                                    opp.Actual_Closing_date__c = System.today();
                                    opp.External_Id__c = ContactObj.Email + orderObject.clientOrderNumber+orderObject.IBOrderNumber;
                                    opp.Flag_Ecommerce__c = true;
                                    opp.Ecommerce_TimeStamp__c = System.now();
                                    opp.RecurringBusiness__c = 'One Time';
                                    
                                    if(ContactObj.What_is_the_purpose_use__c != null && (ContactObj.What_is_the_purpose_use__c == 'Maintenance of Machinery or Facility' || ContactObj.What_is_the_purpose_use__c == 'Personal Use or Home equipment Repair'))
                                        opp.MS__c = 'MRO';
                                    else if(ContactObj.What_is_the_purpose_use__c != null && (ContactObj.What_is_the_purpose_use__c == 'For use in product assembly or manufacturing'))  
                                        opp.MS__c = 'GM';
                                    else if(ContactObj.What_is_the_purpose_use__c != null && (ContactObj.What_is_the_purpose_use__c == 'Automotive repair & maintenance'))  
                                        opp.MS__c = 'VRM'; 
                                    else 
                                        opp.MS__c = '';
                                    
                                    try
                                    {
                                        upsert opp External_Id__c;
                                        system.debug('&&&&&&&opp&&'+opp);
                                        
                                    }
                                    catch (Exception e){}
                                }
                                
                                
                                Order_Information__c OrderInfo = new Order_Information__c();
                                
                                OrderInfo.Name = orderObject.clientOrderNumber;
                                OrderInfo.Project__c = opp.Id;
                                
                                if(orderObject.orderDate != null)
                                    OrderInfo.orderDate__c = orderObject.orderDate;
                                
                                if(orderObject.email != null)
                                    OrderInfo.Email__c = orderObject.email;
                                
                                if(orderObject.IBOrderNumber != null )
                                    OrderInfo.Order_Number__c = orderObject.IBOrderNumber;    
                                
                                if(orderObject.IBOrderStatus != null )
                                    OrderInfo.Payment_Status__c = orderObject.IBOrderStatus;
                                
                                
                                if(orderObject.IBTrackingNumber != null )
                                    OrderInfo.Tracking_Number__c = orderObject.IBTrackingNumber;
                                
                                if(orderObject.IBShippingDate != null )
                                    OrderInfo.Shipping_Date__c = orderObject.IBShippingDate;
                                
                                if(orderObject.IBArrivingDate != null )
                                    OrderInfo.Arriving_Date__c = orderObject.IBArrivingDate;
                                
                                
                                if(orderObject.IBInvoiceUrl != null )
                                    OrderInfo.Invoice_URL__c = orderObject.IBInvoiceUrl;
                                
                                
                                if(orderObject.shippingAddress != null)
                                {
                                    if(orderObject.shippingAddress.name != null)
                                        OrderInfo.Shipping_Name__c = orderObject.shippingAddress.name;
                                    
                                    if(orderObject.shippingAddress.email != null)
                                        OrderInfo.Shipping_Email__c = orderObject.shippingAddress.email;
                                    
                                    if(orderObject.shippingAddress.address != null)
                                        OrderInfo.Shipping_Address__c = orderObject.shippingAddress.address;
                                    
                                    if(orderObject.shippingAddress.pincode != null)
                                        OrderInfo.Shipping_Pincode__c = orderObject.shippingAddress.pincode;
                                    
                                    if(orderObject.shippingAddress.phone != null)
                                        OrderInfo.Shipping_Phone__c = orderObject.shippingAddress.phone;
                                    
                                    if(orderObject.shippingAddress.city != null)
                                        OrderInfo.Shipping_City__c = orderObject.shippingAddress.city;
                                    
                                    if(orderObject.shippingAddress.state != null)
                                        OrderInfo.Shipping_State__c = orderObject.shippingAddress.state;
                                    
                                    if(orderObject.shippingAddress.country != null)
                                        OrderInfo.Shipping_Country__c = orderObject.shippingAddress.country;
                                    
                                    if(orderObject.shippingAddress.landmark != null)
                                        OrderInfo.Shipping_Landmark__c = orderObject.shippingAddress.landmark;
                                    
                                    if(orderObject.shippingAddress.gstinNumber != null)
                                        OrderInfo.Shipping_GSTInNumber__c = orderObject.shippingAddress.gstinNumber;
                                }
                                
                                if(orderObject.billingAddress != null)
                                {
                                    if(orderObject.billingAddress.name != null)
                                        OrderInfo.Billing_Name__c = orderObject.billingAddress.name;
                                    
                                    if(orderObject.billingAddress.email != null)
                                        OrderInfo.Billing_Email__c = orderObject.billingAddress.email;
                                    
                                    if(orderObject.billingAddress.address != null)
                                        OrderInfo.Billing_Address__c = orderObject.billingAddress.address;
                                    
                                    if(orderObject.billingAddress.pincode != null)
                                        OrderInfo.Billing_Pincode__c = orderObject.billingAddress.pincode;
                                    
                                    if(orderObject.billingAddress.phone != null)
                                        OrderInfo.Billing_Phone__c = orderObject.billingAddress.phone;
                                    
                                    if(orderObject.billingAddress.city != null)
                                        OrderInfo.Billing_City__c = orderObject.billingAddress.city;
                                    
                                    if(orderObject.billingAddress.state != null)
                                        OrderInfo.Billing_State__c = orderObject.billingAddress.state;
                                    
                                    if(orderObject.billingAddress.country != null)
                                        OrderInfo.Billing_Country__c = orderObject.billingAddress.country;
                                    
                                    if(orderObject.billingAddress.landmark != null)
                                        OrderInfo.Billing_Landmark__c = orderObject.billingAddress.landmark;
                                    
                                    if(orderObject.billingAddress.gstinNumber != null)
                                        OrderInfo.Billing_GSTInNumber__c = orderObject.billingAddress.gstinNumber;
                                }
                                
                                
                                if(orderObject.payment != null)
                                {
                                    if(orderObject.payment.paymentMode != null)
                                        OrderInfo.Payment_Mode__c = orderObject.payment.paymentMode;
                                    
                                    if(orderObject.payment.gateway != null)
                                        OrderInfo.Gateway__c = orderObject.payment.gateway;
                                    
                                    if(orderObject.payment.amount != null && orderObject.payment.amount != '')
                                        OrderInfo.Amount__c = String.Valueof(Decimal.valueOf(orderObject.payment.amount.replaceAll('[^.\\d]','')));
                                    
                                    if(orderObject.payment.transactionId != null)
                                        OrderInfo.Transaction_Id__c = orderObject.payment.transactionId;
                                    
                                    if(OrderInfo.Payment_Mode__c != 'Cash on delivery')
                                    {
                                        if(orderObject.payment.paymentRealizedOn != null)
                                            OrderInfo.Payment_Realized_On__c = String.valueOf(date.today().format());
                                        
                                        if(orderObject.payment.paymentReceivedDate != null)
                                            OrderInfo.Payment_Received_Date__c = String.valueOf(date.today().format());
                                        
                                    }
                                    
                                    if(orderObject.payment.pgTransactionId != null)
                                        OrderInfo.PG_Transaction_Id__c = orderObject.payment.pgTransactionId;
                                    
                                    if(orderObject.payment.chequeNumber != null)
                                        OrderInfo.Cheque_Number__c = orderObject.payment.chequeNumber;
                                    
                                    if(orderObject.payment.chequeIssueBank != null)
                                        OrderInfo.Cheque_Issue_Bank__c = orderObject.payment.chequeIssueBank;
                                    
                                    if(orderObject.payment.chequeDate != null)
                                        OrderInfo.Cheque_Date__c = orderObject.payment.chequeDate;
                                    
                                    if(orderObject.payment.bankRefNumber != null)
                                        OrderInfo.Bank_Ref_Number__c = orderObject.payment.bankRefNumber;
                                    
                                    if(orderObject.payment.bank != null)
                                        OrderInfo.Bank__c = orderObject.payment.bank;
                                    
                                    
                                    
                                    if(orderObject.payment.status != null)
                                        OrderInfo.Pay_Status__c = orderObject.payment.status;
                                }
                                
                                if(cart_Payment_List != null && cart_Payment_List.size()>0)  //User Cart Information
                                {
                                    if(cart_Payment_List[0].coupon_name != null && cart_Payment_List[0].coupon_name != '')
                                        OrderInfo.Coupon_Name__c = cart_Payment_List[0].coupon_name;
                                    
                                    if(cart_Payment_List[0].coupon_discount != null && cart_Payment_List[0].coupon_discount != '')
                                        OrderInfo.Discount_Price__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].coupon_discount.replaceAll('[^.\\d]','')));
                                    
                                    if(cart_Payment_List[0].intro_discount != null && cart_Payment_List[0].intro_discount != '')
                                        OrderInfo.Intro_Discount__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].intro_discount.replaceAll('[^.\\d]','')));
                                    
                                    if(cart_Payment_List[0].bulk_discount != null && cart_Payment_List[0].bulk_discount != '')
                                        OrderInfo.bulk_discount__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].bulk_discount.replaceAll('[^.\\d]','')));
                                    
                                    if(cart_Payment_List[0].GST != null && cart_Payment_List[0].GST != '')
                                        OrderInfo.GST__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].GST.replaceAll('[^.\\d]','')));
                                    
                                    if(cart_Payment_List[0].subtotal != null && cart_Payment_List[0].subtotal != '')
                                        OrderInfo.Subtotal__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].subtotal.replaceAll('[^.\\d]','')));
                                    
                                    if(cart_Payment_List[0].Total != null && cart_Payment_List[0].Total != '')
                                        OrderInfo.Total__c = String.Valueof((Decimal.valueOf(cart_Payment_List[0].Total.replaceAll('[^.\\d]',''))).setScale(2, RoundingMode.HALF_UP));
                                    
                                    if(cart_Payment_List[0].org_total != null && cart_Payment_List[0].org_total != '')
                                        OrderInfo.org_total__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].org_total.replaceAll('[^.\\d]','')));
                                    
                                    if(cart_Payment_List[0].total_saving != null && cart_Payment_List[0].total_saving != '')
                                        OrderInfo.Total_Saving__c = String.Valueof(Decimal.valueOf(cart_Payment_List[0].total_saving.replaceAll('[^.\\d]','')));
                                    
                                    
                                }
                                
                                
                                OrderInfo.Customer_Contact__c = ContactObj.Id;
                                OrderInfo.External_Id__c = ContactObj.Email+OrderInfo.Name;
                                
                                try
                                {
                                    upsert OrderInfo External_Id__c;
                                }
                                catch (Exception e){}
                                
                                //System.debug('OrderInfo.Id '+OrderInfo.Id);
                                //System.debug('orderObject.orderItems '+orderObject.orderItems);
                                if(OrderInfo.Id != null && orderObject.orderItems != null && orderObject.orderItems.size() > 0)
                                {
                                    List<EcommerceWrapper.OrderItems> orderItem_list = orderObject.orderItems;
                                    
                                    List<Ordered_Product__c> orderProductList = new List<Ordered_Product__c>();
                                    
                                    Set<String> skuIdSet = new Set<String>();
                                    
                                    for(Integer k = 0 ; k<orderItem_list.size(); k++)
                                    {
                                        if(orderItem_list[k].id != null && orderItem_list[k].id != '')
                                        {
                                            Ordered_Product__c orderProduct = new Ordered_Product__c();
                                            orderProduct.Product_Id__c = orderItem_list[k].id;
                                            
                                            if(orderItem_list[k].sku != null)
                                            {
                                                orderProduct.SKU__c = orderItem_list[k].sku;
                                                skuIdSet.add(orderProduct.SKU__c);
                                            }
                                            
                                            if(orderItem_list[k].image != null)
                                                orderProduct.image_url__c = orderItem_list[k].image;
                                            
                                            if(orderItem_list[k].quantity != null && orderItem_list[k].quantity != '')
                                                orderProduct.Quanitity__c = String.Valueof(Decimal.valueOf(orderItem_list[k].quantity.replaceAll('[^.\\d]','')));
                                            
                                            if(orderItem_list[k].itemTitle != null)
                                                orderProduct.Name = orderItem_list[k].itemTitle;
                                            
                                            if(orderItem_list[k].tax != null && orderItem_list[k].tax != '')
                                                orderProduct.Tax__c = String.Valueof(Decimal.valueOf(orderItem_list[k].tax.replaceAll('[^.\\d]','')));
                                            
                                            if(orderItem_list[k].taxPercentage != null)
                                                orderProduct.Tax_Percentage__c = String.Valueof(orderItem_list[k].taxPercentage);
                                            
                                            if(orderItem_list[k].strikedOffPrice != null && orderItem_list[k].strikedOffPrice != '')
                                                orderProduct.Striked_Off_Price__c = String.Valueof(Decimal.valueOf(orderItem_list[k].strikedOffPrice.replaceAll('[^.\\d]','')));
                                            
                                            if(orderItem_list[k].taxInclusivePrice != null && orderItem_list[k].taxInclusivePrice != '')
                                                orderProduct.Tax_Inclusive_Price__c = String.Valueof(Decimal.valueOf(orderItem_list[k].taxInclusivePrice.replaceAll('[^.\\d]','')));
                                            
                                            if(orderItem_list[k].codCharge != null)
                                                orderProduct.CodCharge__c = String.Valueof(orderItem_list[k].codCharge);
                                            
                                            if(orderItem_list[k].shippingCharge != null)
                                                orderProduct.Shipping_Charge__c = String.Valueof(orderItem_list[k].shippingCharge);
                                            
                                            if(orderItem_list[k].coupon_discount != null )
                                                orderProduct.Coupon_Discount__c = orderItem_list[k].coupon_discount;
                                            
                                            if(orderItem_list[k].intro_discount != null )
                                                orderProduct.Intro_Discount__c = orderItem_list[k].intro_discount;
                                            
                                            if(orderItem_list[k].bulk_discount != null )
                                                orderProduct.Bulk_Discount__c = orderItem_list[k].bulk_discount;
                                            
                                            if(orderItem_list[k].subtotal != null )
                                                orderProduct.Subtotal__c = orderItem_list[k].subtotal;
                                            
                                            if(orderItem_list[k].total != null )
                                                orderProduct.Total__c = orderItem_list[k].total;
                                            
                                            
                                            if(orderItem_list[k].IBOrderStatus != null )
                                                orderProduct.Order_Status__c = orderItem_list[k].IBOrderStatus;
                                            
                                            if(orderItem_list[k].IBTrackingNumber != null )
                                                orderProduct.Tracking_Number__c = orderItem_list[k].IBTrackingNumber;
                                            
                                            if(orderItem_list[k].IBShippingDate != null )
                                                orderProduct.Shipping_Date__c = orderItem_list[k].IBShippingDate;
                                            
                                            if(orderItem_list[k].IBArrivingDate != null )
                                                orderProduct.Arriving_Date__c = orderItem_list[k].IBArrivingDate;
                                            
                                            if(orderItem_list[k].IBInvoiceUrl != null )
                                                orderProduct.Invoice_URL__c = orderItem_list[k].IBInvoiceUrl;                                           
                                            
                                            orderProduct.Order_Information__c = OrderInfo.Id;
                                            
                                            orderProduct.External_Id__c = OrderInfo.Id+orderProduct.Product_Id__c+orderProduct.SKU__c;
                                            
                                            orderProductList.add(orderProduct);
                                        }
                                    }
                                    
                                    // System.debug('------------------orderProductList--------'+orderProductList);
                                    try
                                    {
                                        upsert orderProductList External_Id__c;
                                        
                                        List< Products_on_Cart__c > deleteCartOrder = [Select Id from Products_on_Cart__c where sku__c IN: skuIdSet And Customer_Contact__c =: ContactObj.Id];
                                        
                                        delete deleteCartOrder;
                                        
                                        List<OpportunityLineItem> opplist = [select Id from OpportunityLineItem where OpportunityId =:opp.Id];
                                        system.debug('opplist');
                                        delete opplist;
                                        
                                        List<Secondary_Sales_Data__c> ssdList=[Select id,Opportunity__c from Secondary_Sales_Data__c where Opportunity__c=:opp.Id];
                                        delete ssdList;
                                        
                                        
                                        if(orderObject.IBOrderStatus != null || orderObject.IBOrderStatus == 'Order placed' )                                       
                                            OrderInfo.IndustryBuying_Status__c  = 'Confirmed';
                                        
                                        /*  if(orderObject.IBOrderStatus != null && orderObject.IBOrderStatus == 'Order shipped' )                                      
OrderInfo.IndustryBuying_Status__c  = 'Dispatched';

if(orderObject.IBOrderStatus != null && orderObject.IBOrderStatus == 'Order out for delivery' )                                     
OrderInfo.IndustryBuying_Status__c  = 'Out for Delivery';

if(orderObject.IBOrderStatus != null && orderObject.IBOrderStatus == 'Order delivered' )                                        
OrderInfo.IndustryBuying_Status__c  = 'Delivered';*/
                                        
                                        Set<String> skuSet = new Set<String>();
                                        
                                        for(Integer m = 0 ; m < orderProductList.size(); m++)
                                        {
                                            skuSet.add(orderProductList[m].SKU__c);
                                        }
                                        
                                        Map<String,String> prod2Map = new  Map<String,String>();
                                        for(Product2 prod2 :  [SELECT IB_SKU__c,Id FROM Product2 where IB_SKU__c IN: skuSet and IsActive=true])
                                        {
                                            prod2Map.put(prod2.IB_SKU__c,prod2.Id);
                                        }
                                        
                                        map<String,OpportunityLineItem> OppProductMap = new map<String,OpportunityLineItem>();
                                        if(prod2Map != null && orderProductList != null && orderProductList.size()>0 && opp.Id != null)
                                        {
                                            for(Integer m = 0 ; m < orderProductList.size(); m++)
                                            {
                                                if(prod2Map.get(orderProductList[m].SKU__c) != null)
                                                {
                                                    List<pricebookentry> priceid = [select Id from pricebookentry where Product2Id =: prod2Map.get(orderProductList[m].SKU__c) limit 1];
                                                    //System.debug('Orderrrrr'+prod2Map.get(orderProductList[m].SKU__c)+'----'+priceid);
                                                    if(priceid!=null && priceid.size() >0){
                                                        System.debug('opportunity id'+opp.Id);
                                                        OpportunityLineItem oppLineItemObj = new OpportunityLineItem();
                                                        
                                                        List<OpportunityLineItem> getPrice = [select Id,ListPrice from OpportunityLineItem where Product2.IB_SKU__c=: orderProductList[m].SKU__c limit 1];
                                                        
                                                        
                                                        System.debug('^^^^^^^getPrice^^^^^'+getPrice+'------'+orderProductList[m].SKU__c);
                                                        if(getPrice != null && getPrice.size()>0)
                                                        {
                                                            //oppLineItemObj.ListPrice = opp.Id;
                                                            oppLineItemObj.OpportunityId = opp.Id;
                                                            oppLineItemObj.PricebookEntryId = priceid[0].Id;
                                                            oppLineItemObj.Product2Id = prod2Map.get(orderProductList[m].SKU__c);
                                                            oppLineItemObj.UnitPrice =getPrice[0].ListPrice; //Decimal.valueOf(orderProductList[m].Striked_Off_Price__c);
                                                            oppLineItemObj.Quantity = Decimal.valueOf(orderProductList[m].Quanitity__c);
                                                            oppLineItemObj.External_Id__c = String.valueOf(oppLineItemObj.OpportunityId)+String.valueOf(oppLineItemObj.Product2Id)+String.valueOf(OrderInfo.Id);
                                                            
                                                            //System.debug('^^^^^^^oppLineItemObj^^^^^'+oppLineItemObj);
                                                            
                                                            OppProductMap.put(oppLineItemObj.External_Id__c,oppLineItemObj);
                                                            
                                                            System.debug('^^^^^^^OppProductMap^^^^^'+OppProductMap);
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            //System.debug('^^^^^^^OppProductMap1^^^^^'+OppProductMap);
                                            if(OppProductMap != null)
                                            {
                                                List<OpportunityLineItem> OppLineItemList = OppProductMap.values();
                                                if(OppLineItemList != null)
                                                {
                                                    upsert OppLineItemList External_Id__c;
                                                }
                                            }
                                        }
                                        try
                                        {
                                            update OrderInfo;
                                        }
                                        catch (Exception e){}
                                        
                                    }
                                    catch(Exception e)
                                    {
                                        System.debug('*******'+e);
                                    }
                                    
                                }
                                
                                //Close any Sampling Project
                                /* Integer cnt = [select count() from Opportunity where Status__c='Active'
And (LeadSource='' OR LeadSource=null Or LeadSource='Sample Requested') And Contact2__c =: ContactObj.Id];
if(cnt > 0)
{
Opportunity opp2 = [select Id, StageName, LeadSource, Status__c, Override90to100__c, Actual_Closing_Date__c from
Opportunity where Status__c='Active' And (LeadSource='' OR LeadSource=null Or LeadSource='Sample Requested')
And Contact2__c =: ContactObj.Id Limit 1];
//opp2.LeadSource = 'E-Commerce';
opp2.StageName = 'Maintaining/Closing';
opp2.Status__c = 'Completed';
opp2.Override90to100__c = True;
opp2.Actual_Closing_date__c = System.today();
opp2.Flag_Ecommerce__c = true;
opp2.Flag_Sample_Requested__c = true;
opp2.OwnerId = UserInfo.getUserId();  //opp2 owner to logged in user
try
{
update opp2;
}
catch (Exception e){}

}
*/
                                /* 
if(OrderInfo.Pay_Status__c == 'failure')
{
Opportunity opp3 = new Opportunity();
opp3.Name = 'Fail Order';//'Order No. ' + orderObject.clientOrderNumber;
opp3.LeadSource = 'E-Commerce';
opp3.Contact2__c = ContactObj.Id;
opp3.AccountId = ContactObj.AccountId;
opp3.StageName = 'Trial Successful & Business Qualified';
opp3.Amount = Decimal.valueOf(OrderInfo.Amount__c);
opp3.Status__c = 'Completed';
opp3.CloseDate = System.today();
opp3.Actual_Closing_date__c = System.today();
opp3.External_Id__c = ContactObj.Email + orderObject.clientOrderNumber+opp3.Name;
opp3.Flag_Ecommerce__c = true;

if(ISTUser != null && ISTUser.size() > 0)
opp3.Assigned_IST_User__c = ISTUser[0].Id;

upsert opp3 External_Id__c;
}*/
                                
                            }
                        }
                    }
                    
                    if(SearchKeyMap != null)
                    {
                        SearchKeyList = SearchKeyMap.values();
                        if (SearchKeyList != null)
                        {
                            try{
                                upsert SearchKeyList External_Id__c;
                            }catch (Exception e) {}
                        }
                    }
                    
                    if(ProductViewMap != null)
                    {
                        ProductViewList = ProductViewMap.values();
                        if (ProductViewList != null){
                            try{
                                upsert ProductViewList External_Id__c;
                            }catch (Exception e) {}
                        }
                    }
                    
                    if(WishListMap != null)
                    {
                        WishList = WishListMap.values();
                        if (WishList != null){
                            try{
                                upsert WishList External_Id__c;
                            }catch (Exception e) {}
                        }
                    }
                    
                    if(LoginListMap != null)
                    {
                        LoginList = LoginListMap.values();
                        if (LoginList != null){
                            try{
                                upsert LoginList External_Id__c;
                            }catch (Exception e) {}
                        }
                    }
                    
                }
            }
            catch (Exception e)
            {
                System.debug('*******'+e);
                System.debug('Line Number-------->'+e.getLineNumber());
            }
        }
    }
}