@isTest
public class TaskOriginalDateTest {
   public static testmethod void taskmethod()
   {
       Task t = new Task(Subject='Original Date',Status='Open',ActivityDate=date.parse('10/10/2018'));
       insert t;
   }
}