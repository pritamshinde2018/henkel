public class EcommerceWrapper{



  public class Cart_payment_information {
        public String org_total;
        public String coupon_name;
        public String coupon_discount;
        public String intro_discount;
        public string bulk_discount;
        public String GST;
        public String Total;
        public String total_saving;
        public String subtotal;
    }

    public class Order {
        public String clientOrderNumber;
        public String orderDate;
        public String email;
        public String IBOrderNumber;
        public String IBOrderStatus;
        public String IBTrackingNumber;
        public String IBInvoiceUrl;
        public String IBShippingDate;
        public String IBArrivingDate;
        public ShippingAddress shippingAddress;
        public BillingAddress billingAddress;
        public Payment payment;
        public List<OrderItems> orderItems;
    }

    public class OrderItems {
        public String id;
        public String image;
        public String sku;
        public String quantity;
        public String itemTitle;
        public String tax;
        public Integer taxPercentage;
        public String strikedOffPrice;
        public String taxInclusivePrice;
        public Integer codCharge;
        public Integer shippingCharge;
        public String coupon_discount;//part shipment
        public String intro_discount;
        public String bulk_discount;
        public String subtotal;
        public String total;
        public String IBOrderStatus; //for partial product shipment
        public String IBTrackingNumber;
        public String IBInvoiceUrl;
        public String IBShippingDate;
        public String IBArrivingDate;
    }

    public List<Response> response;

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
        public List<Cart_payment_information> cart_payment_information;
        public Order order;
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
        public String no_of_employees;
        public String what_is_the_purpose;
        public string user_coupon;
        public string coupon_redeem;
        public String change_password_link;
        public Map<String,Address> address;
        public string Ecom_Source;
        public string Ecom_URL_Params;
        public string Ecom_campaign;
        public string Ecom_content;
        public string Ecom_media;
        public string Ecom_term;
        
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