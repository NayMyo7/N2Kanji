package com.dragondev.n2kanji.fragment;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.dragondev.n2kanji.MainActivity;
import com.dragondev.n2kanji.R;
import com.dragondev.n2kanji.adapter.KanjiAdapter;
import com.dragondev.n2kanji.model.Kanji;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.Unbinder;

/**
 * A simple {@link Fragment} subclass.
 */
public class KanjiListFragment extends Fragment implements KanjiAdapter.OnKanjiSelectedListener {

    @BindView(R.id.kanji_recycler_view)
    RecyclerView kanjiRecyclerView;

    private Unbinder unbinder;

    private KanjiAdapter kanjiAdapter;
    private LinearLayoutManager linearLayoutManager;
    private List<Kanji> kanjiList = new ArrayList<Kanji>();

    private OnTapKanji onTapKanji;

    public KanjiListFragment() {
        // Required empty public constructor
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_kanji_list, container, false);
        unbinder = ButterKnife.bind(this, view);

        kanjiAdapter = new KanjiAdapter(getActivity(), kanjiList, 0, this);
        kanjiRecyclerView.setAdapter(kanjiAdapter);

        linearLayoutManager = new LinearLayoutManager(getActivity(), LinearLayoutManager.HORIZONTAL, false);
        kanjiRecyclerView.setLayoutManager(linearLayoutManager);

        kanjiRecyclerView.setItemAnimator(new DefaultItemAnimator());

        return view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        onTapKanji = (OnTapKanji) getActivity();
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        unbinder.unbind();
    }

    @Override
    public void onKanjiSelected(Kanji kanji) {
        // send selected kanji to MainActivity
        onTapKanji.showSelectedKanji(kanji);
    }

    public void updateKanjiList(List<Kanji> kanjis) {
        boolean isChanges = false;

        if (kanjiList != null) {
            kanjiList.clear();
            isChanges = true;
        }

        for (Kanji kanji : kanjis) {
            kanjiList.add(kanji);
        }

        if (isChanges) {
            kanjiAdapter.notifyDataSetChanged();
        }
        kanjiAdapter.setActivePosition(0);
    }

    public interface OnTapKanji {
        void showSelectedKanji(Kanji kanji);
    }
}
