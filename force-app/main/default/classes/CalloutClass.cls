public class CalloutClass {
    public static HttpResponse getInfoFromExternalService() 
    {
        HttpRequest req = new HttpRequest();
        //req.setEndpoint('http://13.127.110.224/webinar/ondemand-api-threadlockers?email=abcd@gmail.com&mobile=9766924768&source=Linkedin');
        req.setEndpoint('https://www.tryloctite.in/webinar/ondemand-api-threadlockers?email=piyusha122@testing.com&mobile=8111111234&source=Linkedin');
        req.setMethod('POST');
        Http h = new Http();
        HttpResponse res = h.send(req);
        return res;
    }
     public static HttpResponse shipment() {
        HttpRequest req = new HttpRequest();
      // req.setEndpoint('http://13.127.110.224/crons/user-order-api?order_id=2010');
       req.setEndpoint('https://www.tryloctite.in/crons/user-order-api?order_id=2010');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        return res;
    }
}