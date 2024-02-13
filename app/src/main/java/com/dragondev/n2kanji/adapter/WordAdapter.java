package com.dragondev.n2kanji.adapter;

import android.content.Context;
import android.graphics.PorterDuff;
import android.os.Build;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.dragondev.n2kanji.MainActivity;
import com.dragondev.n2kanji.R;
import com.dragondev.n2kanji.model.Word;
import com.dragondev.n2kanji.utils.data.AppSharePreference;
import com.dragondev.n2kanji.utils.font.FontCache;
import com.dragondev.n2kanji.utils.font.Fonts;
import com.dragondev.n2kanji.utils.font.RabbitConverter;
import com.google.myanmartools.ZawgyiDetector;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Nay Myo Htet on 10/12/2018.
 */

public class WordAdapter extends RecyclerView.Adapter<WordAdapter.WordViewHolder> implements Filterable {
    private Context mContext;

    private List<Word> allWordList, filterWordList;
    WordFilter filter;

    private int activePosition;
    private AppSharePreference pref;

    private int mFontSupport;

    private static final ZawgyiDetector detector = new ZawgyiDetector();

    public WordAdapter(Context context, List<Word> allWordList, int activePosition) {
        this.mContext = context;
        this.allWordList = allWordList;
        this.filterWordList = allWordList;
        this.activePosition = activePosition;
        this.pref = new AppSharePreference(context);
        mFontSupport = pref.getMyanmarFontSupportCode();
    }

    @Override
    public WordViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_word_list, parent, false);
        return new WordViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(final WordViewHolder holder, final int position) {
        final Word word = filterWordList.get(position);

        holder.tvKanji.setText(word.getKanji());
        holder.tvKana.setText(word.getKana());

        if (word.getFavourite() == 0) {
            holder.imgFavourite.setColorFilter(ContextCompat.getColor(mContext, R.color.colorPrimaryLight), PorterDuff.Mode.MULTIPLY);
        } else {
            holder.imgFavourite.setColorFilter(ContextCompat.getColor(mContext, R.color.redAccentLight), PorterDuff.Mode.MULTIPLY);
        }

        if (mFontSupport == Fonts.UNICODE || mFontSupport == Fonts.UNICODE_EMBED) {
            holder.tvMeaning.setText(word.getMeaning());
        } else {
            holder.tvMeaning.setText(RabbitConverter.uni2zg(word.getMeaning()));
        }

        holder.tvEnglish.setText(word.getEnglish());


        holder.wordContainer.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showWordInfo(word);
            }
        });

        holder.wordContainer.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                addOrRemoveFavourite(word, holder);
                return true;
            }
        });
    }

    @Override
    public int getItemCount() {
        return filterWordList.size();
    }

    @Override
    public Filter getFilter() {
        if (filter == null) {
            filter = new WordFilter();
        }
        return filter;
    }

    public class WordViewHolder extends RecyclerView.ViewHolder {

        @BindView(R.id.word_container)
        LinearLayout wordContainer;
        @BindView(R.id.tv_kanji)
        TextView tvKanji;
        @BindView(R.id.tv_kana)
        TextView tvKana;
        @BindView(R.id.tv_meaning)
        TextView tvMeaning;
        @BindView(R.id.tv_english)
        TextView tvEnglish;
        @BindView(R.id.img_fav)
        ImageView imgFavourite;

        public WordViewHolder(View itemView) {
            super(itemView);

            ButterKnife.bind(this, itemView);

            // Check if we're running on Android 5.0 or higher
            if (Build.VERSION.SDK_INT < 21) {
                tvKana.setPadding(0, 3, 0, 0);
                tvMeaning.setPadding(0, 3, 0, 0);
                tvEnglish.setPadding(0, 3, 0, 0);
            }

            if (pref.getMyanmarFontSupportCode() == Fonts.UNICODE_EMBED) {
                tvMeaning.setTypeface(FontCache.get(Fonts.MYANMAR3, mContext));
            } else if (pref.getMyanmarFontSupportCode() == Fonts.ZAWGYI_EMBED) {
                tvMeaning.setTypeface(FontCache.get(Fonts.ZAWGYI1, mContext));
            }

        }
    }

    class WordFilter extends Filter {

        public WordFilter() {
        }

        @Override
        protected FilterResults performFiltering(CharSequence constraint) {
            FilterResults result = new FilterResults();

            if (constraint == null && constraint.length() <= 0) {
                result.values = allWordList;
                result.count = allWordList.size();
            } else {
                Log.d("N2Kanji", "Query : " + constraint.toString());
                String query = constraint.toString().toLowerCase().trim();
                if (detector.getZawgyiProbability(query) > 0.95) {
                    query = RabbitConverter.zg2uni(query);
                    Log.d("N2Kanji", "Zawgyi Input .....");
                } /*else {
                    Log.d("N2Kanji", "Unicode Input .....");
                }*/

                List<Word> filters = new ArrayList<>();
                Iterator it = allWordList.iterator();
                while (it.hasNext()) {
                    Word w = (Word) it.next();
                    if (w.getKanji().toLowerCase().contains(query) ||
                            w.getKana().toLowerCase().contains(query) ||
                            w.getEnglish().toLowerCase().contains(query) ||
                            w.getMeaning().toLowerCase().contains(query)) {
                        filters.add(w);
                        // Log.d("N2Kanji", "Word : " + w.getKanji());
                    }
                }

                result.values = filters;
                result.count = filters.size();
            }

            return result;
        }

        @Override
        protected void publishResults(CharSequence constraint, FilterResults results) {
            filterWordList = (List<Word>) results.values;
            notifyDataSetChanged();
        }
    }

    private void addOrRemoveFavourite(Word word, WordViewHolder holder) {
        if (word.getFavourite() == 0) {
            word.setFavourite(1);
            holder.imgFavourite.setColorFilter(ContextCompat.getColor(mContext, R.color.redAccentLight), PorterDuff.Mode.MULTIPLY);
            Toast.makeText(mContext, "Favourite added >> " + word.getWordId(), Toast.LENGTH_SHORT).show();
            MainActivity.dbHandler.markFavourite(word.getWordId());
        } else {
            word.setFavourite(0);
            holder.imgFavourite.setColorFilter(ContextCompat.getColor(mContext, R.color.colorPrimaryLight), PorterDuff.Mode.MULTIPLY);
            Toast.makeText(mContext, "Favourite removed << " + word.getWordId(), Toast.LENGTH_SHORT).show();
            MainActivity.dbHandler.removeFavourite(word.getWordId());
        }
    }

    private void showWordInfo(Word word) {
        int week, day;
        if (word.getDay() < 8) {
            week = 1;
            day = word.getDay();
        } else {
            week = word.getDay() / 7;
            day = word.getDay() % 7;
            if (day == 0) {
                day = 7;
            } else {
                week += 1;
            }
        }

        Toast.makeText(mContext, "Week" + week + " / Day" + day + " / No" + word.getWordId(), Toast.LENGTH_SHORT).show();
    }


}
