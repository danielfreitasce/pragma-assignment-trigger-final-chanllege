public with sharing class OrderItemHelper {


	//calcular valotes totais de volume, peso  e quantidade para cada pedido

	public static void calcPrice(List<OrderItem> orderItemList)
	{
		Set<Id> orderIdSet = new Set<Id>();
		Set<Id> accountIdSet = new Set<Id>();

		for(OrderItem orderItem :  orderItemList)
		{
			orderIdSet.add(orderItem.OrderId);
		}

		Map<Id, Order> orderMap = new Map<Id, Order>([
								     SELECT Id, AccountId
								     FROM Order
								     WHERE Id IN: orderIdSet
		                                             ]);

		Map<Id, AggregateResult> totaisPorPedidoMap = calcTotaisItens(orderIdSet);


		for(Order order :  orderMap.values())
		{
			accountIdSet.add(order.AccountId);
		}

		Map<Id, Account> accountMap =  new Map<Id, Account>([SELECT Id, City__c, CEP__c FROM Account WHERE Id IN: accountIdSet]);

		//fazer um Set para cada valor de endereço
		Set<String> listaCeps = new Set<String>();
		Set<String> listaCidades = new Set<String>();

		for(Account acc : accountMap.values())
		{
			listaCeps.add(acc.CEP__c);
			listaCidades.add(acc.City__c);

		}

		//obter os fretes usando os endereços das contas

		List<Freight__c> listaFretes = [SELECT Id, CEP__c, City__c, State__c, DistributionCenter__c,  FreightBase__c, FreightByVolume__c, FreightByWeight__c
		                                FROM Freight__c
		                                WHERE CEP__c IN : listaCeps OR City__c IN : listaCidades];


		//agrupar por centro de distribuição

		Map<Id, List<Freight__c> > fretePorCDMapa = new Map<Id, List<Freight__c> >();

		/*preencher chaves do mapa*/
		for(Freight__c frete : listaFretes)
			fretePorCDMapa.put(frete.DistributionCenter__c, new List<Freight__c>());

		/*preenhcer valores*/
		for(Freight__c frete : listaFretes)
		{
			if(fretePorCDMapa.containsKey(frete.DistributionCenter__c))
			{
				List<Freight__c> fretes = fretePorCDMapa.get(frete.DistributionCenter__c);
				fretes.add(frete);
				fretePorCDMapa.put(frete.DistributionCenter__c, fretes);
			}
		}

		//Iterar sobre a lista de fretes

		for(Order order : orderMap.values())
		{
			Account acc = accountMap.get(order.AccountId);

			for(Id cd : fretePorCDMapa.keySet())
			{
				List<Freight__c> listaFretesPorCD = fretePorCDMapa.get(cd);
				List<Freight__c> fretesEscolhidos = new List<Freight__c>();

				for(Freight__c frete : listaFretesPorCD)
				{
					if(frete.CEP__c == acc.CEP__c)
					{
						fretesEscolhidos.add(frete);
					}
					else if(frete.City__c == acc.City__c)
					{
						fretesEscolhidos.add(frete);
					}
					else
					{
						fretesEscolhidos.add(frete);
					}
				}

				fretePorCDMapa.put(cd, fretesEscolhidos);
			}
		}

		//calcular por parâmetro de frete

		Map<Id, Freight__c> freteComValorMaisElevadoPorCD = new Map<Id, Freight__c>();

		for(Id order : orderMap.keySet())
		{

			AggregateResult ar = totaisPorPedidoMap.get(order);

			Decimal vol = (Decimal) ar.get('volume');
			Decimal peso = (Decimal) ar.get('peso');
			Decimal quant = (Decimal) ar.get('quantidade');

			for(Id cd : fretePorCDMapa.keySet())
			{
				List<Freight__c> fretesEscolhidos = fretePorCDMapa.get(cd);


				Decimal valorPorVolume = vol * fretesEscolhidos[0].FreightByVolume__c;
				Decimal valorPorPeso = peso *  fretesEscolhidos[0].FreightByWeight__c;
				Decimal valorPorQuant = quant * fretesEscolhidos[0].FreightBase__c;


				//escolher o frete que tenha o parâmetro mais elevado
				if(valorPorVolume >=  valorPorPeso && valorPorVolume >= valorPorQuant)
				{
					freteComValorMaisElevadoPorCD.put(cd,  fretesEscolhidos[0]);
				}
				else if(valorPorPeso >= valorPorVolume && valorPorPeso >= valorPorQuant)
				{
					freteComValorMaisElevadoPorCD.put(cd,  fretesEscolhidos[0]);
				}
				else if(valorPorQuant >= valorPorVolume && valorPorQuant >= valorPorPeso)
				{
					freteComValorMaisElevadoPorCD.put(cd,  fretesEscolhidos[0]);
				}
			}
		}
	}

	private static Map<Id, AggregateResult>  calcTotaisItens(Set<id> orderIdSet)
	{
		//agrupador por pedido

		List<AggregateResult> resultadosAgrup = [
			SELECT SUM(Quantity) quantidade, SUM(Volume__c) volume, SUM(Weight__c) peso, OrderId
			FROM OrderItem
			WHERE OrderId
			IN : orderIdSet
			GROUP BY OrderId
		];


		Map<Id, AggregateResult> totaisPorPedido = new Map<Id, AggregateResult>();

		for(AggregateResult ar : resultadosAgrup)
		{
			totaisPorPedido.put((Id) ar.get('OrderId'), ar);
		}

		return totaisPorPedido;
	}

}