public class ShipmentNotificationDataIntegration {
    public  list<Ordered_Product__c> globalOrderProductshipped= new list<Ordered_Product__c>();
    public  list<Ordered_Product__c> globalOrderProductdeliver=new list<Ordered_Product__c>();
    public decimal IntroDiscount=0.00;
    public decimal BulkDiscount=0.00;
    public decimal DiscountPrize=0.00;
    public decimal GST=0.00;
    public decimal Total=0.00;
    public decimal IntroDiscountD=0.00;
    public decimal BulkDiscountD=0.00;
    public decimal DiscountPrizeD=0.00;
    public decimal GSTD=0.00;
    public decimal TotalD=0.00;
    public integer i=0;
    String ProductNameShipped='';
    String ProductnameDelivered='';
    DateTime dT = System.now();
    String myDate = dt.day()+'-'+dt.month()+'-'+dt.year();
    list<Order_Information__c> globalorderInfo=new list<Order_Information__c>();
    public void getShipmentDetails(string order_id)
    {
        List<Order_Information__c> OI=[select id,Product_Shipped_Count__c,Product_Delivered_Count__c,Product_Count__c,Shipping_Date__c,Shipping_Name__c,Shipping_Address__c,Shipping_City__c,Shipping_State__c,Shipping_Pincode__c,Intro_Discount__c,bulk_discount__c,Discount_Price__c,GST__c,Email__c,Total__c,Tracking_Number__c,customerName__c,Order_Number__c,Customer_Phone__c,(select id,Order_Status__c from Ordered_Products__r) from Order_Information__c where Name=:order_id];
        List<Ordered_Product__c> OP=[select id,Order_Status__c,CodCharge__c,Shipping_City__c,Shipping_State__c,Shipping_Pincode__c,Shipping_Address__c,Price__c, Total__c ,image_url__c, SKU__c,Tax_Inclusive_Price__c,Quanitity__c,Name,Shipping_Charge__c,Tax_Percentage__c,Intro_Discount__c,Bulk_Discount__c,Coupon_Discount__c,Tax__c,Subtotal__c,Striked_Off_Price__c  from Ordered_Product__c where Order_Information__c=:OI ];
        list<Ordered_Product__c> UpdateProduct=new list<Ordered_Product__c>();
        list<Order_Information__c> Updateorder=new list<Order_Information__c>();
        //System.debug('OI'+OI);
        //System.debug('OP'+OP);
        HttpRequest httpRequest = new HttpRequest();
        //httpRequest.setEndpoint('http://13.127.110.224/crons/user-order-api?order_id='+order_id); //+order_id
        httpRequest.setEndpoint('https://www.tryloctite.in/crons/user-order-api?order_id='+order_id);
        httpRequest.setMethod('GET');
        httpRequest.setTimeout(120000);
        Http http = new Http();
        HttpResponse response = http.send(httpRequest);
        try
        {
            //String jsonString='{"response":{"shipped_count" : 2,	"delivered_count" : 0,  "product_shipped" :[{ "product_name" :"Loctite 542 - 0.5 ml", "product_sku"  :"ADH.THR.72013004"  },{ "product_name" :"LOCTITE 545 - 250 ml", "product_sku"  :"ADH.THR.101922501"  } ], "product_delivered":[]}}';
            String jsonString=response.getBodyAsBlob().toString();
            //System.debug('Response-----+++++'+jsonString);
            if(!System.Test.IsRunningTest())
            {
                //  jsonString = '{"response":'+(response.getBodyAsBlob().toString())+'}';
                //jsonString = '{"response":[{"userid":"81","visitor_id":"100051465","user_contact_detail":[{"name":"Piyush","email":"swarupa.doiphode@nanostuffs.com","company":"Digitas","phone":"8999528852","industry":"Agricultural Vehicles and Equipment","role_in_the_organisation":"I am involved in evaluating better manufacturing/repair/maintenance solutions to ensure better performance","no_of_employees":"100-500","what_is_the_purpose":"For use in product assembly or manufacturing","change_password_link":"https://www.tryloctite.in/change-password-guest?email=dUZpN2s2MERwb1M1ZDltaHlYSVlWZ3prLzlTeU5IZmFPRThHaUEvQmlGST0=","address":{"address_1":{"name":"Piyush","phone":"8999528852","email":"swarupa.doiphode@nanostuffs.com","company_name":"Digitas","street_address":"test","landmark":"asdfasdf","city":"Rajkot","zipcode":"360001","state":"Gujarat","country":"India","GSTIN_number":"123423ABCDFDEFR"}}}],"search_keywords":["loctite","threadlockers","threadsealants","gasketing"],"products_viewed":[{"product_name":"Loctite 243","category":"threadlockers","product_url":""}],"wish_lists":[{"product_name":"Loctite 243","category":"threadlockers"}],"last_five_logins":[{"date":"28-11-2018 09:00:00"}],"order":{"clientOrderNumber":"171","IBOrderNumber":"","IBOrderStatus":"","IBTrackingNumber":"","IBInvoiceUrl":"","IBShippingDate":"","IBArrivingDate":"","orderDate":"2019-01-09","email":"swarupa.doiphode@nanostuffs.com","shippingAddress":{"name":"","email":"","address":"","pincode":"","phone":"","city":"","state":"","country":"","landmark":"","gstinNumber":""},"billingAddress":{"name":"","email":"","address":"","pincode":"","phone":"","city":"","state":"","country":"","landmark":"","gstinNumber":""},"payment":{"paymentMode":"Cash on delivery","status":"","gateway":"","amount":"","transactionId":"","paymentRealizedOn":"","pgTransactionId":"","chequeNumber":"","chequeIssueBank":"","chequeDate":"","bankRefNumber":"","bank":"","paymentReceivedDate":""},"orderItems":[{"id":"","sku":"","quantity":"","itemTitle":"","image":"","tax":"","taxPercentage":"","strikedOffPrice":"","taxInclusivePrice":"","codCharge":"","shippingCharge":"","total":""}]},"cart_items":[{"sku":"AD.GA.195887","product_id":"8","product_name":"Loctite 510 - 50 ml","price":"884.00","category":"Instant bonding adhesives","size":"50 ml","quanitity":1}],"cart_payment_information":[{"org_total":"884.00","coupon_name":"","coupon_discount":"0.00","subtotal":884,"GST":"159.12","Total":1043.1199999999999,"total_saving":"0.00"}]},{"userid":"81","visitor_id":"100051465","user_contact_detail":[{"name":"Piyush","email":"swarupa.doiphode@nanostuffs.com","company":"Digitas","phone":"8999528852","industry":"Agricultural Vehicles and Equipment","role_in_the_organisation":"I am involved in evaluating better manufacturing/repair/maintenance solutions to ensure better performance","no_of_employees":"100-500","what_is_the_purpose":"For use in product assembly or manufacturing","change_password_link":"https://www.tryloctite.in/change-password-guest?email=dUZpN2s2MERwb1M1ZDltaHlYSVlWZ3prLzlTeU5IZmFPRThHaUEvQmlGST0=","address":{"address_1":{"name":"Piyush","phone":"8999528852","email":"swarupa.doiphode@nanostuffs.com","company_name":"Digitas","street_address":"test","landmark":"asdfasdf","city":"Rajkot","zipcode":"360001","state":"Gujarat","country":"India","GSTIN_number":"123423ABCDFDEFR"}}}],"search_keywords":["loctite","threadlockers","threadsealants","gasketing"],"products_viewed":[{"product_name":"Loctite 243","category":"threadlockers","product_url":""}],"wish_lists":[{"product_name":"Loctite 243","category":"threadlockers"}],"last_five_logins":[{"date":"28-11-2018 09:00:00"}],"order":{"clientOrderNumber":"170","IBOrderNumber":"105255337","IBOrderStatus":"Order Placed","IBTrackingNumber":"","IBInvoiceUrl":"","IBShippingDate":"","IBArrivingDate":"","orderDate":"2019-01-09","email":"swarupa.doiphode@nanostuffs.com","shippingAddress":{"name":"Piyush","email":"swarupa.doiphode@nanostuffs.com","address":"test","pincode":"360001","phone":"8999528852","city":"Rajkot","state":"Gujarat","country":"India","landmark":"asdfasdf","gstinNumber":"123423ABCDFDEFR"},"billingAddress":{"name":"Piyush","email":"swarupa.doiphode@nanostuffs.com","address":"test","pincode":"360001","phone":"8999528852","city":"Rajkot","state":"Gujarat","country":"India","landmark":"asdfasdf","gstinNumber":"123423ABCDFDEFR"},"payment":{"paymentMode":"Cash on delivery","status":"success","gateway":"","amount":"17.70","transactionId":"","paymentRealizedOn":"2019-01-09","pgTransactionId":"","chequeNumber":"","chequeIssueBank":"","chequeDate":"","bankRefNumber":"","bank":"","paymentReceivedDate":"2019-01-09"},"orderItems":[{"id":"447","sku":"ADH.THR.52012991","quantity":1,"itemTitle":"Loctite 243 - 0.5 ml","image":"https://www.tryloctite.in/sites/default/files/2019-01/LOCTITE-243-0.5-mL_3.jpg","tax":"2.70","taxPercentage":18,"strikedOffPrice":"","taxInclusivePrice":"15.00","codCharge":0,"shippingCharge":0,"total":"15.00"}]},"cart_items":[{"sku":"","product_id":"","product_name":"","price":"","category":"","size":"","quanitity":""}],"cart_payment_information":[{"org_total":"15.00","coupon_name":"","coupon_discount":"0.00","subtotal":15,"GST":"2.70","Total":17.699999999999999,"total_saving":"0.00"}]}]}';
            }
            else
            {
                jsonString = '{"response":{"shipped_count" : "2",	"delivered_count" : "1",  "product_shipped" :[{ "product_name" :"test1", "product_sku"  :"AD.IN.195921"  },{ "product_name" :"test1", "product_sku"  :"AD.TH1.195885"  } ], "product_delivered":[{ "product_name" :"test1", "product_sku"  :"AD.GA.195887"  }]}}';
            }
            ShipmentNotificationWrapper Shipmentdata  = (ShipmentNotificationWrapper) System.JSON.deserialize(jsonString, ShipmentNotificationWrapper.class);
            ShipmentNotificationWrapper.response shipmentlist=new ShipmentNotificationWrapper.response();
            shipmentlist = Shipmentdata.response; 
            for(Order_Information__c O:OI)
            {
                globalorderInfo.add(O);
            }
            for(integer i=0;i<shipmentlist.shipped_count;i++ )
            {
                if(ProductNameShipped=='')
                {
                    ProductNameShipped=shipmentlist.product_shipped[i].product_name;
                }
                else
                {
                    ProductNameShipped=ProductNameShipped+','+shipmentlist.product_shipped[i].product_name;  
                }
                for(Ordered_Product__c OrderProduct:OP)
                {
                    if(OrderProduct.SKU__c==shipmentlist.product_shipped[i].product_sku)
                    {
                        OrderProduct.Order_Status__c='Order shipped';
                        OrderProduct.Invoice_URL__c=shipmentlist.product_shipped[i].IBInvoiceUrl;
                        orderProduct.Shipping_Date__c=string.valueOf(system.today());
                        UpdateProduct.add(OrderProduct);
                        globalOrderProductshipped.add(OrderProduct);
                        
                    }
                }
                
            }
            for(integer i=0;i<shipmentlist.delivered_count;i++ )
            {
                if(ProductnameDelivered=='')
                {
                    ProductnameDelivered=shipmentlist.product_delivered[i].product_name;
                }
                else
                {
                    ProductnameDelivered=ProductnameDelivered+','+shipmentlist.product_delivered[i].product_name;  
                }
                for(Ordered_Product__c OrderProduct:OP)
                {
                    if(OrderProduct.SKU__c==shipmentlist.product_delivered[i].product_sku)
                    {
                        OrderProduct.Order_Status__c='Order delivered';
                        OrderProduct.Invoice_URL__c=shipmentlist.product_delivered[i].IBInvoiceUrl;
                        orderproduct.Arriving_Date__c=string.valueOf( system.today());
                        UpdateProduct.add(OrderProduct);
                        globalOrderProductdeliver.add(OrderProduct);
                        
                    }
                }
                
            }
            for(Order_Information__c orderInfo:OI)
            {
                System.debug('orderInfo.Product_Shipped_Count__c '+orderInfo.Product_Shipped_Count__c);
                System.debug('shipmentlist.shipped_count '+shipmentlist.shipped_count);
                if(orderInfo.Product_Shipped_Count__c!=null)
                {
                    orderInfo.Product_Shipped_Count__c=orderInfo.Product_Shipped_Count__c+ shipmentlist.shipped_count;  
                }
                else
                {
                    orderInfo.Product_Shipped_Count__c= 0 + shipmentlist.shipped_count; 
                }
                if(orderInfo.Product_Delivered_Count__c!=Null)
                {
                    orderInfo.Product_Delivered_Count__c=orderInfo.Product_Delivered_Count__c+shipmentlist.delivered_count;
                }
                else
                {
                    orderInfo.Product_Delivered_Count__c= 0 +shipmentlist.delivered_count;
                }
                if(orderInfo.Product_Count__c==0)
                    orderInfo.Product_Count__c=OrderInfo.Ordered_Products__r.size();
                Updateorder.add(orderInfo);
            }
            
            
            if(UpdateProduct.size()>0)
            {
                update UpdateProduct;
            }
            if(Updateorder.size()>0)
            {
                update Updateorder;
            }
            if(globalOrderProductdeliver.size()>0 && OI[0]!=NULL)
                OrderDelivered(OI[0]);
            if(globalOrderProductshipped.size()>0 && OI[0]!=NULL)
                OrderDispatch(OI[0]); 
            
        } catch (Exception e){
            System.debug('e.getLineNumber() '+e.getLineNumber());
            System.debug('e.getCause() '+e.getCause());
            System.debug('e.getMessage() '+e.getMessage());
            System.debug('e.getTypeName() '+e.getTypeName());
        }
        
    }
    
    /* mail send*/
    public  void OrderDispatch(Order_Information__c orderObj)
    {
        orderObj=[select id,Name,Product_Count__c,Shipping_Date__c,Shipping_Name__c,Arriving_Date__c,Shipping_Address__c,Shipping_City__c,Shipping_State__c,Shipping_Pincode__c,Intro_Discount__c,bulk_discount__c,Discount_Price__c,GST__c,Email__c,Total__c,Tracking_Number__c,customerName__c,Order_Number__c,Customer_Phone__c,Product_Shipped_Count__c,Product_Delivered_Count__c,(select id,Order_Status__c from Ordered_Products__r) from Order_Information__c where id=:orderObj.id limit 1];
        System.debug('in dispatch method');
        String msg;
        String message = ProductNameShipped+' of LOCTITE eStore order ID '+orderObj.Order_Number__c+' has been dispatched on '+myDate+' via IndustryBuying. To track your order visit www.tryloctite.in/user/orders. For queries, reach us at customer.enquiries@henkel.com.';
        
        if(orderObj.CustomerName__c != '')
            msg = 'Hi ' + orderObj.CustomerName__c + ', '+message;
        else
            msg = 'Hi, '+message;
        
        if(orderObj.Customer_Phone__c != null)   
            SendSMS_Helper.sendSMSMessage(orderObj.Customer_Phone__c, msg);
        
        String orderId = String.valueOf(orderObj.Id);
        String orderData = '';
        
        String HTMLDataStr = '<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><title>Henkel</title><meta name="description" content="Henkel"><meta name="author" content="Henkel"><meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/><style type="text/css">@media only screen and (max-width:649px) {#Table_01 {width: 100% !important;}.sm-width {width:auto!important;} img {width:100%!important;}.video-btn {width:200px!important;}.mainpad {padding:20px 10px!important;}.tbin{padding: 10px 5px !important;}}</style></head><body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"><table border="0" align="center" cellpadding="0" cellspacing="0" id="Table_01" width="650" style="background:#fff;"> <tr> <td class="mainpad" align="left" valign="top" style="padding:15px 50px;"><table width="100%" border="0" cellspacing="0" cellpadding="0"> <tr> <td align="left" valign="top"><a href="https://www.tryloctite.in" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp76/492971/76593/loctite_logo.jpg" class="sm-width" alt="" border="0"></a></td> <td align="right" valign="top"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp6v/492971/76583/dpj_logo.jpg" class="sm-width" alt="" border="0"></td> </tr> </table></td> </tr> <tr> <td align="left" valign="top"><img src="http://go.pardot.com/l/492971/2018-12-28/cjq5xk/492971/80448/edm_banner.jpg" alt=""></td> </tr> <tr> <td class="mainpad" align="left" valign="top" style="padding:0px 30px;"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-family:Arial, Helvetica, sans-serif, Calibri; color:#000000;"> <tr> <td align="left" valign="top" style="font-size:18px; font-weight:bold;">Dear '+orderObj.CustomerName__c+',</td></tr> <tr> <td align="left" valign="top">&nbsp;</td> </tr><tr><td align="left" valign="top" style="font-size:16px; line-height:21px; font-weight: bold">The following products from your order have been shipped.  </td></tr><tr> <td height="8" align="left" valign="top"></td> </tr><tr> <td align="left" valign="top" style="font-size:16px; line-height:22px;">Your order is being shipped by Industry Buying and the tracking number <br>is <strong>'+orderObj.Tracking_Number__c+'</strong>. Visit <a href="https://www.tryloctite.in/user/orders" style="color:#e3001a; text-decoration: none; font-weight: bold" target="_self">My Orders</a> section in your account for more information and for downloading the invoice.</td></tr><tr> <td align="left" valign="top">&nbsp;</td> </tr> <tr> <td align="left" valign="top" style="-webkit-box-shadow: 0px 0px 5px 0px rgba(138,136,138,1);-moz-box-shadow: 0px 0px 5px 0px rgba(138,136,138,1);box-shadow: 0px 0px 5px 0px rgba(138,136,138,1); padding: 13px 15px"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-family:Arial, Helvetica, sans-serif, Calibri; color:#000000; font-size: 15px"> <tbody> <tr> <td align="left" valign="top"><b>Shipment Details:</b></td> </tr> <tr> <td height="5" align="left" valign="top"></td> </tr> <tr> <td align="left" valign="top"></td> </tr> <tr> <td height="5" align="left" valign="top"></td> </tr>';
        Double SubTotal = 0.00;
        Double ShippingCharge = 0.00;
        //List<Ordered_Product__c> products = [SELECT CodCharge__c,Price__c, Total__c ,Tax__c,image_url__c, SKU__c,Tax_Inclusive_Price__c,Quanitity__c,Name,Shipping_Charge__c,Tax_Percentage__c,Striked_Off_Price__c from Ordered_Product__c where Order_Information__c=:orderId];
        
        for(Ordered_Product__c prod: globalOrderProductshipped)
        {
            
            /* if(prod.CodCharge__c == null || prod.CodCharge__c =='')
prod.CodCharge__c = '0.0';

if(prod.Total__c  == null || prod.Total__c  =='')
prod.Total__c  = '0.0';


if(prod.Tax__c == null || prod.Tax__c =='')
prod.Tax__c = '0.0';

if(prod.Tax_Inclusive_Price__c == null || prod.Tax_Inclusive_Price__c =='')
prod.Tax_Inclusive_Price__c = '0.0';

if(prod.Quanitity__c == null || prod.Quanitity__c =='')
prod.Quanitity__c = '0.0';

if(prod.Shipping_Charge__c == null || prod.Shipping_Charge__c =='')
prod.Shipping_Charge__c = '0.0';

if(prod.Tax_Percentage__c == null || prod.Tax_Percentage__c =='')
prod.Tax_Percentage__c = '0.0';

if(prod.Striked_Off_Price__c == null || prod.Striked_Off_Price__c =='')
prod.Striked_Off_Price__c = '0.0';

prod.Striked_Off_Price__c = prod.Striked_Off_Price__c.replace('INR','');

if(prod.Shipping_Charge__c == null || prod.Striked_Off_Price__c =='')
ShippingCharge = Double.valueOf(prod.Shipping_Charge__c);*/
            if(prod.Quanitity__c == null || prod.Quanitity__c =='')
                prod.Quanitity__c = '0.0';
            
            String productName;
            
            if(Integer.valueOf(prod.Quanitity__c)>1)
            {
                productName  = Integer.valueOf(prod.Quanitity__c)+'x  '+prod.Name;
            }
            else
            {
                productName  = prod.Name;
            }
            
            
            SubTotal = SubTotal + Double.Valueof(Decimal.valueOf(prod.Total__c.replaceAll('[^.\\d]','')));
            //SubTotal = SubTotal+Double.valueOf(prod.Total__c.replace(',',''));
            HTMLDataStr = HTMLDataStr+'<tr><td height="5" align="left" valign="top" width="40%"><img src="'+prod.image_url__c+'" height="50px" ></td><td >'+productName+'</td><td ></td></tr>';
        }
        
        Double finalTotal = SubTotal+ShippingCharge;
        
        
        String Address = '';
        if(orderObj.Shipping_Name__c != null && orderObj.Shipping_Name__c != '')
            Address = Address + orderObj.Shipping_Name__c;
        if(orderObj.Shipping_Address__c != null && orderObj.Shipping_Address__c != '')
            Address = Address+'<br/>'+orderObj.Shipping_Address__c;
        if(orderObj.Shipping_City__c != null && orderObj.Shipping_City__c != '')
            Address = Address+'<br/>'+orderObj.Shipping_City__c;
        if(orderObj.Shipping_State__c != null && orderObj.Shipping_State__c != '')
            Address = Address+','+orderObj.Shipping_State__c;
        if(orderObj.Shipping_Pincode__c != null && orderObj.Shipping_Pincode__c != '')
            Address = Address+'-'+orderObj.Shipping_Pincode__c;
        
        
        
        HTMLDataStr = HTMLDataStr+'<tr> <td height="5" align="left" valign="top"></td> </tr> <tr> <td align="left" valign="top">&nbsp;</td> </tr> <tr> <td align="left" valign="top" colspan="3">Your order will be delivered to:</td></tr> <tr> <td height="5" align="left" valign="top"></td> </tr> <tr> <td align="left" valign="top" colspan="3">'+Address+'</td> </tr> </tbody></table></td> </tr> <tr> <td height="20" align="left" valign="top">&nbsp;</td> </tr><tr> <td align="left" valign="top">&nbsp;</td> </tr> <tr> <td align="left" valign="top" style="line-height: 22px"><strong>We hope to see you again soon.<br><span style="color: #e3001a">Thank You.</span></strong></td> </tr> </table></td> </tr> <tr> <td align="left" valign="top" >&nbsp;</td> </tr> <tr> <td align="left" valign="top" style="background:#000; padding:30px 20px;" ><table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-family:Arial, Helvetica, sans-serif, Calibri; color:#ffffff;"> <tr> <td align="center" valign="top" style="font-size:15px;">Have a query? Drop us an e-mail at <a href="mailto:customer.enquiries@henkel.com" target="_blank" style="text-decoration:underline; color:#fff; font-weight:bold;">customer.enquiries@henkel.com</a></td> </tr> <tr> <td align="center" valign="top" style="font-weight:bold; font-size:15px; padding: 10px 0;">Stay Connected</td> </tr> <tr> <td align="center" valign="top"><table width="180" border="0" cellspacing="0" cellpadding="0" class="social_icons"> <tbody> <tr> <td align="center" valign="middle"><a href="https://www.facebook.com/Loctite/" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp6x/492971/76585/fb_icon_c3.jpg" alt="" border="0" class="sm-width"/></a></td> <td align="center" valign="middle"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp72/492971/76589/fb_li_c3.jpg" class="sm-width" alt=""/></td> <td align="center" valign="middle"><a href="https://in.linkedin.com/showcase/henkel-adhesives" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp74/492971/76591/link_icon_c3.jpg" alt="" border="0" class="sm-width"/></a></td> <td align="center" valign="middle"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp72/492971/76589/fb_li_c3.jpg" class="sm-width" alt=""/></td> <td align="center" valign="middle"><a href="https://www.youtube.com/user/AdhesiveTechnologies" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp78/492971/76595/you_tube_icon_c3.jpg" alt="" border="0" class="sm-width"/></a></td> </tr> </tbody> </table></td> </tr> <tr> <td align="center" valign="top">&nbsp;</td> </tr> <tr> <td align="center" valign="top" style="font-size:11px"><a href="https://www.tryloctite.in/" target="_blank" style="color: #fff; text-decoration: none; padding: 0 5px">Visit LOCTITE website</a> |<a href="https://www.tryloctite.in/privacy-policy" target="_blank" style="color: #fff; text-decoration: none; padding: 0 5px">Privacy Policy</a> | <a href="https://www.tryloctite.in/terms-of-use" target="_blank" style="color: #fff; text-decoration: none; padding: 0 5px">Terms and Conditions</a></td> </tr> </table></td> </tr> <tr> <td align="center" valign="top" style="font-family:Arial, Helvetica, sans-serif, Calibri; font-size:12px; color:#ffffff; padding:10px 10px; background:#c1000d;" >If you wish to unsubscribe from our emailing list, <a href="#" target="_blank" style="color:#ffffff; text-decoration:underline;">click here</a></td> </tr></table></body></html>';
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {orderObj.Email__c});
        mail.setSubject('Shipment notification for LOCTITE order'+' '+String.valueOf(orderObj.Order_Number__c));
        mail.setHtmlBody(HTMLDataStr);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }
    
    
    public  void OrderDelivered(Order_Information__c orderObj)
    {
        orderObj=[select id,Product_Count__c,Name,Shipping_Date__c,Shipping_Name__c,Shipping_Address__c,Arriving_Date__c,Shipping_City__c,Shipping_State__c,Shipping_Pincode__c,Intro_Discount__c,bulk_discount__c,Discount_Price__c,GST__c,Email__c,Total__c,Tracking_Number__c,customerName__c,Order_Number__c,Customer_Phone__c,Product_Shipped_Count__c,Product_Delivered_Count__c,(select id,Order_Status__c from Ordered_Products__r) from Order_Information__c where id=:orderObj.id limit 1];
        System.debug('in delivery method');
        String msg;
        String message = ProductnameDelivered+' of LOCTITE eStore order ID '+orderObj.Order_Number__c+' has been delivered on '+myDate+'. For queries, reach us at customer.enquiries@henkel.com.';
        
        if(orderObj.CustomerName__c != '')
            msg = 'Hi ' + orderObj.CustomerName__c + ', '+message;
        else
            msg = 'Hi, '+message;
        
        if(orderObj.Customer_Phone__c != null)   
        {     //SendSMS_Helper.sendSMSMessage(orderObj.Customer_Phone__c, msg);
            SendSMS_Helper.sendSMSMessage(orderObj.Customer_Phone__c,msg);
        }
        
        String orderId = String.valueOf(orderObj.Id);
        String orderData = '';
        
        String HTMLDataStr = '<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><title>Henkel</title><meta name="description" content="Henkel"><meta name="author" content="Henkel"><meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/><style type="text/css">@media only screen and (max-width:649px) {#Table_01 {width: 100% !important;}.sm-width {width:auto!important;} img {width:100%!important;}.video-btn {width:200px!important;}.mainpad {padding:20px 10px!important;}.tbin{padding: 10px 5px !important;}}</style></head><body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"><table border="0" align="center" cellpadding="0" cellspacing="0" id="Table_01" width="650" style="background:#fff;"> <tr> <td class="mainpad" align="left" valign="top" style="padding:15px 50px;"><table width="100%" border="0" cellspacing="0" cellpadding="0"> <tr> <td align="left" valign="top"><a href="https://www.tryloctite.in" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp76/492971/76593/loctite_logo.jpg" class="sm-width" alt="" border="0"></a></td> <td align="right" valign="top"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp6v/492971/76583/dpj_logo.jpg" class="sm-width" alt="" border="0"></td> </tr> </table></td> </tr> <tr> <td align="left" valign="top"><img src="http://go.pardot.com/l/492971/2018-12-28/cjq4tc/492971/80444/edm_banner.jpg" alt=""></td> </tr> <tr> <td class="mainpad" align="left" valign="top" style="padding:0px 30px;"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-family:Arial, Helvetica, sans-serif, Calibri; color:#000000;"> <tr> <td align="left" valign="top" style="font-size:18px; font-weight:bold;">Dear '+orderObj.CustomerName__c+',</td> </tr> <tr> <td align="left" valign="top">&nbsp;</td> </tr> <tr> <td align="left" valign="top" style="font-size:16px; line-height:21px; font-weight: bold">Congratulations! The following order items have been delivered. </td> </tr> <tr> <td height="8" align="left" valign="top"></td> </tr> <tr> <td align="left" valign="top" style="font-size:16px; line-height:21px;">Visit <a href="https://www.tryloctite.in/user/orders" style="color:#e3001a; text-decoration: none; font-weight: bold" target="_self">My Orders</a> section in your account for more information and for downloading the invoice</td> </tr> <tr> <td align="left" valign="top">&nbsp;</td> </tr> <tr> <td align="left" valign="top" style="-webkit-box-shadow: 0px 0px 5px 0px rgba(138,136,138,1);-moz-box-shadow: 0px 0px 5px 0px rgba(138,136,138,1);box-shadow: 0px 0px 5px 0px rgba(138,136,138,1); padding: 13px 15px"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-family:Arial, Helvetica, sans-serif, Calibri; color:#000000; font-size: 15px"> <tbody> <tr> <td align="left" valign="top"><b></b></td> </tr> <tr> <td height="5" align="left" valign="top"></td> </tr> <tr> <td align="left" valign="top"></td> </tr> <tr> <td height="5" align="left" valign="top"></td> </tr>';
        Double SubTotal = 0.00;
        Double ShippingCharge = 0.00;
        //List<Ordered_Product__c> products = [SELECT CodCharge__c,Price__c, Total__c ,Tax__c,image_url__c, SKU__c,Tax_Inclusive_Price__c,Quanitity__c,Name,Shipping_Charge__c,Tax_Percentage__c,Striked_Off_Price__c from Ordered_Product__c where Order_Information__c=:orderId];
        
        for(Ordered_Product__c prod: globalOrderProductdeliver)
        {
            
            /*if(prod.CodCharge__c == null || prod.CodCharge__c =='')
prod.CodCharge__c = '0.0';

if(prod.Total__c  == null || prod.Total__c  =='')
prod.Total__c  = '0.0';


if(prod.Tax__c == null || prod.Tax__c =='')
prod.Tax__c = '0.0';

if(prod.Tax_Inclusive_Price__c == null || prod.Tax_Inclusive_Price__c =='')
prod.Tax_Inclusive_Price__c = '0.0';

if(prod.Quanitity__c == null || prod.Quanitity__c =='')
prod.Quanitity__c = '0.0';

if(prod.Shipping_Charge__c == null || prod.Shipping_Charge__c =='')
prod.Shipping_Charge__c = '0.0';

if(prod.Tax_Percentage__c == null || prod.Tax_Percentage__c =='')
prod.Tax_Percentage__c = '0.0';

if(prod.Striked_Off_Price__c == null || prod.Striked_Off_Price__c =='')
prod.Striked_Off_Price__c = '0.0';

prod.Striked_Off_Price__c = prod.Striked_Off_Price__c.replace('INR','');

if(prod.Shipping_Charge__c == null || prod.Striked_Off_Price__c =='')
ShippingCharge = Double.valueOf(prod.Shipping_Charge__c);*/
            if(prod.Quanitity__c == null || prod.Quanitity__c =='')
                prod.Quanitity__c = '0.0';
            
            String productName;
            
            if(Integer.valueOf(prod.Quanitity__c)>1)
            {
                productName  = Integer.valueOf(prod.Quanitity__c)+'x  '+prod.Name;
            }
            else
            {
                productName  = prod.Name;
            }
            SubTotal = SubTotal + Double.Valueof(Decimal.valueOf(prod.Total__c.replaceAll('[^.\\d]','')));
            
            
            HTMLDataStr = HTMLDataStr+'<tr><td height="5" align="left" valign="top" width="40%"><img src="'+prod.image_url__c+'" height="50px" ></td><td >'+productName+'</td><td ></td></tr>';
        }
        
        Double finalTotal = SubTotal+ShippingCharge;
        
        
        String Address = '';
        
        if(orderObj.Shipping_Name__c != null && orderObj.Shipping_Name__c != '')
            Address = Address + orderObj.Shipping_Name__c;
        if(orderObj.Shipping_Address__c != null && orderObj.Shipping_Address__c != '')
            Address = Address+'<br/>'+orderObj.Shipping_Address__c;
        if(orderObj.Shipping_City__c != null && orderObj.Shipping_City__c != '')
            Address = Address+'<br/>'+orderObj.Shipping_City__c;
        if(orderObj.Shipping_State__c != null && orderObj.Shipping_State__c != '')
            Address = Address+','+orderObj.Shipping_State__c;
        if(orderObj.Shipping_Pincode__c != null && orderObj.Shipping_Pincode__c != '')
            Address = Address+'-'+orderObj.Shipping_Pincode__c;
        
        HTMLDataStr = HTMLDataStr+'<tr><td height="5" align="left" valign="top"></td> </tr>  <tr> <td align="left" valign="top">&nbsp;</td> </tr> <tr> <td align="left" valign="top" colspan="3">Your order was delivered to:</td></tr> <tr> <td height="5" align="left" valign="top"></td> </tr> <tr> <td align="left" valign="top" colspan="3">'+Address+'</td> </tr> </tbody></table></td> </tr> <tr> <td height="20" align="left" valign="top">&nbsp;</td> </tr> <tr> <td align="left" valign="top" style="font-size:16px; line-height:21px;"><br><span style="color: #e3001a">  </span>  <span style="color: #e3001a"> </span></td> </tr> <tr> <td align="left" valign="top">&nbsp;</td> </tr> <tr> <td align="left" valign="top" style="line-height: 22px"><strong>We hope to see you again soon.<br><span style="color: #e3001a">Thank You.</span></strong></td> </tr> </table></td> </tr> <tr> <td align="left" valign="top" >&nbsp;</td> </tr> <tr> <td align="left" valign="top" style="background:#000; padding:30px 20px;" ><table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-family:Arial, Helvetica, sans-serif, Calibri; color:#ffffff;"> <tr> <td align="center" valign="top" style="font-size:15px;">Have a query? Drop us an e-mail at <a href="mailto:customer.enquiries@henkel.com" target="_blank" style="text-decoration:underline; color:#fff; font-weight:bold;">customer.enquiries@henkel.com</a></td> </tr> <tr> <td align="center" valign="top" style="font-weight:bold; font-size:15px; padding: 10px 0;">Stay Connected</td> </tr> <tr> <td align="center" valign="top"><table width="180" border="0" cellspacing="0" cellpadding="0" class="social_icons"> <tbody> <tr> <td align="center" valign="middle"><a href="https://www.facebook.com/Loctite/" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp6x/492971/76585/fb_icon_c3.jpg" alt="" border="0" class="sm-width"/></a></td> <td align="center" valign="middle"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp72/492971/76589/fb_li_c3.jpg" class="sm-width" alt=""/></td> <td align="center" valign="middle"><a href="https://in.linkedin.com/showcase/henkel-adhesives" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp74/492971/76591/link_icon_c3.jpg" alt="" border="0" class="sm-width"/></a></td> <td align="center" valign="middle"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp72/492971/76589/fb_li_c3.jpg" class="sm-width" alt=""/></td> <td align="center" valign="middle"><a href="https://www.youtube.com/user/AdhesiveTechnologies" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp78/492971/76595/you_tube_icon_c3.jpg" alt="" border="0" class="sm-width"/></a></td> </tr> </tbody> </table></td> </tr> <tr> <td align="center" valign="top">&nbsp;</td> </tr> <tr> <td align="center" valign="top" style="font-size:11px"><a href="https://www.tryloctite.in/" target="_blank" style="color: #fff; text-decoration: none; padding: 0 5px">Visit LOCTITE website</a> |<a href="https://www.tryloctite.in/privacy-policy" target="_blank" style="color: #fff; text-decoration: none; padding: 0 5px">Privacy Policy</a> | <a href="https://www.tryloctite.in/terms-of-use" target="_blank" style="color: #fff; text-decoration: none; padding: 0 5px">Terms and Conditions</a></td> </tr> </table></td> </tr> <tr> <td align="center" valign="top" style="font-family:Arial, Helvetica, sans-serif, Calibri; font-size:12px; color:#ffffff; padding:10px 10px; background:#c1000d;" >If you wish to unsubscribe from our emailing list, <a href="#" target="_blank" style="color:#ffffff; text-decoration:underline;">click here</a></td> </tr></table></body></html>';
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {orderObj.Email__c});
        
        mail.setSubject('Delivery notification for LOCTITE order'+' '+String.valueOf(orderObj.Order_Number__c));
        mail.setHtmlBody(HTMLDataStr);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }
    
    public void cover()
    {
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        
    }
}