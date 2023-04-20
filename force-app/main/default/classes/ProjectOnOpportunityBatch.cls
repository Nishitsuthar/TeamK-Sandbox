/**
 * Title
 *
 * @author Nishit Suthar
 * @version 1.0
 * @description 
 * @uses  
 * @history
 * yyyy-mm-dd : 
 */
public class ProjectOnOpportunityBatch implements Database.Batchable<buildertek__Project__c> {

    public Opportunity opp {get;set;}
    public List<buildertek__Project__c> projectList {get;set;}

    public ProjectOnOpportunityBatch(Opportunity getOpp, List<buildertek__Project__c> getProjectList){
        opp = new Opportunity();
        projectList = new List<buildertek__Project__c>();
        
        System.debug('getOpp ==> '+getOpp);
        System.debug('getProjectList ==> '+getProjectList);
        
        opp = getOpp;
        projectList = getProjectList;
    }
    
    public List<buildertek__Project__c> start(Database.BatchableContext bc) {
        return projectList;
    }
    
    public void execute(Database.BatchableContext bc, List<buildertek__Project__c> scope) {
        for (buildertek__Project__c sc : scope) {
            System.debug('sc ==> '+sc);
            TeamK_CreateProjectFromOpportunity.createProject(opp, sc);
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        // Perform any post-processing logic here
        System.debug('opp '+opp);
        System.debug('projectList '+projectList);
        
    }
}