/**
 * @description       : to fetch the list of tasks the HR self assigned
 * @author            : Rudransh Shukla
 * @group             :
 * @last modified on  : 01-11-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class TaskController {
  @AuraEnabled(cacheable=true)
  public static list<task> getTaskList() {
    system.debug('start');
    list<task> taskList = new List<task>();
    for (task task : [
      SELECT Subject, Status, Type, ActivityDate, Priority, TaskSubtype,id
      FROM task
      WHERE status = 'Not Started' OR status = 'In Progress' limit 4
    ]) {
      taskList.add(task);
    }
    system.debug('tasklist-------->'+tasklist);
    return taskList;
  }
}
