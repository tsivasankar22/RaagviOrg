trigger FileAttachmentUpdateTrigger on ContentVersion (before insert,before update) {
       if(trigger.isBefore)
    {
        Fileupadate.AttachmentFile(trigger.new);
    }
}