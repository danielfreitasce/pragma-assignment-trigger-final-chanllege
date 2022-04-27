trigger OrderItemTrigger on OrderItem (after update, after insert, after delete) {


	OrderItemTriggerHandler handler = new OrderItemTriggerHandler(
		Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap
		);

	switch on Trigger.operationType {
		when AFTER_UPDATE {

		}
		when AFTER_INSERT {
			handler.afterInsert();
		}
		when AFTER_DELETE {

		}
	}

}