public class EcomIntegrationWrapper{

  public class Cart_payment_information 
  {
        public String org_total;
        public String coupon_name;
        public String coupon_discount;
        public String intro_discount;
        public string bulk_discount;
        public String GST;
        public String Total;
        public String total_saving;
        public String subtotal;
        public string total_price;
    }
  public class Order 
  {
        public String clientOrderNumber;
        public String orderDate;
        public String OrderConfirmationDate;
        public String email;
        public String is_ist_mode;
        public String ist_user_email;
        public string vendor_name;
        public String IBOrderNumber;
        public String IBOrderStatus;
        public String IBTrackingNumber;
        public String IBInvoiceUrl;
        public String IBShippingDate;
        public String IBArrivingDate;
        public String url_params;
        public String utm_source;
        public String utm_medium;
        public String utm_campaign;
        public String utm_term;
        public String utm_content;
        public ShippingAddress shippingAddress;
        public BillingAddress billingAddress;
        public List<Payment> payment;
        public List<OrderItems> orderItems;
    }
	
    public class OrderItems 
    {
        public String id;
        public String image;
        public String sku;
        public string distributor_allocated;
        public String quantity;
        public String itemTitle;
        public String tax;
        public Decimal taxPercentage;
        public String strikedOffPrice;
        public String taxInclusivePrice;
        public string taxExclusivePrice;
        public Decimal codCharge;
        public Decimal shippingCharge;
        public String lt_cash;
        public String coupon_discount;//part shipment
        public String intro_discount;
        public String bulk_discount;
        public String subtotal;
        public String total;
        public String IBOrderStatus; //for partial product shipment
        public String IBTrackingNumber;
        //public String IBInvoiceUrl;
        public List<IBInvoiceUrlWrpper> IBInvoiceUrl;
        public String IBShippingDate;
        public String IBArrivingDate;
        public String sp1;
        public String recommendation_type;
    }

    public List<Response> response;

    public class IBInvoiceUrlWrpper
    {
        public string url;
        public string vendor;
    }
    public class Wish_lists {
        public String product_name;
        public String category;
    }

    public class Last_five_logins {
        public String date1;
    }

    public class BillingAddress {
        public String name;
        public String email;
        public String address;
        public String pincode;
        public String phone;
        public String city;
        public String state;
        public String country;
        public String landmark;
        public String gstinNumber;
    }

    public class Response {
        public String userid;
        public String visitor_id;
        public List<User_contact_detail> user_contact_detail;
        public List<String> search_keywords;
        public List<Products_viewed> products_viewed;
        public List<Wish_lists> wish_lists;
        public List<Last_five_logins> last_five_logins;
        public List<Cart_items> cart_items;
        public Cart_payment_information cart_payment_information;
        public Order order;
        
        public string promo_accept_date1;
        public string promo_accept_time;
        public string privacy_accept_date1;
        public string privacy_accept_time; 
    }

    public class Payment {
        public String paymentMode;
        public String gateway;
        public String amount;
        public String transactionId;
        public String paymentRealizedOn;
        public String pgTransactionId;
        public String chequeNumber;
        public String chequeIssueBank;
        public String chequeDate;
        public String bankRefNumber;
        public String bank;
        public String status;
        public String paymentReceivedDate;
    }

    public class ShippingAddress {
        public String name;
        public String email;
        public String address;
        public String pincode;
        public String phone;
        public String city;
        public String state;
        public String country;
        public String landmark;
        public String gstinNumber;
    }

    public class Cart_items {
        public String product_id;
        public String product_name;
        public String price;
        public String category;
        public String size;
        public String quanitity;
        public String sku;
    }

    public class User_contact_detail {
        public String name;
        public String email;
        public String company;
        public String phone;
        public String industry;
        public String role_in_the_organisation;
        public String GSTIN_number;
        public String no_of_employees;
        public String what_is_the_purpose;
        public string user_coupon;
        public string coupon_redeem;
        public String change_password_link;
        public Map<String,Address> address;
        public string utm_source;
        public string url_params;
        public string utm_campaign;
        public string utm_content;
        public string utm_medium;
        public string utm_term;
    }

    public class Products_viewed {
        public String product_name;
        public String category;
        public String product_url;
    }
 
    public class Address {
        public String name;
        public String phone;
        public String email;
        public String company_name;
        public String street_address;
        public String landmark;
        public String city;
        public String zipcode;
        public String state;
        public String country;
        public String GSTIN_number;
    }
    
}