@isTest
private class AccountBatchSchedulerTest {
    
    @isTest
    static void testAccountBatchScheduler() {
        
        // Créer des comptes sans commandes ni tâches
        List<Account> accounts = DataFactory.createAccounts(5);
        insert accounts;
        
        
        // Planifier l'exécution du batch via le scheduler
        Test.startTest();
        
        String kickStart = '0 0 0 15 10 ? 2023'; 
        String jobId = System.schedule('AccountBatchSchedulerTestJob', kickStart, new AccountBatchScheduler());
        
        Test.stopTest();
        
        // 3. Vérifier que le job a été planifié
        CronTrigger scheduledJob = [SELECT Id, kickStart, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(cronExpression, scheduledJob.kickStart);
        System.assertEquals(1, scheduledJob.TimesTriggered); 
        
       
    }
}
