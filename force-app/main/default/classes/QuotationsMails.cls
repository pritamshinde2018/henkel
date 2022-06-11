public class QuotationsMails 
{
    
    public static void sendQuotationMails(String quoteId)
    {
    
        Quotation__c quote=[Select id,GST_Price__c,Shipping_Charge__c,Total_Payable__c,Approver_Email__c,Discount_Applied__c,Comments__c,(Select id,Product_Discription__c,Unit_Price__c,total__c,Product_Image_URL__c,SKU__c,Quantity__c,GST_Price__c,Name from products__r),Lead_Name__c,Customer_Contact__c
                            from Quotation__c where id=: quoteId];
        String name;
        String Email;
        if(quote.Customer_Contact__c!=null)
        {
            Contact cnt=[Select id,name,Email from contact where id= : quote.Customer_Contact__c];
            name=cnt.name;
            Email=cnt.Email;
        }
        else if(quote.Lead_Name__c!=null)
        {
            Lead ld=[Select id,name,Email from lead where id= :quote.Lead_Name__c];
            name=ld.name;
            Email=ld.Email;
        }
        String str='<!DOCTYPE html> <html> <head> <meta charset="utf-8"> <meta http-equiv="X-UA-Compatible" content="IE=edge"> <title>Quotation Mail - autoreponder</title> </head> <body bgcolor="#f2f2f2" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"> <table align="center" bgcolor="#fff" border="0" cellpadding="0" cellspacing="0" style="margin:0px auto; background:#fff;" width="600"> <tbody> <tr> <td> <table border="0" cellpadding="0" cellspacing="0" width="100%"> <tbody> <tr> <td align="left" class="mainpad" style="padding-left:30px;" valign="top"> <table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;" width="100%"> <tbody> <tr> <td align="left" valign="middle" class=""><a href="https://www.tryloctite.in" target="_blank"><img alt="" border="0" class="sm-width" src="http://go.pardot.com/l/673933/2020-01-10/387w8s/673933/64589/Loctite_Logo_New.jpg"></a></td> <td align="right" valign="top" class=""><a href="https://www.tryloctite.in" style="padding-bottom:10px;padding-right:30px;" target="_blank"><img alt="" border="0" class="sm-width" src="http://go.pardot.com/l/673933/2020-01-10/387w8v/673933/64591/dekho.jpg"></a></td> </tr> </tbody> </table> </td> </tr> <tr> <td align="center" style="padding-top: 10px;" valign="top" class="">';
       	if(quote.Approver_Email__c!=null)
        {
           str=str+'<img alt="" src="https://go.pardot.com/l/492971/2020-04-06/2216618i/492971/141567/Quotation_Mail___autoresponder_second.jpg" width="100%"></td> </tr> <tr> <td align="left" class="mainpad" style="padding:20px 30px;" valign="top"> <table border="0" cellpadding="0" cellspacing="0" width="100%"> <tbody> <tr> <td class=""> <p style="font-family:Arial, Helvetica, sans-serif, Calibri; font-size:14px; color:#000;font-weight:bold; margin:0px; padding: 0px;">Dear';
           str=str+' Customer'+'<?xml version="1.0"?><p style="font-family:Arial, Helvetica, sans-serif, Calibri;  font-size:14px; color:#333; line-height: 20px; margin:0px; padding: 0px;margin-bottom:15px;">A quotation for the following LOCTITE products has been shared by '+Email+' with you.</p>';
           if(quote.Comments__c!=null && quote.Comments__c!='' && quote.Comments__c!=' ')
           {
             str=str+'Comments : '+quote.Comments__c+'<br/>'; 
           }
            
        }
        else
        {
          str=str+'<img alt="" src="http://go.pardot.com/l/673933/2020-01-11/38d8jb/673933/64621/quotation1.jpg" width="100%"></td> </tr> <tr> <td align="left" class="mainpad" style="padding:20px 30px;" valign="top"> <table border="0" cellpadding="0" cellspacing="0" width="100%"> <tbody> <tr> <td class=""> <p style="font-family:Arial, Helvetica, sans-serif, Calibri; font-size:14px; color:#000;font-weight:bold; margin:0px; padding: 0px;">Dear';
      	  str=str+' '+name+'<?xml version="1.0"?><p style="font-family:Arial, Helvetica, sans-serif, Calibri;  font-size:14px; color:#333; line-height: 20px; margin:0px; padding: 0px;margin-bottom:15px;">A quotation for the following products has been generated.</p>';  
        }
        
        str=str+'<table border="0" cellpadding="0" cellspacing="0" style="background:#ffffff; width:100%" width="100%"> <tbody> <tr> <td> <table border="0" cellpadding="0" cellspacing="0" style="background:#eaeaea; width:100%" width="100%"> <tbody> <tr> <td align="left" style="background:#eaeaea; width:100%;text-align:left"> <table border="1" cellpadding="10" cellspacing="1" style="background:#fff; width:100%; font-family:Arial, Helvetica, sans-serif, Calibri; font-size:14px; color:#000; border-collapse:collapse; border-color:#dfdfdf; border: 1px solid #dfdfdf;" width="100%"> <tbody> <tr> <th style="font-size:14px; color: #dd241e;" valign="top" width="10%" class="">S.No</th> <th style="font-size:14px; color: #dd241e;" valign="top" width="40%" class="">Item Details</th> <th style="font-size:14px; color: #dd241e;" valign="top" class="">Quantity</th> <th style="font-size:14px; color: #dd241e;" valign="top" class="">Subtotal</th></tr>';
        //create product table
        String htmlTable='';
        Integer i=0;
        for(Product__c p:quote.products__r)
        {
            i=i+1;
            htmlTable=htmlTable+'<tr> <td valign="top" class="">'+i+'</td> <td valign="top"> <table cellpadding="1" cellspacing="5" width="100%"> <tbody> <tr> <td valign="top" class=""><img src="'+p.Product_Image_URL__c+'" style="border:1px solid #dfdfdf; padding:5px; width:100px ; height:100px "></td> <td style="font-size:14px; color: #333;" valign="top" class="">'+p.Product_Discription__c+'</td> </tr> </tbody> </table> </td> <td style="font-size:14px;" valign="top" class="">'+p.Quantity__c+'</td> <td style="font-size:14px;" valign="top" class="">'+p.Total__c+'</td></tr>';
        }
        String htmltableExtra='<tr><th colspan="3" width="300" valign="top" style="text-align: right;font-size:14px;color: #dd241e; border-right: solid 1px #dfdfdf; border-bottom:solid 1px #dfdfdf;">Discount</th><th valign="top" style="text-align: center;font-size:14px;color:#dd241e;border-bottom:solid 1px #dfdfdf;">'+quote.Discount_Applied__c+'</th></tr>'+'<tr><th colspan="3" valign="top" style="text-align: center;font-size:14px;color: #dd241e;border-right: solid 1px #dfdfdf;border-bottom:solid 1px #dfdfdf;text-align: right; text-transform: uppercase;letter-spacing:-2px;">GST</th><th valign="top" style="text-align: center;font-size:14px;color: #dd241e;border-bottom:solid 1px #dfdfdf;">'+quote.GST_Price__c+'</th></tr>'+'<tr><th colspan="3" valign="top" style="text-align: center;font-size:14px;color: #dd241e;text-align: right;">Shipping Charges</th><th valign="top" width="25%" style="border-left: 1px solid #dfdfdf;font-size:14px; color: #dd241e;text-align: center">'+quote.Shipping_Charge__c+'</th></tr>'+'<tr><th colspan="3" valign="top" style="text-align: center;font-size:14px;color: #dd241e;text-align: right;">Total Payable</th><th valign="top" width="25%" style="border-left: 1px solid #dfdfdf;font-size:14px; color: #dd241e;text-align: center">'+quote.Total_Payable__c+'</th></tr>';
        str=str+htmlTable+htmltableExtra;
        str=str+'</tbody> </table> </td> </tr> </tbody> </table> </td> </tr> <tr> <td height="30" class=""> </td> </tr> <tr> <td align="center" style="font-family:Arial, Helvetica, sans-serif, Calibri; font-size: 16px;" class=""><a href="https://www.tryloctite.in/estore/" style="background:#E1000F; color:#fff; text-decoration:none;text-align:center; padding: 15px 46px; "><b>GET UPTO 33% DISCOUNT NOW</b></a></td> </tr> </tbody> </table> <table> <tbody> <tr> <td> <table style="margin-top:5px;" width="100%"> <tbody> <tr> <td valign="top" width="50%"> <table align="center" style=" padding: 20px;" width="100%"> <tbody> <tr> <td align="center" class=""><img alt="" src="http://go.pardot.com/l/673933/2020-01-10/387w8z/673933/64595/icon1.png" width="50"></td> </tr> <tr> <td height="5" class=""> </td> </tr> <tr> <td style="font-family:Arial, Helvetica, sans-serif, Calibri; font-size:12px; text-align: center; font-weight: bold;" class="">In the meanwhile, you can explore similar LOCTITE solutions</td> </tr>  <tr> <td> <table align="center" width="150"> <tbody> <tr> <td style="font-family:Arial, Helvetica, sans-serif, Calibri; font-size:12px; text-align: center; background-color: #ffffff; display:block; padding: 10px; color: #ffffff;" class=""><a href="https://www.tryloctite.in/" style="color: #E1000F; text-decoration: none; display: block; font-weight: bold; border: solid 1px #E1000F; padding: 7px; text-transform: uppercase;">Click here</a></td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> <td> <table style="border-left: solid 1px #dfdfdf; height: 150px;" width="100%"> <tbody> <tr> <td class=""> </td> </tr> </tbody> </table> </td> <td width="50%"> <table align="center" style="padding: 20px; " width="100%"> <tbody> <tr> <td align="center" class=""><img alt="" src="http://go.pardot.com/l/673933/2020-01-10/387wcb/673933/64609/telephone.png" style="padding-top:9px;" width="45"></td> </tr> <tr> <td height="9" class=""> </td> </tr> <tr> <td style="font-family:Arial, Helvetica, sans-serif, Calibri; font-size:12px; text-align: center; font-weight: bold; padding-top: 0px; margin-top:10px;" class="">Need recommendation on the right solution?</td> </tr>  <tr> <td> <table align="center" width="150"> <tbody> <tr> <td style="font-family:Arial, Helvetica, sans-serif, Calibri; font-size:12px; text-align: center; background-color: #E1000F; display:block; padding: 10px; color: #ffffff;" class=""><a href="https://www.tryloctite.in/contact/feedback/" style="color: #ffffff; text-decoration: none; display: block; font-weight: bold; text-transform: uppercase;">request a callback</a></td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> <p style="font-family:Arial, Helvetica, sans-serif, Calibri; font-size:14px; color:#000;font-weight:bold;">Thank You<br> <span style="color:#E1000F">Team LOCTITE </span></p> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> <tr> <td align="left" style="background:#000; padding:15px 20px;" valign="top"> <table border="0" cellpadding="0" cellspacing="0" style="font-family:Arial, Helvetica, sans-serif, Calibri; color:#ffffff;" width="100%"> <tbody> <tr> <td align="center" style="font-size:15px;" valign="top" class="">Have a query?,<br> Drop us an e-mail at <a href="mailto:customer.enquiries@henkel.com" style="text-decoration:underline; color:#fff; font-weight:bold;" target="_blank">customer.enquiries@henkel.com</a></td> </tr> <tr> <td align="center" height="5" valign="top" class=""> </td> </tr> <tr> <td align="center" valign="top"> <table border="0" cellpadding="0" cellspacing="0" class="social_icons" width="180"> <tbody> <tr> <td align="center" valign="middle" class=""><a href="https://www.facebook.com/Loctite/" target="_blank"><img alt="" border="0" class="sm-width" src="http://go.pardot.com/l/673933/2020-01-10/387w98/673933/64599/fb_icon_c3.jpg"></a></td> <td align="center" valign="middle" class=""><img alt="" class="sm-width" src="http://go.pardot.com/l/673933/2020-01-10/387w9b/673933/64601/fb_li_c3.jpg"></td> <td align="center" valign="middle" class=""><a href="https://in.linkedin.com/showcase/henkel-adhesives" target="_blank"><img alt="" border="0" class="sm-width" src="http://go.pardot.com/l/673933/2020-01-10/387w9l/673933/64603/link_icon_c3.jpg"></a></td> <td align="center" valign="middle" class=""><img alt="" class="sm-width" src="http://go.pardot.com/l/673933/2020-01-10/387w9b/673933/64601/fb_li_c3.jpg"></td> <td align="center" valign="middle" class=""><a href="https://www.youtube.com/user/AdhesiveTechnologies" target="_blank"><img alt="" border="0" class="sm-width" src="http://go.pardot.com/l/673933/2020-01-10/387w9n/673933/64605/you_tube_icon_c3.jpg"></a></td> </tr> </tbody> </table> </td> </tr> <tr> <td align="center" height="5" valign="top" class=""> </td> </tr> <tr> <td align="center" style="font-size:11px" valign="top" class=""><a href="https://www.tryloctite.in/" style="color: #fff; text-decoration: none; padding: 0 5px" target="_blank">Visit LOCTITE website</a> |<a href="https://www.tryloctite.in/privacy-policy" style="color: #fff; text-decoration: none; padding: 0 5px" target="_blank">Privacy Policy</a> | <a href="https://www.tryloctite.in/terms-of-use" style="color: #fff; text-decoration: none; padding: 0 5px" target="_blank">Terms and Conditions</a></td> </tr> </tbody> </table> </td> </tr> <tr> <td align="center" style="font-family:Arial, Helvetica, sans-serif, Calibri; font-size:14px; color:#ffffff; padding:10px 10px; background:#c1000d;" valign="top" class="">If you wish to unsubscribe from our emailing list, <a href="%%unsubscribe%%" style="color:#ffffff; text-decoration:underline;" target="_blank">click here</a></td> </tr> </tbody> </table> </body> </html>';
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        List<Messaging.Email> toEmailList=new List<Messaging.Email>();
        List<Messaging.Email> ccEmailList=new List<Messaging.Email>();
        if(quote.Approver_Email__c!=null)
        {
           Boolean result=quote.Approver_Email__c.contains(',');
           List<String> emailString=new List<String>();
           if(result)
           {
              emailString=quote.Approver_Email__c.Split(',');
           }
           else
           {
              emailString.add(quote.Approver_Email__c); 
           }
           message.toAddresses = emailString;//new String[] {quote.Approver_Email__c };
           message.bccaddresses= new String[] {'Pritam.Shinde@nanostuffs.com',Email};
        }
        else
        {
          message.toAddresses = new String[] { Email };
          message.bccaddresses=new String[]{'Pritam.Shinde@nanostuffs.com'};
        }   
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'customer.enquiries@henkel.com']; 
        //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        if ( owea.size() > 0 ) 
        { 
        	message.setOrgWideEmailAddressId(owea.get(0).Id); 
        }
        message.optOutPolicy = 'FILTER';
        message.subject = 'Your LOCTITE quotation has been generated';
        //message.plainTextBody = 'This is the message body.';
        System.debug('Emailstr html ----'+str);
        message.setHtmlBody(str);
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages); 
    }

}