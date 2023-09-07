trigger OrderTrigger on Order (before insert, before update) {

    // collecter tout les id des order 
    Set<Id> orderIds = new Set<Id>();
    
    for(Order ord : Trigger.new){
        orderIds = add(ord.Id);
    }

    // appel de la classe de service pour avoir les OrderId associé avec des orderItems
    Set<Id> orderWithItems = OrderService.getOrderWithItems(orderIds);

    //Controle du statut si commande a un orderitem associé avant mis a jour 
    for(Order ord: Trigger.new){
        if(orderWithItems.contains(orderIds)){
            Status = 'Activated';
        }
        else{
            if(ord.Status == 'Activated'){
                ord.addError('La commande doit avoir au moins un orderItem associé');
            }
        }
    }
}