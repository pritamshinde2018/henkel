public class LinkedinDesignGuideCallout 
{
    @future(callout=true)
    public static void calloutWebservice(string email,string phone,string name,string company,string postalcode,string designation,string department,string industry,string no_of_employees,string design_guide_name)
    {
        String mob = String.valueOf(phone);
         if(mob != null)
         {
           mob = mob.replaceAll('[^0-9]', '');
         }
        
        String designguide ;
        String form_name;  //GM Form Type in Pardot 
        String design_guide_form_type;
        if(design_guide_name == 'urn:li:adForm:4166443')
        {
            designguide = 'gasketingdesignguideform';
            form_name='gasketing';
            design_guide_form_type='leak free flanges';
        }
        else if(design_guide_name == 'urn:li:adForm:4166433')
        {
            designguide = 'retainingdesignguideform';
            form_name='retaining';
            design_guide_form_type='retaining';
        }
        else if(design_guide_name == 'urn:li:adForm:4175373')
        {
            designguide = 'magnetingbondingdesignguideform';
            form_name='magnet-bonding-convention';
            design_guide_form_type='magnet bonding in electric motor';
        }
        else if(design_guide_name == 'urn:li:adForm:4175393')
        {
            designguide = 'magneticbondingclipsdesignguideform';
            form_name='magnet-bonding-competitive';
            design_guide_form_type='magnet bonding in electric motor';
        }
        else if(design_guide_name == 'Guided Content | Retaining | March 2021')
        {
            designguide = 'Retainingdesignguideform';
            form_name='Guided Content | Retaining | March 2021';
            design_guide_form_type='Guided Content | Retaining | March 2021';
            if(designation == null)
            {
                designation = 'NA';
            }
            if(department == null)
            {
                department = 'NA';
            }
        }
        else if(design_guide_name == 'Download Guidance Retaining Component_15Feb2022')
        {
            designguide = 'Retainingdesignguideform';
            form_name='Download Guidance Retaining Component_10Feb2022';
            design_guide_form_type='Download Guidance Retaining Component_15Feb2022';
            if(no_of_employees == null)
            {
                no_of_employees = 'NA';
            }
            if(designation == null)
            {
                designation = 'NA';
            }
            if(department == null)
            {
                department = 'NA';
            }
        }
        else if(design_guide_name == 'MRO_LOC638_Free Sampling_Feb2022')
        {
            return;
        }
        //System.debug('designguide-->'+designguide);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://www.tryloctite.in/estore/sales-force/customformvalidationapi/');
        request.setMethod('POST');
        String str='{"email":"'+email+'","phone":"'+mob+'","full_name":"'+name+'","company_name":"'+company+'","pin_code":"'+postalcode+'","industry_types":"'+industry+'","no_of_employees":"'+no_of_employees+'","design_guide_form_name":"'+designguide+'","designation":"'+designation+'","department":"'+department+'","form_type":"requestdesignguideformsalesforce","form_name":"'+form_name+'","design_guide_form_type":"'+design_guide_form_type+'"}';
        //system.debug('str--------------------- '+str);
        request.setBody(str);
        request.setHeader('content-type','application/json');
        if(!test.isRunningTest())
        {
          HttpResponse response = http.send(request);  
        }

    }

}