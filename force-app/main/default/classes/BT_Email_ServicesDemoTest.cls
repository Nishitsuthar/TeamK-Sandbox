@istest
public class BT_Email_ServicesDemoTest {

    @isTest
    static void testMethod1(){
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();  
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.subject = 'Testing Email';
        email.plainTextBody = 'Testing Email Body';
        email.toAddresses = new String[] {'projects@q-ivs1lpwxv95175bnye242zxao2n19ihhtnzf5965dy6yf6o0s.e2-4xvfma2.usa62s.apex.sandbox.salesforce.com'};
        System.debug('email ==> '+email);
        emailList.add(email);
        Messaging.sendEmail(emailList);
    }
}