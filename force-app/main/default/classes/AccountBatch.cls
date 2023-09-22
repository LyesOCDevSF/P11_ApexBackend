global class AccountBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, (SELECT Id FROM Orders), (SELECT Id FROM Tasks WHERE Subject = \'Call\') FROM Account WHERE Id NOT IN (SELECT AccountId FROM Order) AND Id NOT IN (SELECT WhatId FROM Task WHERE Subject = \'Call\')'
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Account> scope) {
        List<Task> tasksToInsert = new List<Task>();
        
        for(Account acc : scope) {
            if(acc.Orders.isEmpty() && acc.Tasks.isEmpty()) {
                Task reminderTask = new Task(
                    WhatId = acc.Id,
                    Subject = 'Call',
                    Status = 'Nouvelle',
                    Priority = 'Normale',
                    ActivityDate = Date.today().addDays(5) // Rappel dans 5 jours
                );
                tasksToInsert.add(reminderTask);
            }
        }

        if(!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        
    }
}
