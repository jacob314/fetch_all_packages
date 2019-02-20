package com.dibi.phonecalllog;

import java.util.HashMap;

class CallRecord {

    CallRecord() {}

    String name;
    String number;
    String callType;
    String date;
    long duration;

    HashMap<String, Object> toMap() {
        HashMap<String, Object> recordMap = new HashMap<>();
        recordMap.put("name", name);
        recordMap.put("number", number);
        recordMap.put("callType", callType);
        recordMap.put("date", date);
        recordMap.put("duration", duration);
        return recordMap;
    }
}
