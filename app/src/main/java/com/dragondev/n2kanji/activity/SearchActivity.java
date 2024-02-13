package com.dragondev.n2kanji.activity;

import androidx.core.app.NavUtils;
import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;
import androidx.recyclerview.widget.DefaultItemAnimator;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.appcompat.widget.Toolbar;

import com.arlib.floatingsearchview.FloatingSearchView;
import com.dragondev.n2kanji.MainActivity;
import com.dragondev.n2kanji.R;
import com.dragondev.n2kanji.adapter.WordAdapter;
import com.dragondev.n2kanji.model.Word;

import java.util.ArrayList;

import butterknife.BindView;
import butterknife.ButterKnife;

public class SearchActivity extends AppCompatActivity implements FloatingSearchView.OnQueryChangeListener, FloatingSearchView.OnHomeActionClickListener {

    @BindView(R.id.toolbar)
    Toolbar toolbar;

    @BindView(R.id.word_recycler_view)
    RecyclerView wordRecyclerView;

    @BindView(R.id.floating_search_view)
    FloatingSearchView searchView;

    ArrayList<Word> allWordList;
    WordAdapter wordAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_search);

        ButterKnife.bind(this);

        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(false);

        searchView.setOnQueryChangeListener(this);
        searchView.setOnHomeActionClickListener(this);

        allWordList = MainActivity.dbHandler.retrieveAllWord();
        wordAdapter = new WordAdapter(getApplicationContext(), allWordList, 0);

        wordRecyclerView.setAdapter(wordAdapter);


        wordRecyclerView.setLayoutManager(new LinearLayoutManager(this));

        wordRecyclerView.setItemAnimator(new DefaultItemAnimator());
        wordRecyclerView.addItemDecoration(new DividerItemDecoration(this, DividerItemDecoration.VERTICAL));
    }

    @Override
    public void onSearchTextChanged(String oldQuery, String newQuery) {
        wordAdapter.getFilter().filter(newQuery);
    }

    @Override
    public void onHomeClicked() {
        NavUtils.navigateUpFromSameTask(this);
    }
}
