@isTest
public class testQuotationNotification 
{
   @isTest
   public static void testquotation()
   {
       EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
       mc.IsQuoteAPIActivated__c=true;
       insert mc;
       
       Contact cnt=new Contact();
       cnt.LastName='testContact';
       cnt.Email='test@test.com';
       insert cnt;
       
       quoteResponse.user_contact_detailWrapper userDetails=new quoteResponse.user_contact_detailWrapper();
       userDetails.name='test';
       userDetails.email='test@test.com';
       userDetails.company='test Company';
       userDetails.phone='';
       userDetails.industry='';
       userDetails.role_in_the_organisation='';
       userDetails.no_of_employees='';
	   userDetails.role_in_the_organisation='';
       List<quoteResponse.product_infoWrapper> productList=new List<quoteResponse.product_infoWrapper>();
       quoteResponse.product_infoWrapper product=new quoteResponse.product_infoWrapper();
       product.sku='ggg';
       //product.quantity=5;
       product.itemTitle='test';
       product.product_Description='test';
       product.total='50.6';
       product.gstpercentage='50';
       product.gst='85';
       product.unitprice='555';
       product.image='aaaa';
       productList.add(product);
       quoteResponse.quotationwrapper quotation=new  quoteResponse.quotationwrapper();
       quotation.product_info=productList;
       	//quotation.Approver_Email;
		quotation.Comments='testComment';
        quotation.Quotation_Number='123456';
        quotation.Product_Names='nananan'; 
      	quotation.Total_Product_Number='5';
        quotation.Coupon_Code='655';
        quotation.Quote_PDF_Link='j\\';
        quotation.Total_MRP='45';
        quotation.Total_Price='555';
        quotation.Discount_Applied='888';
        quotation.GST_Price='555';
        quotation.Total='999';
        quotation.Shipping_Charge='9999';
        quotation.Total_Payable='7777';
       List<quoteResponse> qList=new List<quoteResponse>();
       quoteResponse q=new quoteResponse();
       q.user_contact_detail=userDetails;
       q.quotation=quotation;
       qList.add(q);
       String myjson=JSON.serialize(qList);
       
       RestRequest request = new RestRequest();
       request.requestUri ='https://henkel-tryloctite-in-newdev--newdev.my.salesforce.com/services/apexrest/GetQuote';
       request.httpMethod = 'POST';
	   request.requestBody = Blob.valueof(myJSON);
       request.addHeader('Content-Type', 'application/json');
       RestContext.request = request;
       QuoteNotification.dopost();
}
    @istest
    public static void testquotation2()
   {
       EcomAPI__c mc = EcomAPI__c.getOrgDefaults();
       mc.IsQuoteAPIActivated__c=true;
       insert mc;
       
       lead cnt=new lead();
       cnt.LastName='testContact';
       cnt.Email='test@test.com';
       cnt.Company='test';
       insert cnt;
       
       Contact cn=new Contact();
       cn.FirstName='test';
       cn.LastName='last';
       cn.Company__c='comp';
       insert cn;
       
       quoteResponse.user_contact_detailWrapper userDetails=new quoteResponse.user_contact_detailWrapper();
       userDetails.name='test';
       userDetails.email='test@test.com';
       userDetails.company='test Company';
       userDetails.phone='';
       userDetails.industry='';
       userDetails.role_in_the_organisation='';
       userDetails.no_of_employees='';
	   userDetails.role_in_the_organisation='';
       List<quoteResponse.product_infoWrapper> productList=new List<quoteResponse.product_infoWrapper>();
       quoteResponse.product_infoWrapper product=new quoteResponse.product_infoWrapper();
       product.sku='ggg';
       //product.quantity=5;
       product.itemTitle='test';
       product.product_Description='test';
       product.total='50.6';
       product.gstpercentage='50';
       product.gst='85';
       product.unitprice='555';
       product.image='aaaa';
       productList.add(product);
       quoteResponse.quotationwrapper quotation=new  quoteResponse.quotationwrapper();
       quotation.product_info=productList;
       	//quotation.Approver_Email;
		quotation.Comments='testComment';
        quotation.Quotation_Number='123456';
        quotation.Product_Names='nananan'; 
      	quotation.Total_Product_Number='5';
        quotation.Coupon_Code='655';
        quotation.Quote_PDF_Link='j\\';
        quotation.Total_MRP='45';
        quotation.Total_Price='555';
        quotation.Discount_Applied='888';
        quotation.GST_Price='555';
        quotation.Total='999';
        quotation.Shipping_Charge='9999';
        quotation.Total_Payable='7777';
       List<quoteResponse> qList=new List<quoteResponse>();
       quoteResponse q=new quoteResponse();
       q.user_contact_detail=userDetails;
       q.quotation=quotation;
       qList.add(q);
       String myjson=JSON.serialize(qList);
       
       RestRequest request = new RestRequest();
       request.requestUri ='https://henkel-tryloctite-in-newdev--newdev.my.salesforce.com/services/apexrest/GetQuote';
       request.httpMethod = 'POST';
	   request.requestBody = Blob.valueof(myJSON);
       request.addHeader('Content-Type', 'application/json');
       RestContext.request = request;
       QuoteNotification.dopost();
}
}