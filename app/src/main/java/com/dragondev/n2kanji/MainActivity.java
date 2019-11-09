package com.dragondev.n2kanji;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.graphics.drawable.VectorDrawableCompat;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.content.res.ResourcesCompat;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Toast;

import com.dragondev.n2kanji.activity.AboutUsActivity;
import com.dragondev.n2kanji.activity.FavouriteActivity;
import com.dragondev.n2kanji.activity.SearchActivity;
import com.dragondev.n2kanji.fragment.DrawerFragment;
import com.dragondev.n2kanji.fragment.KanjiDetailFragment;
import com.dragondev.n2kanji.fragment.KanjiListFragment;
import com.dragondev.n2kanji.fragment.WordListFragment;
import com.dragondev.n2kanji.model.Kanji;
import com.dragondev.n2kanji.model.Word;
import com.dragondev.n2kanji.utils.DialogUtils;
import com.dragondev.n2kanji.utils.data.AppSharePreference;
import com.dragondev.n2kanji.utils.data.DatabaseHandler;
import com.dragondev.n2kanji.utils.font.MMFontUtils;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Nay Myo Htet on 10/12/2018.
 */

public class MainActivity extends AppCompatActivity implements KanjiListFragment.OnTapKanji, DrawerFragment.OnTapLesson {

    @BindView(R.id.toolbar)
    Toolbar toolbar;
    @BindView(R.id.drawer)
    DrawerLayout mDrawerLayout;
    @BindView(R.id.kanji_bar)
    View kanjiBar;

    DrawerFragment dFragment;

    KanjiDetailFragment kanjiDetailFragment;
    KanjiListFragment kanjiListFragment;
    WordListFragment wordListFragment;

    // System-wide storage helper
    public static DatabaseHandler dbHandler;
    public static AppSharePreference pref;

    private MMFontUtils mmFontUtils;

    private boolean isResume;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ButterKnife.bind(this);

        // Open database connection
        dbHandler = new DatabaseHandler(this);
        dbHandler.openDatabase();

        // create share preference
        pref = new AppSharePreference(this);

        // check myanmar font support for unicode or zawgyi
        mmFontUtils = new MMFontUtils(this);
        pref.setMyanmarFontSupportCode(mmFontUtils.detectMyanmarFontSupport());

        // Adding Toolbar to Main screen
        toolbar.setTitle("");
        setSupportActionBar(toolbar);


        // Adding menu icon to Toolbar
        ActionBar supportActionBar = getSupportActionBar();
        if (supportActionBar != null) {
            VectorDrawableCompat indicator
                    = VectorDrawableCompat.create(getResources(), R.drawable.ic_menu, getTheme());
            indicator.setTint(ResourcesCompat.getColor(getResources(), android.R.color.white, getTheme()));
            supportActionBar.setHomeAsUpIndicator(indicator);
            supportActionBar.setDisplayHomeAsUpEnabled(true);
        }

        // Check if we're running on Android 5.0 or higher
        if (Build.VERSION.SDK_INT >= 21) {
            kanjiBar.setVisibility(View.GONE);
        }

        dFragment = (DrawerFragment) getSupportFragmentManager().findFragmentById(R.id.drawer_fragment);
        dFragment.addDrawerItems();
        dFragment.setupDrawer(mDrawerLayout, toolbar);

        // bind fragments
        kanjiDetailFragment = new KanjiDetailFragment();
        kanjiListFragment = new KanjiListFragment();
        wordListFragment = new WordListFragment();

        FragmentManager manager = getSupportFragmentManager();
        FragmentTransaction transaction = manager.beginTransaction();

        transaction.add(R.id.frame_kanji_detail, kanjiDetailFragment);
        transaction.add(R.id.frame_kanji_list, kanjiListFragment);
        transaction.add(R.id.frame_word_list, wordListFragment);

        transaction.commit();

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        switch (item.getItemId()) {

            case R.id.action_search:
                startActivity(new Intent(this, SearchActivity.class));
                return true;

            case R.id.action_favourite:
                startActivity(new Intent(this, FavouriteActivity.class));
                return true;

            case R.id.action_about:
                startActivity(new Intent(this, AboutUsActivity.class));
                return true;

            case android.R.id.home:
                mDrawerLayout.openDrawer(GravityCompat.START);
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        // Close database connection
        dbHandler.closeDatabase();
    }


    @Override
    protected void onPostCreate(@Nullable Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);

        Log.d("N2Kanji", "onPostCreate..........");

        // show lesson by user selected last week and day
        showSelectedLesson(pref.getCurrentWeek(), pref.getCurrentDay(), pref.getCurrentPosition());
    }

    @Override
    public void showSelectedKanji(Kanji kanji) {
        List<Word> wordList = dbHandler.retrieveWord(kanji.getId());
        kanjiDetailFragment.showKanjiDetail(kanji);
        wordListFragment.updateWordList(wordList);
    }

    @Override
    public void showSelectedLesson(int week, int day, int position) {
        int days = (week - 1) * 7 + day;
        List<Kanji> kanjiList = dbHandler.retrieveKanji(days);
        if (kanjiList.size() > 0) {
            kanjiListFragment.updateKanjiList(kanjiList);
            showSelectedKanji(kanjiList.get(position));
        }
    }

    @Override
    protected void onPostResume() {
        super.onPostResume();

        if (isResume) {
            Log.d("N2Kanji", "onPostResume..........");

            // show lesson by user selected last week and day
            showSelectedLesson(pref.getCurrentWeek(), pref.getCurrentDay(), pref.getCurrentPosition());
            return;
        }

        isResume = true;
    }

    @Override
    public void onBackPressed() {

        if (mDrawerLayout.isDrawerOpen(Gravity.START)) {
            mDrawerLayout.closeDrawers();
        } else {
            DialogUtils.showExitDialog(this);
        }

        //  super.onBackPressed();
    }
}
