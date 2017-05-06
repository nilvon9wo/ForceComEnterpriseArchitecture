public class TEST_NamespaceUtils {
	public static String getNamespace(SObject sObj) {
		return getNamespace(sObj.getSObjectType());
	}

	public static String getNamespace(SObjectType sObjectType) {
		DescribeSObjectResult description = sObjectType.getDescribe();
		return description.getName()
			.removeEnd(description.getLocalName())
			.removeEnd('__'); 
	}
	
	public static Boolean hasNamespace(SObject sObj) {
		return !String.isEmpty(getNamespace(sObj));
	}
}