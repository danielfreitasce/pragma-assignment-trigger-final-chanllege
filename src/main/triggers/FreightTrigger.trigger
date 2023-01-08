trigger FreightTrigger on Freight__c (before insert, before update) {

    FreightTriggerHandler handler = new FreightTriggerHandler(
        Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap
    );

    switch on Trigger.operationType {
        when BEFORE_UPDATE{
            handler.beforeUpdate();   
        }
        when BEFORE_INSERT{
            handler.beforeInsert();   
        }
    }
}