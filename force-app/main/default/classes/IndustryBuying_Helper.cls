global class IndustryBuying_Helper {
    

  public static void OrderPlace(Order_Information__c orderObj)
  {
    
    String msg;
     String message = 'LOCTITE eStore order ID '+orderObj.Order_Number__c+'has been confirmed on '+orderObj.orderDate__c+'. To track your order visit www.tryloctite.in/user/orders. For queries, reach us at customer.enquiries@henkel.com.';

      if(orderObj.CustomerName__c != '')
        msg = 'Hi ' + orderObj.CustomerName__c + ', '+message;
      else
        msg = 'Hi, '+message;
        
     if(orderObj.Customer_Phone__c != null)   
       SendSMS_Helper.sendSMSMessage(orderObj.Customer_Phone__c, msg);
       
    String orderId = String.valueOf(orderObj.Id);
    String orderData = '';
    
    String HTMLDataStr = '<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><title>Henkel</title><meta name="description" content="Henkel"><meta name="author" content="Henkel"><meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/><style type="text/css">@media only screen and (max-width:649px) { #Table_01 { width: 100% !important; } .sm-width { width:auto!important; } img { width:100%!important; } .video-btn { width:200px!important; } .mainpad { padding:20px 10px!important; } ` .tbin{padding: 10px 5px !important;}}</style></head><body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"><table border="0" align="center" cellpadding="0" cellspacing="0" id="Table_01" width="650" style="background:#fff;"><tr><td class="mainpad" align="left" valign="top" style="padding:15px 50px;"><table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td align="left" valign="top"><a href="https://www.tryloctite.in" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp76/492971/76593/loctite_logo.jpg" class="sm-width" alt="" border="0"></a></td><td align="right" valign="top"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp6v/492971/76583/dpj_logo.jpg" class="sm-width" alt="" border="0"></td></tr></table></td></tr><tr><td align="left" valign="top"><img src="http://go.pardot.com/l/492971/2018-12-28/cjq4vt/492971/80446/edm_banner.jpg" alt=""></td></tr><tr><td class="mainpad" align="left" valign="top" style="padding:0px 30px;"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-family:Arial, Helvetica, sans-serif, Calibri; color:#000000;"><tr><td align="left" valign="top" style="font-size:18px; font-weight:bold;">Dear '+orderObj.CustomerName__c+',</td></tr><tr><td align="left" valign="top">&nbsp;</td></tr><tr><td align="left" valign="top" style="font-size:16px; line-height:21px; font-weight: bold">Thank You for shopping with us. </td></tr><tr><td height="8" align="left" valign="top"></td></tr><tr><td align="left" valign="top" style="font-size:16px; line-height:21px;">We’ll send a confirmation when your order ships. Visit <a href="https://www.tryloctite.in/user/orders" style="color:#e3001a; text-decoration: none; font-weight: bold" target="_self">My Orders</a> section in your account for more information.</td> </tr><tr><td align="left" valign="top">&nbsp;</td></tr><tr><td align="left" valign="top" style="-webkit-box-shadow: 0px 0px 5px 0px rgba(138,136,138,1);-moz-box-shadow: 0px 0px 5px 0px rgba(138,136,138,1);box-shadow: 0px 0px 5px 0px rgba(138,136,138,1); padding: 13px 15px"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-family:Arial, Helvetica, sans-serif, Calibri; color:#000000; font-size: 15px"><tbody><tr><td align="left" valign="top"><b>Order Summary:</b></td></tr><tr><td height="5" align="left" valign="top"></td></tr><tr><td align="left" valign="top">Order No: <span style="color: #e3001a">'+orderObj.Order_Number__c+'</span></td></tr><tr><td height="5" align="left" valign="top"></td></tr><tr><td align="left" valign="top">Placed on: <span style="color: #e3001a">'+orderObj.orderDate__c+'</span></td></tr><tr><td height="5" align="left" valign="top"></td></tr><tr><td align="left" valign="top"><b> Order Details</b></tr><tr><td height="5" align="left" valign="top"></td></tr>';
    
    Double SubTotal = 0.00;
    Double ShippingCharge = 0.00;
    List<Ordered_Product__c> products = [SELECT CodCharge__c,MRP_Value__c,Price__c, Total__c ,Tax__c,image_url__c, SKU__c,Tax_Inclusive_Price__c,Quanitity__c,Name,Shipping_Charge__c,Tax_Percentage__c,Striked_Off_Price__c from Ordered_Product__c where Order_Information__c=:orderId];
    
    for(Ordered_Product__c prod: products)
    {
        
        if(prod.CodCharge__c == null || prod.CodCharge__c =='')
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
        ShippingCharge = Double.valueOf(prod.Shipping_Charge__c);
        
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
        
        orderData = orderData+'{"codCharge": '+Double.ValueOf(prod.CodCharge__c)+',"total": '+Double.Valueof(Decimal.valueOf(prod.Total__c.replaceAll('[^.\\d]','')))+',"tax": '+Double.ValueOf(prod.Tax__c)+',"sku": "'+prod.SKU__c+'","taxInclusivePrice": '+Double.ValueOf(prod.Tax_Inclusive_Price__c)+',"quantity": '+Double.ValueOf(prod.Quanitity__c)+',"itemTitle": "'+prod.Name+'","shippingCharge": '+Double.ValueOf(prod.Shipping_Charge__c)+',"taxPercentage": '+Double.ValueOf(prod.Tax_Percentage__c)+',"strikedOffPrice" : "'+prod.Striked_Off_Price__c+'"},';
        
        HTMLDataStr = HTMLDataStr+'<tr><td height="5" align="left" valign="top" width="40%"><img src="'+prod.image_url__c+'" height="50px" ></td><td valign="top" width="40%">'+productName+'</td><td height="5" align="left" valign="top">Rs.'+prod.MRP_Value__c +'</td></tr>';
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
      
      
    
    
     HTMLDataStr = HTMLDataStr+'<tr> <td height="5" align="left" valign="top"></td> </tr><br> <tr><td align="left" valign="top"> Intro Discount </td><td></td><td >Rs.'+orderObj.Intro_Discount__c+'</td></tr><tr><td align="left" valign="top"> Bulk Discount </td><td></td><td>Rs.'+orderObj.bulk_discount__c+'</td></tr><tr> <td align="left" valign="top">Coupon Discount </td><td></td><td >Rs.'+orderObj.Discount_Price__c+'</td></tr><tr> <td align="left" valign="top"> Taxes </td><td></td><td >Rs.'+orderObj.GST__c+'</td></tr><tr> <td height="5" align="left" valign="top" colspan="3"><hr></hr></td> </tr> <tr> <td align="left" valign="top"><b>Total paid</b> </td><td></td><td ><span style="color: #e3001a">Rs.'+orderObj.Total__c+'</span></td> </tr><tr> <td height="5" align="left" valign="top"></td> </tr> <tr> <td align="left" valign="top" colspan="3"><b>Arriving on: </b>Your order should arrive in 2-7 business days (More accurate delivery date will be sent to you once the order has been dispatched from the warehouse).</td> </tr> <tr> <td align="left" valign="top">&nbsp;</td> </tr> <tr> <td align="left" valign="top" colspan="3">Your order will be delivered to:</td></tr> <tr> <td height="5" align="left" valign="top"></td> </tr> <tr> <td align="left" valign="top" colspan="3">'+Address+'</td> </tr> </tbody></table></td> </tr> <tr> <td height="20" align="left" valign="top">&nbsp;</td> </tr> <tr> <td align="left" valign="top" style="line-height: 22px"><strong>We hope to see you again soon.<br><span style="color: #e3001a">Thank You.</span></strong></td> </tr> </table></td> </tr> <tr> <td align="left" valign="top" >&nbsp;</td> </tr> <tr> <td align="left" valign="top" style="background:#000; padding:30px 20px;" ><table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-family:Arial, Helvetica, sans-serif, Calibri; color:#ffffff;"> <tr> <td align="center" valign="top" style="font-size:15px;">Have a query? Drop us an e-mail at <a href="mailto:customer.enquiries@henkel.com" target="_blank" style="text-decoration:underline; color:#fff; font-weight:bold;">customer.enquiries@henkel.com</a></td> </tr> <tr> <td align="center" valign="top" style="font-weight:bold; font-size:15px; padding: 10px 0;">Stay Connected</td> </tr> <tr> <td align="center" valign="top"><table width="180" border="0" cellspacing="0" cellpadding="0" class="social_icons"> <tbody> <tr> <td align="center" valign="middle"><a href="https://www.facebook.com/Loctite/" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp6x/492971/76585/fb_icon_c3.jpg" alt="" border="0" class="sm-width"/></a></td> <td align="center" valign="middle"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp72/492971/76589/fb_li_c3.jpg" class="sm-width" alt=""/></td> <td align="center" valign="middle"><a href="https://in.linkedin.com/showcase/henkel-adhesives" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp74/492971/76591/link_icon_c3.jpg" alt="" border="0" class="sm-width"/></a></td> <td align="center" valign="middle"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp72/492971/76589/fb_li_c3.jpg" class="sm-width" alt=""/></td> <td align="center" valign="middle"><a href="https://www.youtube.com/user/AdhesiveTechnologies" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp78/492971/76595/you_tube_icon_c3.jpg" alt="" border="0" class="sm-width"/></a></td> </tr> </tbody> </table></td> </tr> <tr> <td align="center" valign="top">&nbsp;</td> </tr> <tr> <td align="center" valign="top" style="font-size:11px"><a href="https://www.tryloctite.in/" target="_blank" style="color: #fff; text-decoration: none; padding: 0 5px">Visit LOCTITE website</a> |<a href="https://www.tryloctite.in/privacy-policy" target="_blank" style="color: #fff; text-decoration: none; padding: 0 5px">Privacy Policy</a> | <a href="https://www.tryloctite.in/terms-of-use" target="_blank" style="color: #fff; text-decoration: none; padding: 0 5px">Terms and Conditions</a></td> </tr> </table></td> </tr> <tr> <td align="center" valign="top" style="font-family:Arial, Helvetica, sans-serif, Calibri; font-size:12px; color:#ffffff; padding:10px 10px; background:#c1000d;" >If you wish to unsubscribe from our emailing list, <a href="#" target="_blank" style="color:#ffffff; text-decoration:underline;">click here</a></td> </tr></table></body></html>';
    orderData = orderData.removeEnd(',');
    
    String ordersProduct ='"orderItems": ['+orderData+'],';
    String payment = '"payment": {"amount":'+orderObj.Amount__c+',"paymentMode":"'+orderObj.Payment_Mode__c+'","gateway" : "'+orderObj.Gateway__c+'","transactionId" :"'+orderObj.Gateway__c+'","pgTransactionId" : "'+orderObj.PG_Transaction_Id__c+'","paymentReceivedDate" : "'+orderObj.Payment_Received_Date__c+'"},"shippingAddress": {"address":"'+orderObj.Shipping_Address__c+'","phone": "'+orderObj.Shipping_Phone__c+'","email":"'+orderObj.Shipping_Email__c+'","gstinNumber":"'+orderObj.Shipping_GSTInNumber__c+'","state": "'+orderObj.Shipping_State__c+'","country" : "'+orderObj.Shipping_Country__c+'","pincode":"'+orderObj.Shipping_Pincode__c+'","name": "'+orderObj.Shipping_Name__c+'","landmark" :"'+orderObj.Shipping_Landmark__c+'","city":"'+orderObj.Shipping_City__c+'"}}' ;
    
    String reqData = '{"clientOrderNumber": "'+orderObj.Name+'","email": "'+orderObj.Email__c+'","orderDate": "'+orderObj.orderDate__c+'","billingAddress": {"address": "'+orderObj.Billing_Address__c+'","phone": "'+orderObj.Billing_Phone__c+'","email": "'+orderObj.Billing_Email__c+'","gstinNumber": "'+orderObj.Billing_GSTInNumber__c+'","state":"'+orderObj.Billing_State__c+'","country" :"'+orderObj.Billing_Country__c+'","pincode":"'+orderObj.Billing_Pincode__c+'","name":"'+orderObj.Billing_Name__c+'","landmark" :"'+orderObj.Billing_Landmark__c+'","city": "'+orderObj.Billing_City__c+'"},'+ordersProduct+payment;
    
    System.debug('tryyrryyy'+reqData);
      if(products.size()>0)
      {
          CallAPI(reqData,String.valueOf(orderObj.Id),HTMLDataStr,String.valueOf(orderObj.Email__c),String.valueOf(orderObj.Order_Number__c));
      }
    
 }


    
 public static void OrderDelivered(Order_Information__c orderObj)
 {
    
    String msg;
    String message = 'LOCTITE eStore order ID '+orderObj.Order_Number__c+ ' has been delivered on '+orderObj.Arriving_Date__c+'. For queries, reach us on 1800-233-3562.';

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
    
    String HTMLDataStr = '<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><title>Henkel</title><meta name="description" content="Henkel"><meta name="author" content="Henkel"><meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/><style type="text/css">@media only screen and (max-width:649px) {#Table_01 {width: 100% !important;}.sm-width {width:auto!important;} img {width:100%!important;}.video-btn {width:200px!important;}.mainpad {padding:20px 10px!important;}.tbin{padding: 10px 5px !important;}}</style></head><body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"><table border="0" align="center" cellpadding="0" cellspacing="0" id="Table_01" width="650" style="background:#fff;"> <tr> <td class="mainpad" align="left" valign="top" style="padding:15px 50px;"><table width="100%" border="0" cellspacing="0" cellpadding="0"> <tr> <td align="left" valign="top"><a href="https://www.tryloctite.in" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp76/492971/76593/loctite_logo.jpg" class="sm-width" alt="" border="0"></a></td> <td align="right" valign="top"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp6v/492971/76583/dpj_logo.jpg" class="sm-width" alt="" border="0"></td> </tr> </table></td> </tr> <tr> <td align="left" valign="top"><img src="http://go.pardot.com/l/492971/2018-12-28/cjq4tc/492971/80444/edm_banner.jpg" alt=""></td> </tr> <tr> <td class="mainpad" align="left" valign="top" style="padding:0px 30px;"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-family:Arial, Helvetica, sans-serif, Calibri; color:#000000;"> <tr> <td align="left" valign="top" style="font-size:18px; font-weight:bold;">Dear '+orderObj.CustomerName__c+',</td> </tr> <tr> <td align="left" valign="top">&nbsp;</td> </tr> <tr> <td align="left" valign="top" style="font-size:16px; line-height:21px; font-weight: bold">Congratulations! Your <span style="color: #e3001a">LOCTITE</span> order has been delivered. </td> </tr> <tr> <td height="8" align="left" valign="top"></td> </tr> <tr> <td align="left" valign="top" style="font-size:16px; line-height:21px;">Thank You for shopping with us.</td> </tr> <tr> <td align="left" valign="top">&nbsp;</td> </tr> <tr> <td align="left" valign="top" style="-webkit-box-shadow: 0px 0px 5px 0px rgba(138,136,138,1);-moz-box-shadow: 0px 0px 5px 0px rgba(138,136,138,1);box-shadow: 0px 0px 5px 0px rgba(138,136,138,1); padding: 13px 15px"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-family:Arial, Helvetica, sans-serif, Calibri; color:#000000; font-size: 15px"> <tbody> <tr> <td align="left" valign="top"><b>Your Order Summary:</b></td> </tr> <tr> <td height="5" align="left" valign="top"></td> </tr> <tr> <td align="left" valign="top"></td> </tr> <tr> <td height="5" align="left" valign="top"></td> </tr>';
    Double SubTotal = 0.00;
    Double ShippingCharge = 0.00;
    List<Ordered_Product__c> products = [SELECT CodCharge__c,Price__c, Total__c ,Tax__c,image_url__c, SKU__c,Tax_Inclusive_Price__c,Quanitity__c,Name,Shipping_Charge__c,Tax_Percentage__c,Striked_Off_Price__c from Ordered_Product__c where Order_Information__c=:orderId];
    
    for(Ordered_Product__c prod: products)
    {
        
        if(prod.CodCharge__c == null || prod.CodCharge__c =='')
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
        ShippingCharge = Double.valueOf(prod.Shipping_Charge__c);
        
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
        
        
        HTMLDataStr = HTMLDataStr+'<tr><td height="5" align="left" valign="top" width="40%"><img src="'+prod.image_url__c+'" height="50px" ></td><td >'+productName+'</td><td >Rs '+prod.Total__c +'</td></tr>';
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
    
    HTMLDataStr = HTMLDataStr+'<tr> <td height="5" align="left" valign="top"></td> </tr><br> <tr><td align="left" valign="top"> Intro Discount </td><td></td><td >Rs '+orderObj.Intro_Discount__c+'</td></tr><tr><td align="left" valign="top"> Bulk Discount </td><td></td><td >Rs '+orderObj.bulk_discount__c+'</td></tr><tr> <td align="left" valign="top">Coupon Discount </td><td></td><td >Rs '+orderObj.Discount_Price__c+'</td></tr><tr> <td align="left" valign="top"> Taxes </td><td></td><td >Rs '+orderObj.GST__c+'</td></tr><tr> <td height="5" align="left" valign="top" colspan="3"><hr></hr></td> </tr> <tr> <td align="left" valign="top"><b>Total paid</b> </td><td></td><td ><span style="color: #e3001a">Rs '+orderObj.Total__c+'</span></td> </tr><tr> <td height="5" align="left" valign="top"></td> </tr>  <tr> <td align="left" valign="top">&nbsp;</td> </tr> <tr> <td align="left" valign="top" colspan="3">Your order was delivered to:</td></tr> <tr> <td height="5" align="left" valign="top"></td> </tr> <tr> <td align="left" valign="top" colspan="3">'+Address+'</td> </tr> </tbody></table></td> </tr> <tr> <td height="20" align="left" valign="top">&nbsp;</td> </tr> <tr> <td align="left" valign="top" style="font-size:16px; line-height:21px;"><br><span style="color: #e3001a">  </span>  <span style="color: #e3001a"> </span></td> </tr> <tr> <td align="left" valign="top">&nbsp;</td> </tr> <tr> <td align="left" valign="top" style="line-height: 22px"><strong>We hope to see you again soon.<br><span style="color: #e3001a">Thank You.</span></strong></td> </tr> </table></td> </tr> <tr> <td align="left" valign="top" >&nbsp;</td> </tr> <tr> <td align="left" valign="top" style="background:#000; padding:30px 20px;" ><table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-family:Arial, Helvetica, sans-serif, Calibri; color:#ffffff;"> <tr> <td align="center" valign="top" style="font-size:15px;">Have a query? Drop us an e-mail at <a href="mailto:marketing.ag@henkel.com" target="_blank" style="text-decoration:underline; color:#fff; font-weight:bold;">marketing.ag@henkel.com</a></td> </tr> <tr> <td align="center" valign="top" style="font-weight:bold; font-size:15px; padding: 10px 0;">Stay Connected</td> </tr> <tr> <td align="center" valign="top"><table width="180" border="0" cellspacing="0" cellpadding="0" class="social_icons"> <tbody> <tr> <td align="center" valign="middle"><a href="https://www.facebook.com/Loctite/" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp6x/492971/76585/fb_icon_c3.jpg" alt="" border="0" class="sm-width"/></a></td> <td align="center" valign="middle"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp72/492971/76589/fb_li_c3.jpg" class="sm-width" alt=""/></td> <td align="center" valign="middle"><a href="https://in.linkedin.com/showcase/henkel-adhesives" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp74/492971/76591/link_icon_c3.jpg" alt="" border="0" class="sm-width"/></a></td> <td align="center" valign="middle"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp72/492971/76589/fb_li_c3.jpg" class="sm-width" alt=""/></td> <td align="center" valign="middle"><a href="https://www.youtube.com/user/AdhesiveTechnologies" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp78/492971/76595/you_tube_icon_c3.jpg" alt="" border="0" class="sm-width"/></a></td> </tr> </tbody> </table></td> </tr> <tr> <td align="center" valign="top">&nbsp;</td> </tr> <tr> <td align="center" valign="top" style="font-size:11px"><a href="https://www.tryloctite.in/" target="_blank" style="color: #fff; text-decoration: none; padding: 0 5px">Visit LOCTITE website</a> |<a href="https://www.tryloctite.in/privacy-policy" target="_blank" style="color: #fff; text-decoration: none; padding: 0 5px">Privacy Policy</a> | <a href="https://www.tryloctite.in/terms-of-use" target="_blank" style="color: #fff; text-decoration: none; padding: 0 5px">Terms and Conditions</a></td> </tr> </table></td> </tr> <tr> <td align="center" valign="top" style="font-family:Arial, Helvetica, sans-serif, Calibri; font-size:12px; color:#ffffff; padding:10px 10px; background:#c1000d;" >If you wish to unsubscribe from our emailing list, <a href="#" target="_blank" style="color:#ffffff; text-decoration:underline;">click here</a></td> </tr></table></body></html>';
    
    
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setToAddresses(new String[] {orderObj.Email__c});
    
    mail.setSubject('Your Loctite Order '+String.valueOf(orderObj.Order_Number__c)+' has been delivered');
    mail.setHtmlBody(HTMLDataStr);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
 }


    
   public static void OrderDispatch(Order_Information__c orderObj)
   {
   
   String msg;
   String message = 'LOCTITE eStore order ID '+orderObj.Order_Number__c+' has been dispatched on '+orderObj.Shipping_Date__c+' via IndustryBuying. To track your order visit www.tryloctite.in/user/orders. For queries, reach us on 1800-233-3562.';

      if(orderObj.CustomerName__c != '')
        msg = 'Hi ' + orderObj.CustomerName__c + ', '+message;
      else
        msg = 'Hi, '+message;
        
     if(orderObj.Customer_Phone__c != null)   
       SendSMS_Helper.sendSMSMessage(orderObj.Customer_Phone__c, msg);
    
    String orderId = String.valueOf(orderObj.Id);
    String orderData = '';
    
    String HTMLDataStr = '<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><title>Henkel</title><meta name="description" content="Henkel"><meta name="author" content="Henkel"><meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/><style type="text/css">@media only screen and (max-width:649px) {#Table_01 {width: 100% !important;}.sm-width {width:auto!important;} img {width:100%!important;}.video-btn {width:200px!important;}.mainpad {padding:20px 10px!important;}.tbin{padding: 10px 5px !important;}}</style></head><body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"><table border="0" align="center" cellpadding="0" cellspacing="0" id="Table_01" width="650" style="background:#fff;"> <tr> <td class="mainpad" align="left" valign="top" style="padding:15px 50px;"><table width="100%" border="0" cellspacing="0" cellpadding="0"> <tr> <td align="left" valign="top"><a href="https://www.tryloctite.in" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp76/492971/76593/loctite_logo.jpg" class="sm-width" alt="" border="0"></a></td> <td align="right" valign="top"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp6v/492971/76583/dpj_logo.jpg" class="sm-width" alt="" border="0"></td> </tr> </table></td> </tr> <tr> <td align="left" valign="top"><img src="http://go.pardot.com/l/492971/2018-12-28/cjq5xk/492971/80448/edm_banner.jpg" alt=""></td> </tr> <tr> <td class="mainpad" align="left" valign="top" style="padding:0px 30px;"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-family:Arial, Helvetica, sans-serif, Calibri; color:#000000;"> <tr> <td align="left" valign="top" style="font-size:18px; font-weight:bold;">Dear '+orderObj.CustomerName__c+',</td></tr> <tr> <td align="left" valign="top">&nbsp;</td> </tr><tr><td align="left" valign="top" style="font-size:16px; line-height:21px; font-weight: bold">We have dispatched your order. Your order is on the way.  </td></tr><tr> <td height="8" align="left" valign="top"></td> </tr><tr> <td align="left" valign="top" style="font-size:16px; line-height:22px;">Your order is being shipped by Industry Buying and the tracking number <br>is <strong>'+orderObj.Tracking_Number__c+'</strong>. Visit <a href="https://www.tryloctite.in/user/orders" style="color:#e3001a; text-decoration: none; font-weight: bold" target="_self">My Orders</a> section in your account for more information.</td></tr><tr> <td align="left" valign="top">&nbsp;</td> </tr> <tr> <td align="left" valign="top" style="-webkit-box-shadow: 0px 0px 5px 0px rgba(138,136,138,1);-moz-box-shadow: 0px 0px 5px 0px rgba(138,136,138,1);box-shadow: 0px 0px 5px 0px rgba(138,136,138,1); padding: 13px 15px"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-family:Arial, Helvetica, sans-serif, Calibri; color:#000000; font-size: 15px"> <tbody> <tr> <td align="left" valign="top"><b>Shipment Details:</b></td> </tr> <tr> <td height="5" align="left" valign="top"></td> </tr> <tr> <td align="left" valign="top"></td> </tr> <tr> <td height="5" align="left" valign="top"></td> </tr>';
    Double SubTotal = 0.00;
    Double ShippingCharge = 0.00;
    List<Ordered_Product__c> products = [SELECT CodCharge__c,Price__c, Total__c ,Tax__c,image_url__c, SKU__c,Tax_Inclusive_Price__c,Quanitity__c,Name,Shipping_Charge__c,Tax_Percentage__c,Striked_Off_Price__c from Ordered_Product__c where Order_Information__c=:orderId];
    
    for(Ordered_Product__c prod: products)
    {
        
        if(prod.CodCharge__c == null || prod.CodCharge__c =='')
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
        ShippingCharge = Double.valueOf(prod.Shipping_Charge__c);
        
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
        
        
        HTMLDataStr = HTMLDataStr+'<tr><td height="5" align="left" valign="top" width="40%"><img src="'+prod.image_url__c+'" height="50px" ></td><td >'+productName+'</td><td >Rs '+prod.Total__c +'</td></tr>';
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
    
     
    
  HTMLDataStr = HTMLDataStr+'<tr> <td height="5" align="left" valign="top"></td> </tr><br> <tr><td align="left" valign="top"> Intro Discount </td><td></td><td >Rs '+orderObj.Intro_Discount__c+'</td></tr><tr><td align="left" valign="top"> Bulk Discount </td><td></td><td >Rs '+orderObj.bulk_discount__c+'</td></tr><tr> <td align="left" valign="top">Coupon Discount </td><td></td><td >Rs '+orderObj.Discount_Price__c+'</td></tr><tr> <td align="left" valign="top"> Taxes </td><td></td><td >Rs '+orderObj.GST__c+'</td></tr><tr> <td height="5" align="left" valign="top" colspan="3"><hr></hr></td> </tr> <tr> <td align="left" valign="top"><b>Total paid</b> </td><td></td><td ><span style="color: #e3001a">Rs '+orderObj.Total__c+'</span></td> </tr><tr> <td height="5" align="left" valign="top"></td> </tr> <tr> <td align="left" valign="top">&nbsp;</td> </tr> <tr> <td align="left" valign="top" colspan="3">Your order will be delivered to:</td></tr> <tr> <td height="5" align="left" valign="top"></td> </tr> <tr> <td align="left" valign="top" colspan="3">'+Address+'</td> </tr> </tbody></table></td> </tr> <tr> <td height="20" align="left" valign="top">&nbsp;</td> </tr><tr> <td align="left" valign="top">&nbsp;</td> </tr> <tr> <td align="left" valign="top" style="line-height: 22px"><strong>We hope to see you again soon.<br><span style="color: #e3001a">Thank You.</span></strong></td> </tr> </table></td> </tr> <tr> <td align="left" valign="top" >&nbsp;</td> </tr> <tr> <td align="left" valign="top" style="background:#000; padding:30px 20px;" ><table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-family:Arial, Helvetica, sans-serif, Calibri; color:#ffffff;"> <tr> <td align="center" valign="top" style="font-size:15px;">Have a query? Drop us an e-mail at <a href="mailto:marketing.ag@henkel.com" target="_blank" style="text-decoration:underline; color:#fff; font-weight:bold;">marketing.ag@henkel.com</a></td> </tr> <tr> <td align="center" valign="top" style="font-weight:bold; font-size:15px; padding: 10px 0;">Stay Connected</td> </tr> <tr> <td align="center" valign="top"><table width="180" border="0" cellspacing="0" cellpadding="0" class="social_icons"> <tbody> <tr> <td align="center" valign="middle"><a href="https://www.facebook.com/Loctite/" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp6x/492971/76585/fb_icon_c3.jpg" alt="" border="0" class="sm-width"/></a></td> <td align="center" valign="middle"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp72/492971/76589/fb_li_c3.jpg" class="sm-width" alt=""/></td> <td align="center" valign="middle"><a href="https://in.linkedin.com/showcase/henkel-adhesives" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp74/492971/76591/link_icon_c3.jpg" alt="" border="0" class="sm-width"/></a></td> <td align="center" valign="middle"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp72/492971/76589/fb_li_c3.jpg" class="sm-width" alt=""/></td> <td align="center" valign="middle"><a href="https://www.youtube.com/user/AdhesiveTechnologies" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp78/492971/76595/you_tube_icon_c3.jpg" alt="" border="0" class="sm-width"/></a></td> </tr> </tbody> </table></td> </tr> <tr> <td align="center" valign="top">&nbsp;</td> </tr> <tr> <td align="center" valign="top" style="font-size:11px"><a href="https://www.tryloctite.in/" target="_blank" style="color: #fff; text-decoration: none; padding: 0 5px">Visit LOCTITE website</a> |<a href="https://www.tryloctite.in/privacy-policy" target="_blank" style="color: #fff; text-decoration: none; padding: 0 5px">Privacy Policy</a> | <a href="https://www.tryloctite.in/terms-of-use" target="_blank" style="color: #fff; text-decoration: none; padding: 0 5px">Terms and Conditions</a></td> </tr> </table></td> </tr> <tr> <td align="center" valign="top" style="font-family:Arial, Helvetica, sans-serif, Calibri; font-size:12px; color:#ffffff; padding:10px 10px; background:#c1000d;" >If you wish to unsubscribe from our emailing list, <a href="#" target="_blank" style="color:#ffffff; text-decoration:underline;">click here</a></td> </tr></table></body></html>';
    
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setToAddresses(new String[] {orderObj.Email__c});
    mail.setSubject('Your Loctite  Order '+String.valueOf(orderObj.Order_Number__c)+' has been shipped');
    mail.setHtmlBody(HTMLDataStr);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    
 }

    
    
  public static void OrderOutForDelivery(Order_Information__c orderObj)
  {
    String msg;
    String message = 'LOCTITE eStore order ID '+orderObj.Order_Number__c+' is out for delivery on '+orderObj.Arriving_Date__c+'. To track your order visit www.tryloctite.in/user/orders. For queries, reach us on 1800-233-3562.';

      if(orderObj.CustomerName__c != '')
        msg = 'Hi ' + orderObj.CustomerName__c + ', '+message;
      else
        msg = 'Hi, '+message;
        
     if(orderObj.Customer_Phone__c != null)   
       SendSMS_Helper.sendSMSMessage(orderObj.Customer_Phone__c, msg);
    
    String orderId = String.valueOf(orderObj.Id);
    String orderData = '';
    
    String HTMLDataStr = '<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><title>Henkel</title><meta name="description" content="Henkel"><meta name="author" content="Henkel"><meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/><style type="text/css">@media only screen and (max-width:649px) {#Table_01 {width: 100% !important;}.sm-width {width:auto!important;} img {width:100%!important;}.video-btn {width:200px!important;}.mainpad {padding:20px 10px!important;}.tbin{padding: 10px 5px !important;}}</style></head><body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"><table border="0" align="center" cellpadding="0" cellspacing="0" id="Table_01" width="650" style="background:#fff;"> <tr> <td class="mainpad" align="left" valign="top" style="padding:15px 50px;"><table width="100%" border="0" cellspacing="0" cellpadding="0"> <tr> <td align="left" valign="top"><a href="https://www.tryloctite.in" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp76/492971/76593/loctite_logo.jpg" class="sm-width" alt="" border="0"></a></td> <td align="right" valign="top"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp6v/492971/76583/dpj_logo.jpg" class="sm-width" alt="" border="0"></td> </tr> </table></td> </tr> <tr> <td align="left" valign="top"><img src="http://go.pardot.com/l/492971/2018-12-27/cjk3wf/492971/80356/edm_banner.jpg" alt=""></td> </tr> <tr> <td class="mainpad" align="left" valign="top" style="padding:0px 30px;"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-family:Arial, Helvetica, sans-serif, Calibri; color:#000000;"> <tr> <td align="left" valign="top" style="font-size:18px; font-weight:bold;">Dear '+orderObj.CustomerName__c+',</td></tr> <tr> <td align="left" valign="top">&nbsp;</td> </tr><tr><td align="left" valign="top" style="font-size:16px; line-height:21px; font-weight: bold">Your order no.'+orderObj.Order_Number__c+' is out for delivery.  </td></tr><tr> <td height="8" align="left" valign="top"></td> </tr><tr> <td align="left" valign="top" style="font-size:16px; line-height:22px;"> Your order is being shipped by Industry Buying and the tracking number is <br> <strong>'+orderObj.Tracking_Number__c+'</strong>. You can visit   <a href="https://www.tryloctite.in/user/orders" style="color:#e3001a; text-decoration: none; font-weight: bold" target="_self">My Orders</a> section in your account for more information.</td></tr><tr> <td align="left" valign="top">&nbsp;</td> </tr> <tr> <td align="left" valign="top" style="-webkit-box-shadow: 0px 0px 5px 0px rgba(138,136,138,1);-moz-box-shadow: 0px 0px 5px 0px rgba(138,136,138,1);box-shadow: 0px 0px 5px 0px rgba(138,136,138,1); padding: 13px 15px"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-family:Arial, Helvetica, sans-serif, Calibri; color:#000000; font-size: 15px"> <tbody> <tr> <td align="left" valign="top"><b>Shipment Details:</b></td> </tr> <tr> <td height="5" align="left" valign="top"></td> </tr> <tr> <td align="left" valign="top"></td> </tr> <tr> <td height="5" align="left" valign="top"></td> </tr>';
    Double SubTotal = 0.00;
    Double ShippingCharge = 0.00;
    List<Ordered_Product__c> products = [SELECT CodCharge__c,Price__c, Total__c ,Tax__c,image_url__c, SKU__c,Tax_Inclusive_Price__c,Quanitity__c,Name,Shipping_Charge__c,Tax_Percentage__c,Striked_Off_Price__c from Ordered_Product__c where Order_Information__c=:orderId];
    
    for(Ordered_Product__c prod: products)
    {
        
        if(prod.CodCharge__c == null || prod.CodCharge__c =='')
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
        ShippingCharge = Double.valueOf(prod.Shipping_Charge__c);
        
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
        
        
        HTMLDataStr = HTMLDataStr+'<tr><td height="5" align="left" valign="top" width="40%"><img src="'+prod.image_url__c+'" height="50px" ></td><td >'+productName+'</td><td >Rs '+prod.Total__c +'</td></tr>';
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
    
    /*if(orderObj.Shipping_Name__c != null && orderObj.Shipping_Name__c != '')
    Address = Address + orderObj.Shipping_Name__c;
    
    if(orderObj.Shipping_Address__c != null && orderObj.Shipping_Address__c != '')
    {
        if(Address != null && Address != '')
        Address = Address +', ' +orderObj.Shipping_Address__c;
        else
        Address = Address + orderObj.Shipping_Address__c;
    }
    
    if(orderObj.Shipping_City__c != null && orderObj.Shipping_City__c != '')
    {
        if(Address != null && Address != '')
        Address = Address +', ' +orderObj.Shipping_City__c;
        else
        Address = Address + orderObj.Shipping_City__c;
    }*/
    
    
  HTMLDataStr = HTMLDataStr+'<tr> <td height="5" align="left" valign="top"></td> </tr><br> <tr><td align="left" valign="top"> Intro Discount </td><td></td><td >Rs '+orderObj.Intro_Discount__c+'</td></tr><tr><td align="left" valign="top"> Bulk Discount </td><td></td><td >Rs '+orderObj.bulk_discount__c+'</td></tr><tr> <td align="left" valign="top">Coupon Discount </td><td></td><td >Rs '+orderObj.Discount_Price__c+'</td></tr><tr> <td align="left" valign="top"> Taxes </td><td></td><td >Rs '+orderObj.GST__c+'</td></tr><tr> <td height="5" align="left" valign="top" colspan="3"><hr></hr></td> </tr> <tr> <td align="left" valign="top"><b>Total paid</b> </td><td></td><td ><span style="color: #e3001a">Rs '+orderObj.Total__c+'</span></td> </tr><tr> <td height="5" align="left" valign="top"></td> </tr>  <tr> <td align="left" valign="top">&nbsp;</td> </tr> <tr> <td align="left" valign="top" colspan="3">Your order will be delivered to:</td></tr> <tr> <td height="5" align="left" valign="top"></td> </tr> <tr> <td align="left" valign="top" colspan="3">'+Address+'</td> </tr> </tbody></table></td> </tr> <tr> <td height="20" align="left" valign="top">&nbsp;</td> </tr><tr> <td align="left" valign="top">&nbsp;</td> </tr> <tr> <td align="left" valign="top" style="line-height: 22px"><strong>We hope to see you again soon.<br><span style="color: #e3001a">Thank You.</span></strong></td> </tr> </table></td> </tr> <tr> <td align="left" valign="top" >&nbsp;</td> </tr> <tr> <td align="left" valign="top" style="background:#000; padding:30px 20px;" ><table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-family:Arial, Helvetica, sans-serif, Calibri; color:#ffffff;"> <tr> <td align="center" valign="top" style="font-size:15px;">Have a query? Drop us an e-mail at <a href="mailto:marketing.ag@henkel.com" target="_blank" style="text-decoration:underline; color:#fff; font-weight:bold;">marketing.ag@henkel.com</a></td> </tr> <tr> <td align="center" valign="top" style="font-weight:bold; font-size:15px; padding: 10px 0;">Stay Connected</td> </tr> <tr> <td align="center" valign="top"><table width="180" border="0" cellspacing="0" cellpadding="0" class="social_icons"> <tbody> <tr> <td align="center" valign="middle"><a href="https://www.facebook.com/Loctite/" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp6x/492971/76585/fb_icon_c3.jpg" alt="" border="0" class="sm-width"/></a></td> <td align="center" valign="middle"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp72/492971/76589/fb_li_c3.jpg" class="sm-width" alt=""/></td> <td align="center" valign="middle"><a href="https://in.linkedin.com/showcase/henkel-adhesives" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp74/492971/76591/link_icon_c3.jpg" alt="" border="0" class="sm-width"/></a></td> <td align="center" valign="middle"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp72/492971/76589/fb_li_c3.jpg" class="sm-width" alt=""/></td> <td align="center" valign="middle"><a href="https://www.youtube.com/user/AdhesiveTechnologies" target="_blank"><img src="http://go.pardot.com/l/492971/2018-12-07/b3rp78/492971/76595/you_tube_icon_c3.jpg" alt="" border="0" class="sm-width"/></a></td> </tr> </tbody> </table></td> </tr> <tr> <td align="center" valign="top">&nbsp;</td> </tr> <tr> <td align="center" valign="top" style="font-size:11px"><a href="https://www.tryloctite.in/" target="_blank" style="color: #fff; text-decoration: none; padding: 0 5px">Visit LOCTITE website</a> |<a href="https://www.tryloctite.in/privacy-policy" target="_blank" style="color: #fff; text-decoration: none; padding: 0 5px">Privacy Policy</a> | <a href="https://www.tryloctite.in/terms-of-use" target="_blank" style="color: #fff; text-decoration: none; padding: 0 5px">Terms and Conditions</a></td> </tr> </table></td> </tr> <tr> <td align="center" valign="top" style="font-family:Arial, Helvetica, sans-serif, Calibri; font-size:12px; color:#ffffff; padding:10px 10px; background:#c1000d;" >If you wish to unsubscribe from our emailing list, <a href="#" target="_blank" style="color:#ffffff; text-decoration:underline;">click here</a></td> </tr></table></body></html>';
    
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setToAddresses(new String[] {orderObj.Email__c});
    mail.setSubject('Your Loctite Order '+String.valueOf(orderObj.Order_Number__c)+' has been dispatched');
    mail.setHtmlBody(HTMLDataStr);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    
 } 
    
 
    @Future(callout=true)
    public static void CallAPI(String requestData,String orderId,String HTMLStr,String EmailId,String OrderNumber)
    {
    
        Order_Information__c orderObj = new Order_Information__c();
         orderObj.Id = OrderId;
         orderObj.Industry_by_API__c = '';
         orderObj.PlaceEmail__c = true;
         try
         {
          update orderObj;  
          
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new String[] {EmailId});
                    mail.setSubject('Your Loctite Order '+OrderNumber+ ' is confirmed');
                    mail.setHtmlBody(HTMLStr);
                    
                   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        catch(Exception e)
        {
            System.debug('--'+e);
        }  
    
   }
    
   public class industrybuyingWrapper
    {
     public string orderNumber;
    }
   global static void testCode()
    {
     Integer i = 0;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
    } 
    
    
    

}