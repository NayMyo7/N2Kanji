package com.dragondev.n2kanji.utils.data;

import android.content.Context;
import android.content.SharedPreferences;

import com.dragondev.n2kanji.utils.font.Fonts;

public class AppSharePreference {
    // Shared preferences file name
    private static final String PREF_NAME = "N2Kanji";

    private static final String MYANMAR_FONT_SUPPORT_CODE = "MYANMAR_FONT_CODE";

    private static final String WEEK = "WEEK";
    private static final String DAY = "DAY";
    private static final String POSITION = "POSITION";
    private static final String INDEX = "INDEX";

    // Shared Preferences
    public static SharedPreferences pref;
    SharedPreferences.Editor editor;
    public static Context mContext;

    //---------------------------- Constructor ----------------------------
    public AppSharePreference(Context context) {
        this.mContext = context;
        pref = mContext.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
        editor = pref.edit();
    }

    //---------------------------- Myanmar Font Support Code ----------------------------
    public void setMyanmarFontSupportCode(int code) {
        editor.putInt(MYANMAR_FONT_SUPPORT_CODE, code).commit();
    }

    public int getMyanmarFontSupportCode() {
        return pref.getInt(MYANMAR_FONT_SUPPORT_CODE, Fonts.UNICODE);
    }

    //---------------------------- Week ----------------------------
    public void setCurrentWeek(int week) {
        editor.putInt(WEEK, week).commit();
    }

    public int getCurrentWeek() {
        return pref.getInt(WEEK, 1);
    }

    //---------------------------- Day ----------------------------
    public void setCurrentDay(int day) {
        editor.putInt(DAY, day).commit();
    }

    public int getCurrentDay() {
        return pref.getInt(DAY, 1);
    }

    //---------------------------- Position ----------------------------
    public void setCurrentPosition(int position) {
        editor.putInt(POSITION, position).commit();
    }

    public int getCurrentPosition() {
        return pref.getInt(POSITION, 0);
    }

    //---------------------------- Index ----------------------------
    public void setCurrentIndex(int index) {
        editor.putInt(INDEX, index).commit();
    }

    public int getCurrentIndex() {
        return pref.getInt(INDEX, 1);
    }

}
