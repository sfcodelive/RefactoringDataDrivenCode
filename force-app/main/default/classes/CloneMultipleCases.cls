/**
 * In our company, we receive repair orders via email-to-case services. 
 * Until we can integrate with the ordering system, we receive Purchase Orders by email, 
 * and often the customer sends one PO with several items. 
 * This is the scenario where one email is received for multiple line items, and we need 
 * one case per item as each item is repaired in a different location and needs to be 
 * tracked independently. 
 * The user would need to advise in the UI how many cases needs to be cloned 
 * and we need to limit to 30 to prevent generating a handful of cases by mistake.
 */
public with sharing class CloneMultipleCases {
  
    // User providing number of cases to clone and CaseId of the case to be cloned
    @AuraEnabled
    public static List<Id> casesToClone(Integer numberOfCases, Id caseId){
        //make sure number of cases is valid (-1 < numCases < 31)
        numberOfCases = Math.min(Math.abs(numberOfCases), 30);
        Case toClone = [SELECT ID FROM Case WHERE Id = :caseId];
        list<Case> clonedCases = new List<Case>();
        for (Integer i=0; i < numberOfCases; i++){
            Case newClonedCase = toClone.clone();
            newClonedCase.parentId = caseId;
            clonedCases.add(newClonedCase);
        }

        insert clonedCases;
        Set<Id> theIds = new Map<id, Case>(clonedCases).keyset();

        return new List<Id>(theIds);
    }
}