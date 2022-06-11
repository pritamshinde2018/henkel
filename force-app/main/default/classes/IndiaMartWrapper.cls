public class IndiaMartWrapper 
{
    public String RN;
	public String QUERY_ID;
	public String QTYPE;
	public String SENDERNAME;
	public String SENDEREMAIL;
	public String SUBJECT;
	public String DATE_RE;
	public String DATE_R;
	public String DATE_TIME_RE;
	public String GLUSR_USR_COMPANYNAME;
	public String READ_STATUS;
	public String SENDER_GLUSR_USR_ID;
	public String MOB;
	public String COUNTRY_FLAG;
	public String QUERY_MODID;
	public String LOG_TIME;
	public String QUERY_MODREFID;
	public String DIR_QUERY_MODREF_TYPE;
	public String ORG_SENDER_GLUSR_ID;
	public String ENQ_MESSAGE;
	public String ENQ_ADDRESS;
	public String ENQ_CALL_DURATION;
	public String ENQ_RECEIVER_MOB;
	public String ENQ_CITY;
	public String ENQ_STATE;
	public String PRODUCT_NAME;
	public String COUNTRY_ISO;
	public String EMAIL_ALT;
	public String MOBILE_ALT;
	public String PHONE;
	public String PHONE_ALT;
	public String IM_MEMBER_SINCE;
	public String TOTAL_COUNT;
    public static IndiaMartWrapper parse(String json) 
    {
        return (IndiaMartWrapper) System.JSON.deserialize(json, IndiaMartWrapper.class);
	}
  
}