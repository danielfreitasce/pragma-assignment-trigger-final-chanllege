public with sharing class FreightHelper {

	public static void verificarCamposEndereco(List<Freight__c> newFreight)
	{
		for(Freight__c frete :  newFreight)
		{

			if(!verificarPreenchimento(frete))
				frete.addError('Preencha um campo de endereço');
			/*else if(!verificarCampo(frete))
			    frete.addError('Você pode preencher apenas um campo de endereço.');*/
		}
	}

	private static Boolean verificarPreenchimento(Freight__c frete)
	{
		if(String.isBlank(frete.CEP__c) && String.isBlank(frete.State__c) && frete.City__c == null)
			return false;

		return true;
	}

	private static Boolean verificarCampo(Freight__c frete)
	{
		if(String.isNotBlank(frete.CEP__c) && (String.isNotBlank(frete.State__c) || frete.City__c != null))
			return false;
		else if(String.isNotBlank(frete.State__c) && (String.isNotBlank(frete.CEP__c) || frete.City__c != null))
			return false;
		else if(frete.City__c != null && (String.isNotBlank(frete.State__c) || String.isNotBlank(frete.CEP__c)))
			return false;

		return true;
	}

}
