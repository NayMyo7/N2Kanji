package com.dragondev.n2kanji.adapter;

import android.content.Context;
import android.graphics.Typeface;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.dragondev.n2kanji.MainActivity;
import com.dragondev.n2kanji.R;
import com.dragondev.n2kanji.model.Kanji;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Nay Myo Htet on 10/12/2018.
 */

public class KanjiAdapter extends RecyclerView.Adapter<KanjiAdapter.KanjiViewHolder> {

    private Context mContext;
    private List<Kanji> mKanjiList;
    private int activePosition;
    private OnKanjiSelectedListener kanjiSelectedListener;

    public KanjiAdapter(Context context, List<Kanji> kanjiList, int activePosition, OnKanjiSelectedListener listener) {
        this.mContext = context;
        this.mKanjiList = kanjiList;
        this.activePosition = activePosition;
        this.kanjiSelectedListener = listener;
    }

    public void setActivePosition(int activePosition) {
        this.activePosition = activePosition;
    }

    public int getActivePosition() {
        return activePosition;
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
            holder.tvMenuKanji.setTypeface(null, Typeface.BOLD);
            holder.tvMenuKanji.setTextColor(mContext.getResources().getColor(R.color.colorPrimaryDarker));
            holder.hrView.setBackgroundColor(mContext.getResources().getColor(R.color.redAccent));
        } else {
            holder.tvMenuKanji.setTextColor(mContext.getResources().getColor(R.color.light_gray));
            holder.hrView.setBackgroundColor(mContext.getResources().getColor(R.color.colorTransparent));
            holder.tvMenuKanji.setTypeface(null, Typeface.NORMAL);
        }
    }

    @Override
    public int getItemCount() {
        return mKanjiList.size();
    }


    public class KanjiViewHolder extends RecyclerView.ViewHolder {

        @BindView(R.id.kanji_wrapper)
        LinearLayout kanjiWrapper;
        @BindView(R.id.tv_menu_kanji)
        TextView tvMenuKanji;
        @BindView(R.id.hr_line)
        View hrView;

        public KanjiViewHolder(View itemView, final OnKanjiSelectedListener kanjiSelectedListener) {
            super(itemView);

            ButterKnife.bind(this, itemView);

            kanjiWrapper.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    activePosition = getAdapterPosition();
                    notifyDataSetChanged();
                    MainActivity.pref.setCurrentPosition(activePosition);
                    kanjiSelectedListener.onKanjiSelected(mKanjiList.get(activePosition));
                }
            });

        }

    }

    public interface OnKanjiSelectedListener {
        void onKanjiSelected(Kanji kanji);
    }

}
