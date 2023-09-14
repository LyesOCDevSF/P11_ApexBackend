global class  AccountBatch {
     
        global Database.QueryLocator start(Database.BatchableContext ) {
            return Database.getQueryLocator();
        }
    
        global void execute(Database.BatchableContext ) {
            
        }
    
        global void finish(Database.BatchableContext ) {
            
        }
    }
    
