import 'dart:collection';

class ActionManager {
  static Map<String, dynamic> actionList = new HashMap<String, Object>();

  static void createAction(actionId, dynamic actionDetail) {
    actionList[actionId] = () {
      actionDetail();
    };
  }

  static void callAction(String actionId) {
    if(actionList[actionId]==null){
      return;
    }
    actionList[actionId]();
  }

  static String currentDocumentID;
}
