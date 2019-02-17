package com.dragondev.n2kanji.fragment;


import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.DividerItemDecoration;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.dragondev.n2kanji.MainActivity;
import com.dragondev.n2kanji.R;
import com.dragondev.n2kanji.adapter.WordAdapter;
import com.dragondev.n2kanji.model.Kanji;
import com.dragondev.n2kanji.model.Word;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.Unbinder;

/**
 * A simple {@link Fragment} subclass.
 */
public class WordListFragment extends Fragment {

    @BindView(R.id.word_recycler_view)
    RecyclerView wordRecyclerView;

    private RecyclerView.LayoutManager layoutManager;
    private List<Word> wordList = new ArrayList<Word>();
    private WordAdapter wordAdapter;

    private Unbinder unbinder;


    public WordListFragment() {
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_word_list, container, false);
        unbinder = ButterKnife.bind(this, view);

        wordAdapter = new WordAdapter(getActivity(), wordList, 0);
        wordRecyclerView.setAdapter(wordAdapter);

        layoutManager = new LinearLayoutManager(getActivity());
        wordRecyclerView.setLayoutManager(layoutManager);

        wordRecyclerView.setItemAnimator(new DefaultItemAnimator());
        wordRecyclerView.addItemDecoration(new DividerItemDecoration(getActivity(), DividerItemDecoration.VERTICAL));

        return view;
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        unbinder.unbind();
    }

    public void updateWordList(List<Word> words) {
        boolean isChanges = false;

        if (wordList != null) {
            wordList.clear();
            isChanges = true;
        }

        for (Word w : words) {
            wordList.add(w);
        }

        if (isChanges) {
            wordAdapter.notifyDataSetChanged();
        }

    }

}
