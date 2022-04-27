public with sharing class OrderHelper
{
	// A conta não pode ser alterada mesmo o pedido estando em rascunho
	public static void verificarAlteracaoConta(Map<Id, Order> oldMap, Map<Id, Order> newMap)
	{
		for(Order orderNew : newMap.values())
		{
			Order oldOrder = oldMap.get(orderNew.Id);

			if(orderNew.AccountId != oldOrder.AccountId)
				orderNew.addError('A conta relativa ao pedido não pode ser alterada.');

			if(orderNew.DistributionCenter__c != oldOrder.DistributionCenter__c && oldOrder.DistributionCenter__c != null)
				orderNew.addError('O centro de distribuição não pode ser alterado.');
		}
	}

	//O endereço de entrega do pedido deverá ser o endereço de entrega relativo do seu cliente.
	public static void obterEnderecoCliente(List<Order> newOrder)
	{
		Set<Id> setContasId = new Set<Id>();

		for(Order o :  newOrder)
		{
			if(o.ShippingAddress == null)
			{
				System.debug('shipping address will be add');
				setContasId.add(o.AccountId);
			}

		}

		if(setContasId.isEmpty())
			return;

		List<Account> enderecoContas =  [SELECT Id, ShippingStreet, ShippingCity, ShippingCountry, ShippingPostalCode, ShippingState
		                                 FROM Account
		                                 WHERE Id IN : setContasId];

		Map<Id, Account> enderecoContasMap = new  Map<Id, Account>(enderecoContas);

		for(Order o :  newOrder)
		{
			SObject endereco = enderecoContasMap.get(o.AccountId);
			if(enderecoContasMap.containsKey(o.AccountId))
			{
				o.ShippingStreet = (String) endereco.get('ShippingStreet');
				o.ShippingCity = (String) endereco.get('ShippingCity');
				o.ShippingCountry = (String) endereco.get('ShippingCountry');
				o.ShippingPostalCode = (String) endereco.get('ShippingPostalCode');
				o.ShippingState = (String) endereco.get('ShippingState');
			}

		}
	}

	//calcular valotes totais de volume, peso  e quantidade para cada pedido.


}