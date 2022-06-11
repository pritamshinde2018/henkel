public class JSON2Apex {

	public  String CC_Remarks_3;
	public  String CC_Remarks_2;
	public  String CC_Remarks_1;
	public  String Number_of_Employees_Custom;
	public  String Role_in_organisation;
	public  String What_is_the_purpose_use;
	public  String Industry;
	public  String What_the_company_does;
	public  String CC_Current_Method;
	public  String Tell_us_about_your_application_in_one_li;
	public  String id;
    public  string Job_Title;
    public  string Street;
    public  string City;
    public  string State;
    public  string Country;

	
	public static JSON2Apex parse(String json) {
        System.debug('I am in jason to apex pars');
		return (JSON2Apex) System.JSON.deserialize(json, JSON2Apex.class);
	}
}