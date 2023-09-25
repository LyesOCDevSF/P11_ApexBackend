@isTest
private class AccountBatchTests {

    @isTest
    static void testBatchCreatesReminderTasks() {
        // Génére des données de test
        List<Account> testAccounts = DataFactory.createAccounts(2);
        insert testAccounts;
        
        // Laisse un compte avec un order et l'autre sans
        List<Order> testOrders = DataFactory.createOrders(1, testAccounts[0].Id);
        insert testOrders;
        
        Test.startTest();
        AccountBatch batch = new AccountBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        
        // Vérifie que seulement le compte sans order a reçu une tâche de rappel
        Task[] tasks = [SELECT WhatId FROM Task WHERE Subject = 'Call'];
        System.assertEquals(1, tasks.size());
        System.assertEquals(testAccounts[1].Id, tasks[0].WhatId);
    }
}
