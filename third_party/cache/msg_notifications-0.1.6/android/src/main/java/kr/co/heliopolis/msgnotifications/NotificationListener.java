package kr.co.heliopolis.msgnotifications;

import android.app.Notification;
import android.content.Intent;
import android.os.Bundle;
import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;
import android.util.Log;


/**
 * Notification listening service. Intercepts notifications if permission is given to do so.
 */
public class NotificationListener extends NotificationListenerService {

    public static String NOTIFICATION_INTENT = "notification_event";
    public static String NOTIFICATION_PACKAGE_NAME = "package_name";
    public static String NOTIFICATION_MESSAGE = "message";
    public static String NOTIFICATION_TITLE = "title";
    public static String NOTIFICATION_TICKER = "ticker";

    @Override
    public void onNotificationPosted(StatusBarNotification sbn)
    {

        String pack = sbn.getPackageName();
        String ticker = sbn.getNotification().tickerText.toString();
        Bundle extras = sbn.getNotification().extras;
        String title = extras.getString("android.title");
        String text = extras.getCharSequence("android.text").toString();


        Log.i(NOTIFICATION_PACKAGE_NAME,pack);
        Log.i(NOTIFICATION_TICKER,ticker);
        Log.i(NOTIFICATION_TITLE,title);
        Log.i(NOTIFICATION_MESSAGE,text);

        Intent msgrcv = new Intent(NOTIFICATION_INTENT);
        msgrcv.putExtra(NOTIFICATION_PACKAGE_NAME, pack);
        msgrcv.putExtra(NOTIFICATION_TICKER, ticker);
        msgrcv.putExtra(NOTIFICATION_TITLE, title);
        msgrcv.putExtra(NOTIFICATION_MESSAGE, text);

        sendBroadcast(msgrcv);
    }


}