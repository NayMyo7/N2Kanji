package com.dragondev.n2kanji.adapter;

import android.content.Context;
import android.graphics.Typeface;
import android.text.TextPaint;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.TextView;

import com.dragondev.n2kanji.R;

import java.util.List;
import java.util.Map;

import ee.yutani.furiganaview.FuriganaView;

/**
 * Created by Nay Myo Htet on 10/19/2017.
 */

public class CustomExpandableListAdapter extends BaseExpandableListAdapter {
    private Context mContext;
    private List<String> listTitle;
    private Map<String, List<String>> listDetail;
    private LayoutInflater mInflater;

    private TextView tv;
    private TextPaint tp;

    public CustomExpandableListAdapter(Context mContext, List<String> listTitle, Map<String, List<String>> listDetail) {
        this.mContext = mContext;
        this.listTitle = listTitle;
        this.listDetail = listDetail;
        this.mInflater = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        tv = new TextView(mContext);
        tv.setTextAppearance(mContext, android.R.style.TextAppearance_DeviceDefault_Small);
        tp = tv.getPaint();
        //  tp.setColor(Color.WHITE);
    }

    @Override
    public int getGroupCount() {
        return listTitle.size();
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        return listDetail.get(listTitle.get(groupPosition)).size();
    }

    @Override
    public Object getGroup(int groupPosition) {
        return listTitle.get(groupPosition);
    }

    @Override
    public Object getChild(int groupPosition, int childPosition) {
        return listDetail.get(listTitle.get(groupPosition)).get(childPosition);
    }

    @Override
    public long getGroupId(int groupPosition) {
        return groupPosition;
    }

    @Override
    public long getChildId(int groupPosition, int childPosition) {
        return childPosition;
    }

    @Override
    public boolean hasStableIds() {
        return false;
    }

    @Override
    public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
        String listTitle = (String) getGroup(groupPosition);
        if (convertView == null) {
            convertView = mInflater.inflate(R.layout.list_group, null);
        }
        FuriganaView listTitleFuri = (FuriganaView) convertView.findViewById(R.id.listTitle);
        tp.setTypeface(Typeface.DEFAULT_BOLD);
        listTitleFuri.text_set(tp, listTitle, 0, 0);
        return convertView;
    }

    @Override
    public View getChildView(int groupPosition, int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {
        final String expandedListText = (String) getChild(groupPosition, childPosition);
        if (convertView == null) {
            convertView = mInflater.inflate(R.layout.list_item, null);
        }
        FuriganaView expandedListTextView = (FuriganaView) convertView.findViewById(R.id.expandedListItem);
        tp.setTypeface(Typeface.DEFAULT);
        expandedListTextView.text_set(tp, expandedListText, 0, 0);
        return convertView;
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return true;
    }
}
