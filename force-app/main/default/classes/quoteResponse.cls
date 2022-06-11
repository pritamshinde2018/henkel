public class quoteResponse 
{
    public  user_contact_detailWrapper user_contact_detail;
    public  quotationwrapper quotation;
    public String visitor_id;
    public class user_contact_detailWrapper
    {
        public string name;
        public string email;
        public string company;
        public string phone;
        public string industry;
        public string role_in_the_organisation;
        public string no_of_employees;  
        public string pincode;
        public string url_params;
        public string utm_source;
        public string utm_medium;
        public string utm_campaign;
        public string utm_term;
        public string utm_content;
        public string promo_accept_date;
        public string promo_accept_time;
        public string privacy_accept_date;
        public string privacy_accept_time;
        
    }
    public class quotationwrapper
    {
       public List<product_infoWrapper> product_info;
       //public String Lead_Name;
       public String approver_email;
       public String Comments;
       public String Quotation_Number;
       public String Product_Names; 
       //public String Customer_Contact;
       public String Total_Product_Number;
       public String Coupon_Code;
       public String Quote_PDF_Link;
       public String Total_MRP;
       public String Total_Price;
       public String Discount_Applied;
       public String GST_Price;
       public String Total;
       public String Shipping_Charge;
       public String Total_Payable;
    }
    public class product_infoWrapper
    {
       public  string sku;
       public  Decimal quantity;
       public  string itemTitle;
       public  string image;
       public string gst;
       public string gstpercentage;
       public string unitprice;
       public string total;
       public string product_Description;
    }
   
}