public with sharing class FreightTriggerHandler {
    
    public List<Freight__c> oldFreight;
    public List<Freight__c> newFreight;
    public Map<Id, Freight__c> oldMap;
    public Map<Id, Freight__c> newMap; 

    public FreightTriggerHandler(List<Freight__c> oldFreight, List<Freight__c> newFreight,Map<Id, Freight__c> oldMap, Map<Id, Freight__c> newMap)
    {
        this.oldFreight = oldFreight; 
        this.newFreight= newFreight; 
        this.oldMap = oldMap; 
        this.newMap = newMap; 
    }

    public void beforeInsert()
    {
        FreightHelper.verificarCamposEndereco(newFreight);
    }
    public void beforeUpdate()
    {
        FreightHelper.verificarCamposEndereco(newFreight);
    }
}
