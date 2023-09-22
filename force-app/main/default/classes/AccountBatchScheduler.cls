global class AccountBatchScheduler implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        AccountBatch batch = new AccountBatch();
        Database.executeBatch(batch);
    }
}
