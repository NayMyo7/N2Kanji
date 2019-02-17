package com.dragondev.n2kanji;

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
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Toast;

import com.dragondev.n2kanji.fragment.DrawerFragment;
import com.dragondev.n2kanji.fragment.KanjiDetailFragment;
import com.dragondev.n2kanji.fragment.KanjiListFragment;
import com.dragondev.n2kanji.fragment.WordListFragment;
import com.dragondev.n2kanji.model.Kanji;
import com.dragondev.n2kanji.model.Word;
import com.dragondev.n2kanji.utils.AppSharePreference;
import com.dragondev.n2kanji.utils.DatabaseHandler;
import com.dragondev.n2kanji.utils.MMBindFontUtils;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Nay Myo Htet on 10/12/2018.
 */

public class MainActivity extends AppCompatActivity implements KanjiListFragment.OnTapKanji, DrawerFragment.OnTapLesson {

    // System-wide storage helper
    private DatabaseHandler dbHandler;

    private AppSharePreference pref;

    @BindView(R.id.drawer)
    DrawerLayout mDrawerLayout;

    DrawerFragment dFragment;

    KanjiDetailFragment kanjiDetailFragment;
    KanjiListFragment kanjiListFragment;
    WordListFragment wordListFragment;

    private List<Kanji> kanjiList;

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

        // Adding Toolbar to Main screen
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        // Adding menu icon to Toolbar
        ActionBar supportActionBar = getSupportActionBar();
        if (supportActionBar != null) {
            VectorDrawableCompat indicator
                    = VectorDrawableCompat.create(getResources(), R.drawable.ic_menu, getTheme());
            indicator.setTint(ResourcesCompat.getColor(getResources(), R.color.white, getTheme()));
            supportActionBar.setHomeAsUpIndicator(indicator);
            supportActionBar.setDisplayHomeAsUpEnabled(true);
        }

        dFragment = (DrawerFragment) getSupportFragmentManager().findFragmentById(R.id.drawer_fragment);
        dFragment.addDrawerItems();
        dFragment.setupDrawer(mDrawerLayout);


        // bind fragments
        kanjiDetailFragment = new KanjiDetailFragment();
        kanjiListFragment = new KanjiListFragment();
        wordListFragment = new WordListFragment();

        // check myanmar unicode support
        if (pref.getIsFirstTime()) {
            MMBindFontUtils.checkMyanmarUnicodeSupport(this);
            pref.setFirstTimeFlag(false);
        }
        Toast.makeText(this, "Unicode support : " + pref.getIsUnicodeSupport(), Toast.LENGTH_SHORT).show();

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

            case R.id.action_settings:
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
        // show the first week, day 1 lesson
        showSelectedLesson(1, 1);
    }

    @Override
    public void showSelectedKanji(Kanji kanji) {
        List<Word> wordList = dbHandler.retrieveWord(kanji.getId());
        kanjiDetailFragment.showKanjiDetail(kanji);
        wordListFragment.updateWordList(wordList);
    }

    @Override
    public void showSelectedLesson(int week, int day) {
        int days = (week - 1) * 7 + day;
        List<Kanji> kanjiList = dbHandler.retrieveKanji(days);
        if (kanjiList.size() > 0) {
            kanjiListFragment.updateKanjiList(kanjiList);
            showSelectedKanji(kanjiList.get(0));
        }
    }
}
