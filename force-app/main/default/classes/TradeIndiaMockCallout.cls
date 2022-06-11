@isTest
global class TradeIndiaMockCallout implements HttpCalloutMock 
{
	global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res=new HttpResponse();
        res.setBody('[{"month_slot":"Oct - 2021","sender_name":"Raina","receiver_name":"Mr Varun Sahay","view_status":"UNREAD","generated":"1635142500","source":"CATALOG","product_name":"LOCTITE 518 TTL 50ML Gasket","generated_time":"11:45:00","generated_date":"25 October 2021","product_source":"CATALOG","order_value_min":5000,"sender_country":"India","inquiry_type":"BUY","sender_uid":15915694,"sender_mobile":"+919999038801","address":"b2 kishan vihar, rohini","ago_time":"  6 hrs  41 mins","pref_supp_location":"Local","sender_state":"Delhi","sender":"Client","quantity":"1","rfi_id":"111100001","receiver_mobile":"+919136970094","subject":"LOCTITE 518 TTL 50ML Gasket Inquiry from Raina through tradeindia.com","sender_co":"a2z company","receiver_uid":16106515,"message":"Test","sender_city":"New Delhi","sender_email":"raina@tradeindia.com","receiver_co":"HENKEL ADHESIVES TECHNOLOGIES INDIA PVT LTD"}]');
        return res;
    }
}