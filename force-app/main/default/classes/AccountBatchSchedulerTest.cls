@isTest
private class AccountBatchSchedulerTest {
    
    @isTest
    static void testAccountBatchScheduler() {
        
        // Créer des comptes sans commandes ni tâches
        List<Account> accounts = DataFactory.createAccounts(5);
        insert accounts;
        
        
        // Planifier l'exécution du batch via le scheduler
        Test.startTest();
        
        String cronExpression = '0 0 * * * ?';
        String jobId = System.schedule('AccountBatchSchedulerTestJob', cronExpression, new AccountBatchScheduler());
        
        Test.stopTest();
        
        // Vérifier que le job a été prévue
        //CronTrigger scheduledJob = [SELECT Id, cronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
      // System.assertEquals(cronExpression, scheduledJob.cronExpression);
       //System.assertEquals(1, scheduledJob.TimesTriggered); 
        
        Integer scheduledJobsCount = [SELECT COUNT() FROM CronTrigger WHERE Id = :jobId AND State = 'WAITING'];
        System.assertEquals(1, scheduledJobsCount);
    }
}
