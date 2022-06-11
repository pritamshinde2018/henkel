public class TradeIndiaWrapper 
{
    public String product_source;
    public String sender_name;
    public String sender_country;
    public String sender_uid;
    public String sender_city;
    public String receiver_name;
    public String order_value_min;
    public String receiver_mobile;
    public String address;
    public String sender_email;
    public String inquiry_type;
    public String pref_supp_location;
    public String sender_co;
    public String message;
    public String ago_time;
    public String generated_time;
    public String generated_date; 
    public String sender_state;
    public String subject;
    public String month_slot;
    public String quantity;
    public String rfi_id;
    public String view_status;
    public String source;
    public String receiver_uid;
    public String sender_mobile;
    public String product_name;
    public String generated;
    public String sender;
    
    public static IndiaMartWrapper parse(String json) 
    {
        return (IndiaMartWrapper) System.JSON.deserialize(json, IndiaMartWrapper.class);
	}
}