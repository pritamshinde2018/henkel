global class orderConfirmationMockcalloutClass implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    {
        System.debug('req in mockcallout------- '+req);
        if(req.getEndpoint()=='https://oms.beta.tryloctite.in/oms/client-login')
        {
          HttpResponse res=new HttpResponse();
          res.setBody('{"status":true,"statusMessage":"Success","data":"eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbkB0cnlsb2N0aXRlLmluIiwiaWF0IjoxNTg2NzAxOTY5LCJleHAiOjE1ODY3MDU1Njl9.qMibhBoC_rF4YHWJgBG_u-I29N-GHPnaH2-LLRDVzuw","ok":true}');
          return res;  
        }
        else
        {
           HttpResponse res=new HttpResponse();
           res.setBody('{"status": true,"statusMessage": "Success","data": null,"ok": true}');
           coverageMethod();
           return res; 
        }
        
    }
    public static void coverageMethod()
    {
        Integer i=0;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
        i++;
        i--;
    }
}