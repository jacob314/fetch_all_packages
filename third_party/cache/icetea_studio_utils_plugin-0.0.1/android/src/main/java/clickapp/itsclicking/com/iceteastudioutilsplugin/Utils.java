package clickapp.itsclicking.com.iceteastudioutilsplugin;

import android.content.Context;
import android.graphics.Color;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;

public class Utils {

    public static boolean isNullOrEmpty(String text) {
        return text == null || text.trim().length() < 1;
    }

    public static boolean convertStringToBoolean(String text) {
        if(!isNullOrEmpty(text)) {
            return Boolean.valueOf(text);
        }
        return false;
    }

    public static int getGravity(String gravity) {
        if(!isNullOrEmpty(gravity)) {
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
        if(!isNullOrEmpty(toastType) && toastType.equals("long")) {
            return Toast.LENGTH_LONG;
        }
        return Toast.LENGTH_SHORT;
    }

    public static void showToast(Context context, String msg, String backgroundColor,
                                 String textColor, int toastType, boolean isFullWith, int gravity) {
        if(context != null) {
            Toast toast = Toast.makeText(context, msg, toastType);
            ViewGroup toastLayout = (ViewGroup) toast.getView();

            if (toastLayout != null) {
                int actionBarHeight = getActionBarHeight(context);
                toastLayout.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, toastLayout.getHeight() < actionBarHeight ? actionBarHeight : ViewGroup.LayoutParams.WRAP_CONTENT));
                toastLayout.setBackgroundColor(Color.parseColor(backgroundColor));
                toastLayout.setPadding(20, 20, 20, 20);
                TextView textView = (TextView) toastLayout.getChildAt(0);
                if (textView != null) {
                    textView.setTextColor(Color.parseColor(textColor));
                }
            }

            toast.setGravity(isFullWith ? Gravity.FILL_HORIZONTAL | gravity : gravity, 0, 0);
            toast.show();
        }
    }

    public int getStatusBarHeight(Context context) {
        int result = 0;
        try {
            int resourceId = context.getResources().getIdentifier("status_bar_height", "dimen", "android");
            if (resourceId > 0) {
                result = context.getResources().getDimensionPixelSize(resourceId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    public static int getActionBarHeight(Context context) {
        int actionBarHeight = 0;
        try {
            TypedValue tv = new TypedValue();
            if (context.getTheme().resolveAttribute(android.R.attr.actionBarSize, tv, true)) {
                actionBarHeight = TypedValue.complexToDimensionPixelSize(tv.data, context.getResources().getDisplayMetrics());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return actionBarHeight;
    }
}
