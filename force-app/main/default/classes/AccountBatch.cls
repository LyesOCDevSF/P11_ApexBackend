global class AccountBatch implements Database.Batchable<sObject> {

    // Ces ensembles vont stocker les IDs des comptes avec des commandes et des tâches
    private Set<Id> accountIdsWithOrders;
    private Set<Id> accountIdsWithCallTasks;

    // Le constructeur pour initialiser les sets
    global AccountBatch() {
        // Récupère les ID de compte ayant une commande
        accountIdsWithOrders = new Map<Id, Order>([SELECT AccountId FROM Order]).keySet();
        
        // Récupère les ID de compte ayant une tâche avec le sujet 'Call'
        accountIdsWithCallTasks = new Map<Id, Task>([SELECT WhatId FROM Task WHERE Subject = 'Call' AND WhatId != null]).keySet();
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // Utilisation des sets pour filtrer les comptes à traiter
        return Database.getQueryLocator([
            SELECT Id, (SELECT Id FROM Orders), (SELECT Id FROM Tasks WHERE Subject = 'Call')
            FROM Account 
            WHERE Id NOT IN :accountIdsWithOrders AND Id NOT IN :accountIdsWithCallTasks
        ]);
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
