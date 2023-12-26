trigger AttachFileCaseObject on Case (before insert) {
    if(Trigger.isBefore)
    {
        UploadFileCaseObject.FileAttachment();
    }

}