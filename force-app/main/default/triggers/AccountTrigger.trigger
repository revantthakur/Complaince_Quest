trigger AccountTrigger on Account (after insert,after update) {
  if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            AccountTriggerHandler.triggerOnInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            AccountTriggerHandler.triggerOnUpdate(Trigger.newMap);
        }
    }
}