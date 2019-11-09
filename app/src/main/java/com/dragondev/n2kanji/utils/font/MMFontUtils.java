package com.dragondev.n2kanji.utils.font;

import android.content.Context;
import android.graphics.Paint;
import android.view.ViewGroup;
import android.widget.TextView;


public class MMFontUtils {

    private Context mContext;

    public MMFontUtils(Context mContext) {
        this.mContext = mContext;
    }

    public int detectMyanmarFontSupport() {
        if (isUnicodeSupport()) {
            return Fonts.UNICODE;
        } else if (isUnicodeEmbedSupport()) {
            return Fonts.UNICODE_EMBED;
        } else if (isZawgyiSupport()) {
            return Fonts.ZAWGYI;
        } else {
            return Fonts.ZAWGYI_EMBED;
        }
    }

    public boolean isUnicodeSupport() {
        Paint paint = new Paint();
        return paint.measureText("\u1000\u1039\u1000") < paint.measureText("\u1000") + paint.measureText("\u1000") / 3;
    }

    public boolean isUnicodeEmbedSupport() {

        TextView textView1 = new TextView(mContext, null);
        TextView textView2 = new TextView(mContext, null);
        TextView textView3 = new TextView(mContext, null);
        TextView textView4 = new TextView(mContext, null);

        textView1.setTypeface(FontCache.get(Fonts.MYANMAR3, mContext));
        textView2.setTypeface(FontCache.get(Fonts.MYANMAR3, mContext));
        textView3.setTypeface(FontCache.get(Fonts.MYANMAR3, mContext));
        textView4.setTypeface(FontCache.get(Fonts.MYANMAR3, mContext));

        textView1.setText("\u1019\u1002");
        textView1.measure(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        int widthOne = textView1.getMeasuredWidth();

        textView2.setText("\u1019\u1004\u103A\u1039\u1002");
        textView2.measure(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        int widthTwo = textView2.getMeasuredWidth();

        textView3.setText("\u1000");
        textView3.measure(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        int widthThree = textView3.getMeasuredWidth();

        textView4.setText("\u1000\u1039\u1000");
        textView4.measure(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        int widthFour = textView4.getMeasuredWidth();

        return widthOne == widthTwo && widthThree == widthFour;

    }

    public boolean isZawgyiSupport() {

        Paint paint = new Paint();
        return paint.measureText("\u1044") + paint.measureText("\u1044") < paint.measureText("\u104E");

    }


}
