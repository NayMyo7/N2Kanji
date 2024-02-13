package com.dragondev.n2kanji.activity;

import android.os.Bundle;
import androidx.core.app.NavUtils;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.DefaultItemAnimator;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.appcompat.widget.Toolbar;
import android.view.MenuItem;

import com.dragondev.n2kanji.MainActivity;
import com.dragondev.n2kanji.R;
import com.dragondev.n2kanji.adapter.WordAdapter;
import com.dragondev.n2kanji.model.Word;

import java.util.ArrayList;

import butterknife.BindView;
import butterknife.ButterKnife;

public class FavouriteActivity extends AppCompatActivity {

    @BindView(R.id.toolbar)
    Toolbar toolbar;
    @BindView(R.id.word_recycler_view)
    RecyclerView wordRecyclerView;

    ArrayList<Word> allWordList;
    WordAdapter wordAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_favourite);
        ButterKnife.bind(this);

        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        allWordList = MainActivity.dbHandler.retrieveFavouriteWord();
        wordAdapter = new WordAdapter(getApplicationContext(), allWordList, 0);

        wordRecyclerView.setAdapter(wordAdapter);


        wordRecyclerView.setLayoutManager(new LinearLayoutManager(this));

        wordRecyclerView.setItemAnimator(new DefaultItemAnimator());
        wordRecyclerView.addItemDecoration(new DividerItemDecoration(this, DividerItemDecoration.VERTICAL));
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        switch (item.getItemId()) {
            case android.R.id.home:
                NavUtils.navigateUpFromSameTask(this);
                return true;
        }

        return super.onOptionsItemSelected(item);
    }
}
