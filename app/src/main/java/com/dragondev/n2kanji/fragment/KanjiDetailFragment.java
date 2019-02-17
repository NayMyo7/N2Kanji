package com.dragondev.n2kanji.fragment;


import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.dragondev.n2kanji.R;
import com.dragondev.n2kanji.model.Kanji;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.Unbinder;

/**
 * A simple {@link Fragment} subclass.
 */
public class KanjiDetailFragment extends Fragment {
    @BindView(R.id.tv_title_kanji)
    TextView tvTitleKanji;

    @BindView(R.id.tv_title_onyoumi)
    TextView tvTitleOnyomi;

    @BindView(R.id.tv_title_kunyomi)
    TextView tvTitleKunyomi;

    private Unbinder unbinder;


    public KanjiDetailFragment() {
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_kanji_detail, container, false);
        unbinder = ButterKnife.bind(this, view);

        return view;
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        unbinder.unbind();
    }

    public void showKanjiDetail(Kanji kanji) {
        tvTitleKanji.setText(kanji.getKanji());
        tvTitleOnyomi.setText(kanji.getOnyomi());
        tvTitleKunyomi.setText(kanji.getKunyomi());
    }
}
