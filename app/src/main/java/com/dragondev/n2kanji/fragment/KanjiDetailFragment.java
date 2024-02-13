package com.dragondev.n2kanji.fragment;


import android.os.Build;
import android.os.Bundle;
import androidx.fragment.app.Fragment;
import android.text.TextUtils;
import android.text.method.ScrollingMovementMethod;
import android.view.LayoutInflater;
import android.view.MotionEvent;
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

        // Check if we're running on Android 5.0 or higher
        if (Build.VERSION.SDK_INT < 21) {
            tvTitleOnyomi.setPadding(0, 4, 0, 0);
            tvTitleKunyomi.setPadding(0, 4, 0, 0);
        }

        tvTitleOnyomi.setMovementMethod(new ScrollingMovementMethod());
        tvTitleKunyomi.setMovementMethod(new ScrollingMovementMethod());

        tvTitleOnyomi.setOnTouchListener(new View.OnTouchListener() {

            @Override
            public boolean onTouch(View v, MotionEvent event) {

                tvTitleOnyomi.getParent().requestDisallowInterceptTouchEvent(true);

                return false;
            }
        });

        tvTitleKunyomi.setOnTouchListener(new View.OnTouchListener() {

            @Override
            public boolean onTouch(View v, MotionEvent event) {

                tvTitleKunyomi.getParent().requestDisallowInterceptTouchEvent(true);

                return false;
            }
        });

        return view;
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        unbinder.unbind();
    }

    public void showKanjiDetail(Kanji kanji) {
        tvTitleKanji.setText(kanji.getKanji());

        if (TextUtils.isEmpty(kanji.getOnyomi())) {
            tvTitleOnyomi.setVisibility(View.GONE);
        } else {
            tvTitleOnyomi.setText(kanji.getOnyomi());
            tvTitleOnyomi.setVisibility(View.VISIBLE);
            tvTitleOnyomi.scrollTo(0, 0);
        }

        if (TextUtils.isEmpty(kanji.getKunyomi())) {
            tvTitleKunyomi.setVisibility(View.GONE);
        } else {
            tvTitleKunyomi.setText(kanji.getKunyomi());
            tvTitleKunyomi.setVisibility(View.VISIBLE);
            tvTitleKunyomi.scrollTo(0, 0);
        }


    }
}
