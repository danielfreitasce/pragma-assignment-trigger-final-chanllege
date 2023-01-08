public with sharing class OrderTriggerHandler {


	public List<Order> oldOrder;
	public List<Order> newOrder;
	public Map<Id, Order> oldMap;
	public Map<Id, Order> newMap;

	public OrderTriggerHandler(List<Order> oldOrder, List<Order> newOrder,Map<Id, Order> oldMap, Map<Id, Order> newMap)
	{
		this.oldOrder = oldOrder;
		this.newOrder = newOrder;
		this.oldMap = oldMap;
		this.newMap = newMap;
	}

	public void beforeUpdate()
	{
		OrderHelper.verificarAlteracaoConta(oldMap, newMap);
		System.debug('estou no before update');
		//OrderHelper.obterEnderecoCliente(newOrder);
		//OrderHelper.buscarItensDoPedido(newMap);
	}

	public void beforeInsert()
	{
		OrderHelper.obterEnderecoCliente(newOrder);
	}

}
