package com.dragondev.n2kanji.adapter;

import android.content.Context;
import android.graphics.Typeface;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.dragondev.n2kanji.R;
import com.dragondev.n2kanji.model.Kanji;

import java.util.List;

/**
 * Created by Nay Myo Htet on 10/12/2018.
 */

public class KanjiAdapter extends RecyclerView.Adapter<KanjiAdapter.KanjiViewHolder> {

    private Context context;
    private List<Kanji> mKanjiList;
    private int activePosition;
    private OnKanjiSelectedListener kanjiSelectedListener;
    private Typeface typeface;


    public KanjiAdapter(Context context, List<Kanji> mKanjiList, int activePosition, OnKanjiSelectedListener listener) {
        this.context = context;
        this.mKanjiList = mKanjiList;
        this.activePosition = activePosition;
        this.kanjiSelectedListener = listener;
        typeface = Typeface.createFromAsset(context.getAssets(), "fonts/Roboto.ttf");
    }

    public void setActivePosition(int activePosition) {
        this.activePosition = activePosition;
    }

    @Override
    public KanjiViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_kanji_list, parent, false);
        return new KanjiViewHolder(itemView, kanjiSelectedListener);
    }

    @Override
    public void onBindViewHolder(KanjiViewHolder holder, int position) {
        Kanji kanji = mKanjiList.get(position);
        holder.tvMenuKanji.setText(kanji.getKanji());

        if (activePosition == position) {
            holder.tvMenuKanji.setTextColor(context.getResources().getColor(R.color.colorPrimaryDarker));
        } else {
            holder.tvMenuKanji.setTextColor(context.getResources().getColor(android.R.color.darker_gray));
        }
    }

    @Override
    public int getItemCount() {
        return mKanjiList.size();
    }


    public class KanjiViewHolder extends RecyclerView.ViewHolder {

        TextView tvMenuKanji;

        private OnKanjiSelectedListener mCallback;

        public KanjiViewHolder(View itemView, final OnKanjiSelectedListener kanjiSelectedListener) {
            super(itemView);
            mCallback = kanjiSelectedListener;

            tvMenuKanji = itemView.findViewById(R.id.tv_menu_kanji);
            tvMenuKanji.setTypeface(typeface);

            tvMenuKanji.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    activePosition = getAdapterPosition();
                    notifyDataSetChanged();
                    // TODO notify word adapter to change content
                    kanjiSelectedListener.onKanjiSelected(mKanjiList.get(activePosition));
                }
            });
        }


    }

    public interface OnKanjiSelectedListener {
        void onKanjiSelected(Kanji kanji);
    }

}
