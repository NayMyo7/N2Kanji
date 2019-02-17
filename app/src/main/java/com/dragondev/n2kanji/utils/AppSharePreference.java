package com.dragondev.n2kanji.utils;

import android.content.Context;
import android.content.SharedPreferences;

public class AppSharePreference {
    // Shared preferences file name
    private static final String PREF_NAME = "N2Kanji";
    private static final String FIRST_TIME = "FIRST_TIME";
    private static final String UNICODE_SUPPORT = "UNICODE_SUPPORT";

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

    //---------------------------- First Time ----------------------------
    public void setFirstTimeFlag(boolean isFirstTime) {
        editor.putBoolean(FIRST_TIME, isFirstTime).commit();
    }

    public boolean getIsFirstTime() {
        return pref.getBoolean(FIRST_TIME, true);
    }

    //---------------------------- Unicode Support ----------------------------
    public void setUnicodeSupportFlag(boolean isSupport) {
        editor.putBoolean(UNICODE_SUPPORT, isSupport).commit();
    }

    public boolean getIsUnicodeSupport() {
        return pref.getBoolean(UNICODE_SUPPORT, false);
    }

}
