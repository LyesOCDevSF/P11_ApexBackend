@isTest
private class OrderServiceTriggerTests {

    @isTest
    static void testOrderActivationWithNoProduct() {
        // Génére des données de test
        List<Account> testAccounts = DataFactory.createAccounts(1);
        insert testAccounts;
        
        List<Order> testOrders = DataFactory.createOrders(1, testAccounts[0].Id);
        insert testOrders;
        
        
        // Active l'Order sans produit
        testOrders[0].Status = 'Activated';
        Test.startTest();
        Database.SaveResult sr = Database.update(testOrders[0], false);
        Test.stopTest();
        
        // Vérifie que l'erreur est bien ajoutée
        System.assert(!sr.isSuccess());
        System.assertEquals('Une commande doit inclure au moins un produit.', sr.getErrors()[0].getMessage());
    }
    
    @isTest
    static void testOrderDeletionWithNoOtherOrder() {
        // Génére des données de test
        List<Account> testAccounts = DataFactory.createAccounts(1);
        insert testAccounts;
        
        // Contrôle que le champ Active__c est coché
        testAccounts[0].Actif__c = true;
        update testAccounts[0];
        
        List<Order> testOrders = DataFactory.createOrders(1, testAccounts[0].Id);
        insert testOrders;
        
        // Supprime la commande
        Test.startTest();
        delete testOrders[0];
        Test.stopTest();
        
        // Vérifie que le champ Active__c est décoché
        Account updatedAccount = [SELECT Actif__c FROM Account WHERE Id = :testAccounts[0].Id];
        System.assertEquals(false, updatedAccount.Actif__c);
    }

    
}
