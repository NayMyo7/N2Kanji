package com.dragondev.n2kanji.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.dragondev.n2kanji.R;
import com.dragondev.n2kanji.model.Word;
import com.dragondev.n2kanji.utils.AppSharePreference;
import com.dragondev.n2kanji.utils.FontCache;
import com.dragondev.n2kanji.utils.Fonts;
import com.dragondev.n2kanji.utils.MMBindFontUtils;

import java.util.List;

/**
 * Created by Nay Myo Htet on 10/12/2018.
 */

public class WordAdapter extends RecyclerView.Adapter<WordAdapter.WordViewHolder> {
    private Context mContext;
    private List<Word> wordList;
    private int activePosition;
    private AppSharePreference pref;

    public WordAdapter(Context context, List<Word> wordList, int activePosition) {
        this.mContext = context;
        this.wordList = wordList;
        this.activePosition = activePosition;
        this.pref = new AppSharePreference(context);
    }

    @Override
    public WordViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_word_list, parent, false);
        return new WordViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(WordViewHolder holder, int position) {
        Word word = wordList.get(position);

        holder.tvKanji.setText(word.getKanji());
        holder.tvKana.setText(word.getKana());

        if (pref.getIsUnicodeSupport()) {
            holder.tvMeaning.setText(word.getMeaning());
            holder.tvMeaning.setTypeface(FontCache.get(Fonts.MM3, mContext));
        } else {
            holder.tvMeaning.setText(MMBindFontUtils.mmText(word.getMeaning(), MMBindFontUtils.ENCODING_ORIGIN_UN));
        }

        holder.tvEnglish.setText(word.getEnglish());
    }

    @Override
    public int getItemCount() {
        return wordList.size();
    }

    public class WordViewHolder extends RecyclerView.ViewHolder {

        TextView tvKanji, tvKana, tvMeaning, tvEnglish;

        public WordViewHolder(View itemView) {
            super(itemView);

            tvKanji = itemView.findViewById(R.id.tv_kanji);
            tvKana = itemView.findViewById(R.id.tv_kana);
            tvMeaning = itemView.findViewById(R.id.tv_meaning);
            tvEnglish = itemView.findViewById(R.id.tv_english);
        }
    }
}
