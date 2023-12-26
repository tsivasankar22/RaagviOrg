trigger FASharingToUser on Financial_Account__c (after insert) {
    if(Trigger.isInsert){
        FASharingClass.shareFaToBroker(Trigger.new);
    }
}