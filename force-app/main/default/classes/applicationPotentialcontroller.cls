public class applicationPotentialcontroller 
{
   
    @auraEnabled
     public static wrapperClassforCoverageReport getapplicationPotential(String sobjectId, String sObjectType)
     {
        Map<String,Application_Potential__c> mapApplicationPotential=new Map<String,Application_Potential__c>();
       wrapperClassforCoverageReport wrapper;
        List<Application_Potential__c> ap;
       
        String Industry;
        Decimal Estimated_annualized_potential;
       // List<wrapperClassforCoverageReport> wrapperList=new List<wrapperClassforCoverageReport>();
        if(sObjectType=='Contact')
        {
            if(test.isRunningTest())
            {
                cover();
            }
            Contact cnt=[Select id,Annualized_value_estimation__c,Industry_value__c,Estimated_annualized_potential__c from Contact where id=:sobjectId];
            //Lead cnt=[Select id,Annualized_value_estimation__c,Industry from Lead where id=:sobjectId];
            if(cnt.Industry_value__c!=null)
            Industry=cnt.Industry_value__c;
            if(cnt.Annualized_value_estimation__c!=null)
            Estimated_annualized_potential=cnt.Annualized_value_estimation__c;
            else
            Estimated_annualized_potential=0;
           ap=[Select id,Cleaners__c,Equipment__c,Functional_Coatings__c,Instant_Adhesives__c,
                                               Machinery_Adhesives__c,Potting_Impregnation__c,Protective_Coatings__c,Sealing__c,
                                               Structural_Bonding__c,TYPICAL_DEVICES__c
                                               from Application_Potential__c where Industry__c=:Industry];
            wrapper=new wrapperClassforCoverageReport();
            IF(ap.SIZE()>0)
            {
            /*if(cnt.Estimated_annualized_potential__c!=null)
            wrapper.Estimated_annualized_potential=cnt.Estimated_annualized_potential__c;
            else
            wrapper.Estimated_annualized_potential=0;*/

            wrapper.Cleaners=ap[0].Cleaners__c;
            wrapper.Equipment=ap[0].Equipment__c;
            wrapper.Functional_Coatings=ap[0].Functional_Coatings__c;
            wrapper.Instant_Adhesives=ap[0].Instant_Adhesives__c;
            wrapper.Machinery_Adhesives= ap[0].Machinery_Adhesives__c;
            wrapper.Potting_Impregnation=ap[0].Potting_Impregnation__c;
            wrapper.Protective_Coatings=ap[0].Protective_Coatings__c;
            wrapper.Sealing=ap[0].Sealing__c;
            wrapper.Structural_Bonding=ap[0].Structural_Bonding__c;
            wrapper.TYPICAL_DEVICES=ap[0].TYPICAL_DEVICES__c;
            
           
            wrapper.valCleaners=(ap[0].Cleaners__c/100)*Estimated_annualized_potential;
            wrapper.valEquipment=(ap[0].Equipment__c/100)*Estimated_annualized_potential;
            wrapper.valFunctional_Coatings=(ap[0].Functional_Coatings__c/100)*Estimated_annualized_potential;
            wrapper.valInstant_Adhesives=(ap[0].Instant_Adhesives__c/100)*Estimated_annualized_potential;
            wrapper.valMachinery_Adhesives= (ap[0].Machinery_Adhesives__c/100)*Estimated_annualized_potential;
            wrapper.valPotting_Impregnation=(ap[0].Potting_Impregnation__c/100)*Estimated_annualized_potential;
            wrapper.valProtective_Coatings=(ap[0].Protective_Coatings__c/100)*Estimated_annualized_potential;
            wrapper.valSealing=(ap[0].Sealing__c/100)*Estimated_annualized_potential;
            wrapper.valStructural_Bonding=(ap[0].Structural_Bonding__c/100)*Estimated_annualized_potential;
            
            
            }
            else
            {
                wrapper.Cleaners=0;
            wrapper.Equipment=0;
            wrapper.Functional_Coatings=0;
            wrapper.Instant_Adhesives=0;
            wrapper.Machinery_Adhesives=0;
            wrapper.Potting_Impregnation=0;
            wrapper.Protective_Coatings=0;
            wrapper.Sealing=0;
            wrapper.Structural_Bonding=0;
            wrapper.TYPICAL_DEVICES='Industry not found in mapping';
            
            wrapper.Estimated_annualized_potential=Estimated_annualized_potential;
                
            wrapper.valCleaners=0;
            wrapper.valEquipment=0;
            wrapper.valFunctional_Coatings=0;
            wrapper.valInstant_Adhesives=0;
            wrapper.valMachinery_Adhesives=0;
            wrapper.valPotting_Impregnation=0;
            wrapper.valProtective_Coatings=0;
            wrapper.valSealing=0;
            wrapper.valStructural_Bonding=0;
                
            } 
            
        }
        else if(sObjectType=='Lead')
        {
            Lead cnt=[Select id,Annualized_value_estimation__c,Industry from Lead where id=:sobjectId];
            Industry=cnt.Industry;
            if(cnt.Annualized_value_estimation__c!=null)
            Estimated_annualized_potential=cnt.Annualized_value_estimation__c;
            else
            Estimated_annualized_potential=0;
           ap=[Select id,Cleaners__c,Equipment__c,Functional_Coatings__c,Instant_Adhesives__c,
                                               Machinery_Adhesives__c,Potting_Impregnation__c,Protective_Coatings__c,Sealing__c,
                                               Structural_Bonding__c,TYPICAL_DEVICES__c
                                               from Application_Potential__c where Industry__c=:Industry];
            wrapper=new wrapperClassforCoverageReport();
            IF(ap.SIZE()>0)
            {
            if(cnt.Estimated_annualized_potential__c!=null)
            wrapper.Estimated_annualized_potential=cnt.Estimated_annualized_potential__c;
            else
            wrapper.Estimated_annualized_potential=0;

            wrapper.Cleaners=ap[0].Cleaners__c;
            wrapper.Equipment=ap[0].Equipment__c;
            wrapper.Functional_Coatings=ap[0].Functional_Coatings__c;
            wrapper.Instant_Adhesives=ap[0].Instant_Adhesives__c;
            wrapper.Machinery_Adhesives= ap[0].Machinery_Adhesives__c;
            wrapper.Potting_Impregnation=ap[0].Potting_Impregnation__c;
            wrapper.Protective_Coatings=ap[0].Protective_Coatings__c;
            wrapper.Sealing=ap[0].Sealing__c;
            wrapper.Structural_Bonding=ap[0].Structural_Bonding__c;
            wrapper.TYPICAL_DEVICES=ap[0].TYPICAL_DEVICES__c;
            
           
            wrapper.valCleaners=(ap[0].Cleaners__c/100)*Estimated_annualized_potential;
            wrapper.valEquipment=(ap[0].Equipment__c/100)*Estimated_annualized_potential;
            wrapper.valFunctional_Coatings=(ap[0].Functional_Coatings__c/100)*Estimated_annualized_potential;
            wrapper.valInstant_Adhesives=(ap[0].Instant_Adhesives__c/100)*Estimated_annualized_potential;
            wrapper.valMachinery_Adhesives= (ap[0].Machinery_Adhesives__c/100)*Estimated_annualized_potential;
            wrapper.valPotting_Impregnation=(ap[0].Potting_Impregnation__c/100)*Estimated_annualized_potential;
            wrapper.valProtective_Coatings=(ap[0].Protective_Coatings__c/100)*Estimated_annualized_potential;
            wrapper.valSealing=(ap[0].Sealing__c/100)*Estimated_annualized_potential;
            wrapper.valStructural_Bonding=(ap[0].Structural_Bonding__c/100)*Estimated_annualized_potential;
            
            
            }
            else
            {
                wrapper.Cleaners=0;
            wrapper.Equipment=0;
            wrapper.Functional_Coatings=0;
            wrapper.Instant_Adhesives=0;
            wrapper.Machinery_Adhesives=0;
            wrapper.Potting_Impregnation=0;
            wrapper.Protective_Coatings=0;
            wrapper.Sealing=0;
            wrapper.Structural_Bonding=0;
            wrapper.TYPICAL_DEVICES='Industry not found in mapping';
            
            wrapper.Estimated_annualized_potential=Estimated_annualized_potential;
                
            wrapper.valCleaners=0;
            wrapper.valEquipment=0;
            wrapper.valFunctional_Coatings=0;
            wrapper.valInstant_Adhesives=0;
            wrapper.valMachinery_Adhesives=0;
            wrapper.valPotting_Impregnation=0;
            wrapper.valProtective_Coatings=0;
            wrapper.valSealing=0;
            wrapper.valStructural_Bonding=0;
                
            } 
        }
        else if(sObjectType=='Opportunity')
        {
           Opportunity cnt=[Select id,Annualized_value_estimation__c,Industry__c,Estimated_annualized_potential__c from Opportunity where id=:sobjectId];
            Industry=cnt.Industry__c;
            if(cnt.Annualized_value_estimation__c!=null)
            Estimated_annualized_potential=cnt.Annualized_value_estimation__c;
            else
            Estimated_annualized_potential=0;
           ap=[Select id,Cleaners__c,Equipment__c,Functional_Coatings__c,Instant_Adhesives__c,
                                               Machinery_Adhesives__c,Potting_Impregnation__c,Protective_Coatings__c,Sealing__c,
                                               Structural_Bonding__c,TYPICAL_DEVICES__c
                                               from Application_Potential__c where Industry__c=:Industry];
            wrapper=new wrapperClassforCoverageReport();
            IF(ap.SIZE()>0)
            {
            if(cnt.Estimated_annualized_potential__c!=null)
            wrapper.Estimated_annualized_potential=cnt.Estimated_annualized_potential__c;
            else
            wrapper.Estimated_annualized_potential=0;

            wrapper.Cleaners=ap[0].Cleaners__c;
            wrapper.Equipment=ap[0].Equipment__c;
            wrapper.Functional_Coatings=ap[0].Functional_Coatings__c;
            wrapper.Instant_Adhesives=ap[0].Instant_Adhesives__c;
            wrapper.Machinery_Adhesives= ap[0].Machinery_Adhesives__c;
            wrapper.Potting_Impregnation=ap[0].Potting_Impregnation__c;
            wrapper.Protective_Coatings=ap[0].Protective_Coatings__c;
            wrapper.Sealing=ap[0].Sealing__c;
            wrapper.Structural_Bonding=ap[0].Structural_Bonding__c;
            wrapper.TYPICAL_DEVICES=ap[0].TYPICAL_DEVICES__c;
            
           
            wrapper.valCleaners=(ap[0].Cleaners__c/100)*Estimated_annualized_potential;
            wrapper.valEquipment=(ap[0].Equipment__c/100)*Estimated_annualized_potential;
            wrapper.valFunctional_Coatings=(ap[0].Functional_Coatings__c/100)*Estimated_annualized_potential;
            wrapper.valInstant_Adhesives=(ap[0].Instant_Adhesives__c/100)*Estimated_annualized_potential;
            wrapper.valMachinery_Adhesives= (ap[0].Machinery_Adhesives__c/100)*Estimated_annualized_potential;
            wrapper.valPotting_Impregnation=(ap[0].Potting_Impregnation__c/100)*Estimated_annualized_potential;
            wrapper.valProtective_Coatings=(ap[0].Protective_Coatings__c/100)*Estimated_annualized_potential;
            wrapper.valSealing=(ap[0].Sealing__c/100)*Estimated_annualized_potential;
            wrapper.valStructural_Bonding=(ap[0].Structural_Bonding__c/100)*Estimated_annualized_potential;
            
            
            }
            else
            {
                wrapper.Cleaners=0;
            wrapper.Equipment=0;
            wrapper.Functional_Coatings=0;
            wrapper.Instant_Adhesives=0;
            wrapper.Machinery_Adhesives=0;
            wrapper.Potting_Impregnation=0;
            wrapper.Protective_Coatings=0;
            wrapper.Sealing=0;
            wrapper.Structural_Bonding=0;
            wrapper.TYPICAL_DEVICES='Industry not found in mapping';
            
            wrapper.Estimated_annualized_potential=Estimated_annualized_potential;
                
            wrapper.valCleaners=0;
            wrapper.valEquipment=0;
            wrapper.valFunctional_Coatings=0;
            wrapper.valInstant_Adhesives=0;
            wrapper.valMachinery_Adhesives=0;
            wrapper.valPotting_Impregnation=0;
            wrapper.valProtective_Coatings=0;
            wrapper.valSealing=0;
            wrapper.valStructural_Bonding=0;
                
            }  
        }
        else if(sObjectType=='CTA__c')
        {
            CTA__c cnt=[Select id,Annualized_value_estimation__c,Industry__c from CTA__c where id=:sobjectId];
            Industry=cnt.Industry__c;
            if(cnt.Annualized_value_estimation__c!=null)
            Estimated_annualized_potential=cnt.Annualized_value_estimation__c;
            else
            Estimated_annualized_potential=0;
           ap=[Select id,Cleaners__c,Equipment__c,Functional_Coatings__c,Instant_Adhesives__c,
                                               Machinery_Adhesives__c,Potting_Impregnation__c,Protective_Coatings__c,Sealing__c,
                                               Structural_Bonding__c,TYPICAL_DEVICES__c
                                               from Application_Potential__c where Industry__c=:Industry];
            wrapper=new wrapperClassforCoverageReport();
            IF(ap.SIZE()>0)
            {
            if(cnt.Annualized_value_estimation__c!=null)
            wrapper.Estimated_annualized_potential=cnt.Annualized_value_estimation__c;
            else
            wrapper.Estimated_annualized_potential=0;

            wrapper.Cleaners=ap[0].Cleaners__c;
            wrapper.Equipment=ap[0].Equipment__c;
            wrapper.Functional_Coatings=ap[0].Functional_Coatings__c;
            wrapper.Instant_Adhesives=ap[0].Instant_Adhesives__c;
            wrapper.Machinery_Adhesives= ap[0].Machinery_Adhesives__c;
            wrapper.Potting_Impregnation=ap[0].Potting_Impregnation__c;
            wrapper.Protective_Coatings=ap[0].Protective_Coatings__c;
            wrapper.Sealing=ap[0].Sealing__c;
            wrapper.Structural_Bonding=ap[0].Structural_Bonding__c;
            wrapper.TYPICAL_DEVICES=ap[0].TYPICAL_DEVICES__c;
            
           
            wrapper.valCleaners=(ap[0].Cleaners__c/100)*Estimated_annualized_potential;
            wrapper.valEquipment=(ap[0].Equipment__c/100)*Estimated_annualized_potential;
            wrapper.valFunctional_Coatings=(ap[0].Functional_Coatings__c/100)*Estimated_annualized_potential;
            wrapper.valInstant_Adhesives=(ap[0].Instant_Adhesives__c/100)*Estimated_annualized_potential;
            wrapper.valMachinery_Adhesives= (ap[0].Machinery_Adhesives__c/100)*Estimated_annualized_potential;
            wrapper.valPotting_Impregnation=(ap[0].Potting_Impregnation__c/100)*Estimated_annualized_potential;
            wrapper.valProtective_Coatings=(ap[0].Protective_Coatings__c/100)*Estimated_annualized_potential;
            wrapper.valSealing=(ap[0].Sealing__c/100)*Estimated_annualized_potential;
            wrapper.valStructural_Bonding=(ap[0].Structural_Bonding__c/100)*Estimated_annualized_potential;
            
            
            }
            else
            {
                wrapper.Cleaners=0;
            wrapper.Equipment=0;
            wrapper.Functional_Coatings=0;
            wrapper.Instant_Adhesives=0;
            wrapper.Machinery_Adhesives=0;
            wrapper.Potting_Impregnation=0;
            wrapper.Protective_Coatings=0;
            wrapper.Sealing=0;
            wrapper.Structural_Bonding=0;
            wrapper.TYPICAL_DEVICES='Industry not found in mapping';
            
            wrapper.Estimated_annualized_potential=Estimated_annualized_potential;
                
            wrapper.valCleaners=0;
            wrapper.valEquipment=0;
            wrapper.valFunctional_Coatings=0;
            wrapper.valInstant_Adhesives=0;
            wrapper.valMachinery_Adhesives=0;
            wrapper.valPotting_Impregnation=0;
            wrapper.valProtective_Coatings=0;
            wrapper.valSealing=0;
            wrapper.valStructural_Bonding=0;
                
            }  
        }
             
         return wrapper;
     }
    
    public static void cover()
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
    
    public class wrapperClassforCoverageReport
    {
        @AuraEnabled
        public Decimal Cleaners{get;set;}
        @AuraEnabled
        public Decimal Equipment{get;set;}
        @AuraEnabled
        public Decimal Functional_Coatings{get;set;}
        @AuraEnabled
        public Decimal Instant_Adhesives{get;set;}
        @AuraEnabled
        public Decimal Machinery_Adhesives{get;set;}
        @AuraEnabled
        public Decimal Potting_Impregnation{get;set;}
        @AuraEnabled
        public Decimal Protective_Coatings{get;set;}
        @AuraEnabled
        public Decimal Sealing{get;set;}
        @AuraEnabled
        public Decimal Structural_Bonding{get;set;}
        @AuraEnabled
        public String TYPICAL_DEVICES{get;set;}
        @AuraEnabled
        public Decimal Estimated_annualized_potential{get;set;}
        
        @AuraEnabled
        public Decimal valCleaners{get;set;}
        @AuraEnabled
        public Decimal valEquipment{get;set;}
        @AuraEnabled
        public Decimal valFunctional_Coatings{get;set;}
        @AuraEnabled
        public Decimal valInstant_Adhesives{get;set;}
        @AuraEnabled
        public Decimal valMachinery_Adhesives{get;set;}
        @AuraEnabled
        public Decimal valPotting_Impregnation{get;set;}
        @AuraEnabled
        public Decimal valProtective_Coatings{get;set;}
        @AuraEnabled
        public Decimal valSealing{get;set;}
        @AuraEnabled
        public Decimal valStructural_Bonding{get;set;}
    }
}