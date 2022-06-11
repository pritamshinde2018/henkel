public class report_dailyReports
{
    public integer knownvisitors_yest {get;set;}
    public integer knownvisitors_mtd {get;set;}
    public integer knownvisitors_ytd{get;set;}
    
    public integer MQLs_yest {get;set;}
    public integer MQLs_mtd {get;set;}
    public integer MQLs_ytd {get;set;}
    
    public integer NMQLs_yest {get;set;}
    public integer NMQLs_mtd {get;set;}
    public integer NMQLs_ytd {get;set;}
    
    public integer NOCO_yest {get;set;}
    public integer NOCO_mtd {get;set;}
    public integer NOCO_ytd {get;set;}
    
    public integer freshlead_yest {get;set;}
    public integer freshlead_mtd {get;set;}
    public integer freshlead_ytd {get;set;}
    
    public integer callback_yest {get;set;}
    public integer callback_mtd {get;set;}
    public integer callback_ytd {get;set;}
    
    public integer contactus_yest {get;set;}
    public integer contactus_mtd {get;set;}
    public integer contactus_ytd {get;set;}
    
    public integer offer_yest {get;set;}
    public integer offer_mtd {get;set;}
    public integer offer_ytd {get;set;}
    
    public integer threadlocker_ytd {get;set;}
    public integer threadlocker_ytd_mql {get;set;}
    public integer threadsealant_ytd {get;set;}
    public integer threadsealant_ytd_mql {get;set;}
    public integer retainingcompound_ytd {get;set;}
    public integer retainingcompound_ytd_mql {get;set;}
    
    public integer whatpurposeytd1 {get;set;}
    public integer whatpurposeytd2 {get;set;}
    public integer whatpurposeytd3 {get;set;}
    public integer whatpurposeytd4 {get;set;}
    public integer whatpurposeytd5 {get;set;}
    public integer whatpurposeytd_m1 {get;set;}
    public integer whatpurposeytd_m2 {get;set;}
    public integer whatpurposeytd_m3 {get;set;}
    public integer whatpurposeytd_m4 {get;set;}
    public integer whatpurposeytd_m5 {get;set;}
    
    public integer emply1 {get;set;}
    public integer emply2 {get;set;}
    public integer emply3 {get;set;}
    public integer emply4 {get;set;}
    public integer emply5 {get;set;}
    public integer emply_m1 {get;set;}
    public integer emply_m2 {get;set;}
    public integer emply_m3 {get;set;}
    public integer emply_m4 {get;set;}
    public integer emply_m5 {get;set;}
    
    public integer nmql_yest1,nmql_yest2;
    public integer nmql_mtd1,nmql_mtd2;
    public integer nmql_ytd1,nmql_ytd2;
    
    public integer noco_yest1,noco_yest2;
    public integer noco_mtd1,noco_mtd2;
    public integer noco_ytd1,noco_ytd2;
    
    public integer tl_ytd1,tl_ytd2;
    public integer ts_ytd1,ts_ytd2;
    public integer rc_ytd1,rc_ytd2;
    
    public integer wp_ytd11,wp_ytd12;
    public integer wp_ytd21,wp_ytd22;
    public integer wp_ytd31,wp_ytd32;
    public integer wp_ytd41,wp_ytd42;
    public integer wp_ytd51,wp_ytd52;
    
    public integer emply11,emply12;
    public integer emply21,emply22;
    public integer emply31,emply32;
    public integer emply41,emply42;
    public integer emply51,emply52;
    
    
    date myDate = date.today();
    date firstDate = myDate.toStartOfMonth();
    

    public report_dailyReports()
    {
        // Known Vistors 
        knownvisitors_yest = [select count() from Lead where CreatedDate = YESTERDAY];
        knownvisitors_mtd = [select count() from Lead where CreatedDate >= :firstDate And CreatedDate <= TODAY];
        knownvisitors_ytd = [select count() from Lead where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY];
        
        //MQLS
        MQLs_yest = [select count() from Opportunity where CreatedDate = YESTERDAY];
        MQLs_mtd = [select count() from Opportunity where CreatedDate >= :firstDate And CreatedDate <= TODAY];
        MQLs_ytd = [select count() from Opportunity where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY];
        
        //NMQLs
        nmql_yest1 = [select  count() from Lead where LastModifiedDate = YESTERDAY And CC_Status__c = 'nmql'];
        nmql_yest2 = [select  count()from Contact where LastModifiedDate = YESTERDAY And CC_Status__c = 'nmql'];
        
        NMQLs_yest = nmql_yest1 + nmql_yest2 ;
        
        nmql_mtd1 = [select count()from Lead where LastModifiedDate >= :firstDate And LastModifiedDate <= TODAY And CC_Status__c = 'nmql'];
        nmql_mtd2 = [select  count()from Contact where  LastModifiedDate >= :firstDate And LastModifiedDate <= TODAY And CC_Status__c = 'nmql'];
        
        NMQLs_mtd = nmql_mtd1 + nmql_mtd2 ;
        
        nmql_ytd1 = [select count()from Lead where LastModifiedDate >= 2018-01-01T00:00:00.000+0000 And LastModifiedDate <= TODAY  And CC_Status__c = 'nmql'];
        nmql_ytd2 = [select count() from Contact where LastModifiedDate >= 2018-01-01T00:00:00.000+0000 And LastModifiedDate <= TODAY  And CC_Status__c = 'nmql'];
        
        NMQLs_ytd = nmql_ytd1 +nmql_ytd2; 
        
        //NOCO
        noco_yest1= [select  count()from Lead where LastModifiedDate = YESTERDAY And CC_Status__c = 'noco'];
        noco_yest2 = [select  count()from Contact where LastModifiedDate = YESTERDAY And CC_Status__c = 'noco'];
        
        NOCO_yest = noco_yest1+ noco_yest2 ;
        
        noco_mtd1= [select count()from Lead where LastModifiedDate >= :firstDate And LastModifiedDate <= TODAY And CC_Status__c = 'noco'];
        noco_mtd2 = [select count()from Contact where LastModifiedDate >= :firstDate And LastModifiedDate <= TODAY And CC_Status__c = 'noco'];
        
        NOCO_mtd = noco_mtd1+ noco_mtd2 ;
        
        noco_ytd1= [select count()from Lead where LastModifiedDate >= 2018-01-01T00:00:00.000+0000 And LastModifiedDate <= TODAY  And CC_Status__c = 'noco'];
        noco_ytd2 = [select count()from Contact where LastModifiedDate >= 2018-01-01T00:00:00.000+0000 And LastModifiedDate <= TODAY  And CC_Status__c = 'noco'];
        
        NOCO_ytd = noco_ytd1+ noco_ytd2 ;
        
        //Freshleads to Callcenter
        freshlead_yest = [select count()from Lead where CreatedDate= YESTERDAY And CC_Status__c = NULL];
        freshlead_mtd = [select count()from Lead where LastModifiedDate >= :firstDate And LastModifiedDate <= TODAY And CC_Status__c = NULL];
        freshlead_ytd = [select count() from Lead where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND CC_Status__c = NULL];  
        
        //Callback
        callback_yest = [select count()from Lead where CreatedDate= YESTERDAY And (CC_Status__c = 'callback' OR CC_Status__c = 'callback1' OR CC_Status__c = 'callback2')];
        callback_mtd = [select count()from Lead where CreatedDate >= :firstDate And CreatedDate <= TODAY AND (CC_Status__c = 'callback2' OR CC_Status__c = 'callback1' OR CC_Status__c = 'callback')];
        callback_ytd = [select count() from Lead where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND (CC_Status__c = 'callback' OR CC_Status__c = 'callback1' OR CC_Status__c = 'callback2')];
        
        //contact us
        
        contactus_yest = [select count()from Lead where pi__created_date__c= YESTERDAY And pi__conversion_object_name__c = 'Contact Us'];
        contactus_mtd = [select count()from Lead where pi__created_date__c>= :firstDate And pi__created_date__c<= TODAY And pi__conversion_object_name__c = 'Contact Us'];
        contactus_ytd = [select count() from Lead where pi__created_date__c>= 2018-01-01T00:00:00.000+0000 And pi__created_date__c<= TODAY AND pi__conversion_object_name__c = 'Contact Us'];
        
        //Offer
        offer_yest = [select count()from Lead where pi__created_date__c= YESTERDAY And pi__conversion_object_name__c =  'Offer Form'];
        offer_mtd = [select count()from Lead where pi__created_date__c>= :firstDate And pi__created_date__c<= TODAY And pi__conversion_object_name__c =  'Offer Form'];
        offer_ytd = [select count() from Lead where pi__created_date__c>= 2018-01-01T00:00:00.000+0000 And pi__created_date__c<= TODAY AND pi__conversion_object_name__c = 'Offer Form'];
        
        //Segmentation by Sample Requested
        //Threadlocker
        tl_ytd1 = [select count() from Lead where CreatedDate>= 2018-01-01T00:00:00.000+0000 And CreatedDate<= TODAY AND Which_Product_Sent__c = 'LOCTITE Threadlocker 243' AND isConverted = False];
        tl_ytd2 = [select count() from Opportunity where CreatedDate>= 2018-01-01T00:00:00.000+0000 And CreatedDate<= TODAY AND Which_Product_Sent__c = 'LOCTITE Threadlocker 243'];
        threadlocker_ytd = tl_ytd1 + tl_ytd2;
        
        threadlocker_ytd_mql = [select count() from Opportunity where CreatedDate>= 2018-01-01T00:00:00.000+0000 And CreatedDate<= TODAY AND Which_Product_Sent__c = 'LOCTITE Threadlocker 243' AND CC_Status__c = 'mql'];
        
        //Thread Sealant
        ts_ytd1 = [select count() from Lead where CreatedDate>= 2018-01-01T00:00:00.000+0000 And CreatedDate<= TODAY AND Which_Product_Sent__c = 'LOCTITE Thread Sealants 542' AND isConverted = False];
        ts_ytd2 = [select count() from Opportunity where CreatedDate>= 2018-01-01T00:00:00.000+0000 And CreatedDate<= TODAY AND Which_Product_Sent__c = 'LOCTITE Thread Sealants 542'];
        threadsealant_ytd = ts_ytd1 + ts_ytd2 ;
        
        threadsealant_ytd_mql = [select count() from Opportunity where CreatedDate>= 2018-01-01T00:00:00.000+0000 And CreatedDate<= TODAY AND Which_Product_Sent__c = 'LOCTITE Thread Sealants 542' AND CC_Status__c = 'mql'];
        
        //Retaining Compound
        rc_ytd1 = [select count() from Lead where CreatedDate>= 2018-01-01T00:00:00.000+0000 And CreatedDate<= TODAY AND Which_Product_Sent__c = 'LOCTITE Retaining Compound 638' AND isConverted = False];
        rc_ytd2 = [select count() from Opportunity where CreatedDate>= 2018-01-01T00:00:00.000+0000 And CreatedDate<= TODAY AND Which_Product_Sent__c = 'LOCTITE Retaining Compound 638'];
        retainingcompound_ytd = rc_ytd1 + rc_ytd2;
        
        retainingcompound_ytd_mql = [select count() from Opportunity where CreatedDate>= 2018-01-01T00:00:00.000+0000 And CreatedDate<= TODAY AND Which_Product_Sent__c = 'LOCTITE Retaining Compound 638' AND CC_Status__c = 'mql'];
        
        //What the purpose/Use?
        //Maintenance of Machinery or Facility
        wp_ytd11 = [select count() from Lead where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND What_is_the_purpose_use__c = 'Maintenance of Machinery or Facility' AND isconverted = false];
        wp_ytd12 = [select count() from Contact where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND What_is_the_purpose_use__c = 'Maintenance of Machinery or Facility'];
        whatpurposeytd1 = wp_ytd11 + wp_ytd12 ;
        
        whatpurposeytd_m1  = [select count() from Contact where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND What_is_the_purpose_use__c = 'Maintenance of Machinery or Facility' AND CC_Status__c = 'mql'];
        
        //For use in product assembly or manufacturing
        wp_ytd21 = [select count() from Lead where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND What_is_the_purpose_use__c = 'For use in product assembly or manufacturing' and isconverted = false];
        wp_ytd22 = [select count() from Opportunity where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND What_is_the_purpose_use__c = 'For use in product assembly or manufacturing'];
        whatpurposeytd2 = wp_ytd21 +wp_ytd22;
        
        whatpurposeytd_m2 = [select count() from Contact where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND What_is_the_purpose_use__c = 'For use in product assembly or manufacturing' AND CC_Status__c = 'mql'];
        
        //Automotive repair & maintenance
        wp_ytd31 = [select count() from Lead where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND What_is_the_purpose_use__c = 'Automotive repair & maintenance' and isconverted = false];
        wp_ytd32 = [select count() from Contact where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND What_is_the_purpose_use__c = 'Automotive repair & maintenance'];
        whatpurposeytd3 = wp_ytd31 + wp_ytd32;
        
        whatpurposeytd_m3 = [select count() from Contact where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND What_is_the_purpose_use__c = 'Automotive repair & maintenance' AND CC_Status__c = 'mql'];
        
        //Personal Use or Home equipment Repair
        wp_ytd41 = [select count() from Lead where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND What_is_the_purpose_use__c = 'Personal Use or Home equipment Repair' and isconverted = false];
        wp_ytd42 = [select count() from Contact where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND What_is_the_purpose_use__c = 'Personal Use or Home equipment Repair'];
        whatpurposeytd4 = wp_ytd41 +wp_ytd42 ;
        
        whatpurposeytd_m4 = [select count() from Contact where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND What_is_the_purpose_use__c = 'Personal Use or Home equipment Repair' AND CC_Status__C = 'mql'];
        
        //Blank
        wp_ytd51 = [select count() from Lead where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND What_is_the_purpose_use__c = NULL AND isconverted = false];
        wp_ytd52 = [select count() from Contact where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND What_is_the_purpose_use__c = NULL];
        whatpurposeytd5 = wp_ytd51 + wp_ytd52 ;
        
        whatpurposeytd_m5 = [select count() from Opportunity where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND What_is_the_purpose_use__c = NULL AND CC_Status__c = 'mql'];
        
        //Segmentation by Employees 
        //<20
         emply11 = [select count() from lead where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND Number_of_Employees_Custom__c = '0-20' and isconverted = false];
         emply12 = [select count() from Contact where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND Number_of_Employees_Custom__c = '0-20'];
         emply1 = emply11 + emply12;
         
         emply_m1 = [select count() from Contact where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND Number_of_Employees_Custom__c = '0-20' AND CC_Status__c = 'mql']; 
         
        //20-100
        emply21 = [select count() from lead where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND Number_of_Employees_Custom__c = '20-100' and isconverted = false];
        emply22 = [select count() from Contact where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND Number_of_Employees_Custom__c = '20-100'];
        emply2 = emply21 + emply22; 
        
        emply_m2 = [select count() from Contact where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND Number_of_Employees_Custom__c = '20-100' and CC_Status__c = 'mql'] ; 
        
        //100-500
        emply31 = [select count() from Lead where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND Number_of_Employees_Custom__c = '100-500' and isconverted = false];
        emply32 = [select count() from Contact where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND Number_of_Employees_Custom__c = '100-500'];
        emply3 = emply31 + emply32; 
        
        emply_m3 = [select count() from Contact where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND Number_of_Employees_Custom__c = '100-500' and CC_Status__c = 'mql'];
        
        //>500
        emply41 = [select count() from lead where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND Number_of_Employees_Custom__c = '>500' and isconverted = false];
        emply42 = [select count() from Contact where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND Number_of_Employees_Custom__c = '>500'];
        emply4 = emply41 + emply42;
        
        emply_m4 = [select count() from Contact where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND Number_of_Employees_Custom__c = '>500' and CC_Status__c = 'mql'];
        
        //Blank
        emply51 = [select count() from lead where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND Number_of_Employees_Custom__c = NULL and isconverted = false];
        emply52 = [select count() from Contact where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND Number_of_Employees_Custom__c = NULL];
        emply5 = emply51 + emply52;
        
        emply_m5 = [select count() from Contact where CreatedDate >= 2018-01-01T00:00:00.000+0000 And CreatedDate <= TODAY AND Number_of_Employees_Custom__c = NULL and CC_Status__c = 'mql'];
  }     
}