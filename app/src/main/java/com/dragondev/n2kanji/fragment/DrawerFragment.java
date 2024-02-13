package com.dragondev.n2kanji.fragment;


import android.graphics.Color;
import android.graphics.Typeface;
import android.os.Bundle;
import androidx.fragment.app.Fragment;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.appcompat.app.ActionBarDrawerToggle;
import androidx.appcompat.widget.Toolbar;
import android.text.TextPaint;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ExpandableListAdapter;
import android.widget.ExpandableListView;
import android.widget.TextView;

import com.dragondev.n2kanji.MainActivity;
import com.dragondev.n2kanji.R;
import com.dragondev.n2kanji.adapter.CustomExpandableListAdapter;
import com.dragondev.n2kanji.utils.data.ExpandableListDataSource;
import com.dragondev.n2kanji.utils.FuriganaUtil;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by Nay Myo Htet on 10/19/2017.
 */

public class DrawerFragment extends Fragment {
    DrawerLayout mDrawer;
    ActionBarDrawerToggle mToggle;
    Toolbar tBar;
    TextView tv;
    TextPaint tp;


    ExpandableListView mExpandableListView;
    ExpandableListAdapter mExpandableListAdapter;
    List<String> mExpandableListTitle;
    Map<String, List<String>> mExpandableListData;

    int lastExpandPosition = -1;
    int selectedIndex = 1;
    int mWeek = 0, mDay = 0, mPosition = 1;

    private OnTapLesson onTapLesson;

    public DrawerFragment() {
        // Required empty public constructor
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_drawer, container, false);
        mExpandableListView = (ExpandableListView) v.findViewById(R.id.nav_List);

        onTapLesson = (OnTapLesson) getActivity();

        tv = new TextView(getActivity());
        tv.setTextAppearance(getActivity(), android.R.style.TextAppearance_DeviceDefault_Medium);
        tp = tv.getPaint();
        tp.setColor(Color.WHITE);
        tp.setTypeface(Typeface.DEFAULT_BOLD);

        return v;
    }


    public void setupDrawer(DrawerLayout drawer, Toolbar toolbar) {
        tBar = toolbar;
        mDrawer = drawer;
        mToggle = new ActionBarDrawerToggle(getActivity(), mDrawer, tBar, R.string.drawer_open, R.string.drawer_close) {
            @Override
            public void onDrawerOpened(View drawerView) {
                super.onDrawerOpened(drawerView);
                mExpandableListView.expandGroup(mWeek == 0 ? mWeek : mWeek - 1);
                mExpandableListView.setItemChecked(selectedIndex, true);

            }

            @Override
            public void onDrawerClosed(View drawerView) {
                super.onDrawerClosed(drawerView);
            }
        };
        mDrawer.setDrawerListener(mToggle);
        mDrawer.post(new Runnable() {
            @Override
            public void run() {
                mToggle.syncState();
            }
        });

        mWeek = MainActivity.pref.getCurrentWeek();
        mDay = MainActivity.pref.getCurrentDay();
        mPosition = MainActivity.pref.getCurrentPosition();
        selectedIndex = MainActivity.pref.getCurrentIndex();

        setupTitle();
    }

    public void addDrawerItems() {
        mExpandableListData = ExpandableListDataSource.getData(getActivity());
        mExpandableListTitle = new ArrayList(mExpandableListData.keySet());

        mExpandableListAdapter = new CustomExpandableListAdapter(getActivity(), mExpandableListTitle, mExpandableListData);
        mExpandableListView.setAdapter(mExpandableListAdapter);

        mExpandableListView.setOnGroupExpandListener(new ExpandableListView.OnGroupExpandListener() {
            @Override
            public void onGroupExpand(int groupPosition) {
                if (lastExpandPosition != -1 && lastExpandPosition != groupPosition) {
                    mExpandableListView.collapseGroup(lastExpandPosition);
                }
                lastExpandPosition = groupPosition;

                //Checked the current group is current mWeek to ensure selected item
                if (mWeek == groupPosition + 1)
                    mExpandableListView.setItemChecked(selectedIndex, true);
                else
                    mExpandableListView.setItemChecked(selectedIndex, false);
            }
        });

        mExpandableListView.setOnGroupCollapseListener(new ExpandableListView.OnGroupCollapseListener() {
            @Override
            public void onGroupCollapse(int groupPosition) {

            }
        });

        mExpandableListView.setOnChildClickListener(new ExpandableListView.OnChildClickListener() {
            @Override
            public boolean onChildClick(ExpandableListView parent, View v, int groupPosition, int childPosition, long id) {

                //Get mWeek and mDay for expandable list
                mWeek = groupPosition + 1;
                mDay = childPosition + 1;

                if (mWeek == MainActivity.pref.getCurrentWeek() &&
                        mDay == MainActivity.pref.getCurrentDay()) {
                    mDrawer.closeDrawers();
                    return false;
                }

                selectedIndex = parent.getFlatListPosition(ExpandableListView
                        .getPackedPositionForChild(groupPosition, childPosition));
                parent.setItemChecked(selectedIndex, true);


                MainActivity.pref.setCurrentIndex(selectedIndex);
                MainActivity.pref.setCurrentPosition(0);


                MainActivity.pref.setCurrentWeek(mWeek);
                MainActivity.pref.setCurrentDay(mDay);

                setupTitle();
                onTapLesson.showSelectedLesson(mWeek, mDay, MainActivity.pref.getCurrentPosition());

                mDrawer.closeDrawers();
                return false;
            }
        });
    }

    private void setupTitle() {
        String mTitle = mExpandableListAdapter.getChild(mWeek - 1, mDay - 1).toString();
        if (mDay == 1) {
            mTitle = mTitle.substring(9, mTitle.length());
        } else {
            mTitle = mTitle.substring(8, mTitle.length());
        }
        mTitle = mWeek + "-" + mDay + " " + mTitle;
        tBar.setTitle(FuriganaUtil.getOriginalText(mTitle));
    }

    public interface OnTapLesson {
        void showSelectedLesson(int week, int day, int position);
    }

}
