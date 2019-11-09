package com.dragondev.n2kanji.utils.data;

import android.content.Context;

import com.dragondev.n2kanji.R;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

/**
 * Created by Nay Myo Htet on 10/19/2017.
 */

public class ExpandableListDataSource {

    public static Map<String, List<String>> getData(Context context) {
        Map<String, List<String>> expandableListData = new TreeMap<>();

        List<String> main_content = Arrays.asList(context.getResources().getStringArray(R.array.main_content));

        List<String> day1_content = Arrays.asList(context.getResources().getStringArray(R.array.day1_content));
        List<String> day2_content = Arrays.asList(context.getResources().getStringArray(R.array.day2_content));
        List<String> day3_content = Arrays.asList(context.getResources().getStringArray(R.array.day3_content));
        List<String> day4_content = Arrays.asList(context.getResources().getStringArray(R.array.day4_content));
        List<String> day5_content = Arrays.asList(context.getResources().getStringArray(R.array.day5_content));
        List<String> day6_content = Arrays.asList(context.getResources().getStringArray(R.array.day6_content));
        List<String> day7_content = Arrays.asList(context.getResources().getStringArray(R.array.day7_content));
        List<String> day8_content = Arrays.asList(context.getResources().getStringArray(R.array.day8_content));

        expandableListData.put(main_content.get(0), day1_content);
        expandableListData.put(main_content.get(1), day2_content);
        expandableListData.put(main_content.get(2), day3_content);
        expandableListData.put(main_content.get(3), day4_content);
        expandableListData.put(main_content.get(4), day5_content);
        expandableListData.put(main_content.get(5), day6_content);
        expandableListData.put(main_content.get(6), day7_content);
        expandableListData.put(main_content.get(7), day8_content);

        return expandableListData;
    }
}
