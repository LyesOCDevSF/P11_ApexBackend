trigger OrderTrigger on Order (before update, after delete) {

   
    /*//preciser update 
    Order currentOrder = Trigger.new[0];
    Boolean orderHasNoProduct = OrderService.orderWithNoProduct(currentOrder.Id);

   if(currentOrder.Status == 'Activated' && orderHasNoProduct){
    currentOrder.addError('La commande doit avoir au moins un orderItem associé');
   }

   if(Trigger.isAfter && Trigger.isDelete){
   Order deletedOrder = Trigger.old[0];
    Id associatedAccountId = deletedOrder.AccountId;
    
    if (associatedAccountId != null) {
        OrderService.deactivateAccountIfNoOrders(associatedAccountId);
    }

   }*/
   OrderService.verifyOrderProducts(Trigger.new, Trigger.oldMap);

    }
