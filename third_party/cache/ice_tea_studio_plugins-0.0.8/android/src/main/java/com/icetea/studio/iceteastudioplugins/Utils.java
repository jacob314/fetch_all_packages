package com.icetea.studio.iceteastudioplugins;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.util.Log;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;

public class Utils {

    private static final int TOAST_MARGIN_HORIZONTAL = 20;
    private static final int TOAST_PADDING_VERTICAL = 40;
    private static final int TOAST_PADDING_HORIZONTAL = 60;

    public static boolean isNullOrEmpty(String text) {
        return text == null || text.trim().length() < 1;
    }

    public static boolean convertStringToBoolean(String text) {
        if (!isNullOrEmpty(text)) {
            return Boolean.valueOf(text);
        }
        return false;
    }

    public static int getGravity(String gravity) {
        if (!isNullOrEmpty(gravity)) {
            switch (gravity) {
                case "top":
                    return Gravity.TOP;
                case "center":
                    return Gravity.CENTER;
            }
        }
        return Gravity.BOTTOM;
    }

    public static int getToastType(String toastType) {
        if (!isNullOrEmpty(toastType) && toastType.equals("long")) {
            return Toast.LENGTH_LONG;
        }
        return Toast.LENGTH_SHORT;
    }

    public static int getScreenWidth() {
        return Resources.getSystem().getDisplayMetrics().widthPixels;
    }

    public static void showToast(Context context, String msg, String backgroundColor,
                                 String textColor, int textSize, int toastType,
                                 boolean isFullWith, int gravity) {
        if (context != null) {
            Toast toast = Toast.makeText(context, msg, toastType);
            ViewGroup toastLayout = (ViewGroup) toast.getView();

            if (toastLayout != null) {
                toastLayout.setBackgroundColor(Color.TRANSPARENT);
//                toastLayout.setPadding(0, 0, 0, 0);

                TextView textView = (TextView) toastLayout.getChildAt(0);

                if (textView != null) {
                    textView.setPadding(
                            TOAST_PADDING_HORIZONTAL,
                            TOAST_PADDING_VERTICAL - 10,
                            TOAST_PADDING_HORIZONTAL,
                            TOAST_PADDING_VERTICAL
                    );

                    if(isFullWith) {
                        int width = getScreenWidth();
//                        Log.d("getScreenWidth:", width + "");
                        if(width > 0) {
                            textView.setWidth(width);
                        }
                    }

                    textView.setTextSize(textSize);
                    textView.setGravity(Gravity.CENTER);
                    textView.setTextColor(Color.parseColor(textColor));

                    GradientDrawable shape =  new GradientDrawable();
                    shape.setCornerRadius(25);
                    shape.setColor(Color.parseColor(backgroundColor));
                    textView.setBackground(shape);
                }

            }

            toast.setGravity(isFullWith ? Gravity.FILL_HORIZONTAL | gravity : gravity, 0, 0);
            toast.show();
        }
    }


}
