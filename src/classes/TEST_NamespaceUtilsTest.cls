@isTest
public class TEST_NamespaceUtilsTest {
	private static final User TEST_RUNNER = TEST_RunAsUserFactory.create(); 
	private static final SObject TEST_SOBJECT = new Account();
	
	@isTest
	public static void testGetNamespaceForSObject() {
		// Arrange
		// Nothing to do here
		 
		// Act
		String result;
		Test.startTest();
		System.runAs(TEST_RUNNER){
			result = TEST_NamespaceUtils.getNamespace(TEST_SOBJECT);
		}
		Test.stopTest();
		
		// Assert
		System.assertEquals('', result);
	}

	@isTest
	public static void testGetNamespaceForSObjectType() {
		// Arrange
		SObjectType sObjectType = TEST_SOBJECT.getSObjectType();

		// Act
		String result;
		Test.startTest();
		System.runAs(TEST_RUNNER){
			result = TEST_NamespaceUtils.getNamespace(sObjectType);
		}
		Test.stopTest();

		// Assert
		System.assertEquals('', result);
	}
	
	@isTest
	public static void testHasNamespace() {
		// Arrange
		// Nothing to do here
		
		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_RUNNER){
			result = TEST_NamespaceUtils.hasNamespace(TEST_SOBJECT);
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}
}