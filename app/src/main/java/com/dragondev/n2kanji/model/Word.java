package com.dragondev.n2kanji.model;

/**
 * Created by Nay Myo Htet on 10/12/2018.
 */

public class Word {
    private int day;
    private int kanjiId;
    private int wordId;
    private String kanji;
    private String kana;
    private String meaning;
    private String english;
    private int favourite;

    public Word() {
    }

    public Word(int day, int kanjiId, int wordId, String kanji, String kana, String meaning, String english, int favourite) {
        this.day = day;
        this.kanjiId = kanjiId;
        this.wordId = wordId;
        this.kanji = kanji;
        this.kana = kana;
        this.meaning = meaning;
        this.english = english;
        this.favourite = favourite;
    }

    public Word(String kanji, String kana, String meaning, String english) {
        this.kanji = kanji;
        this.kana = kana;
        this.meaning = meaning;
        this.english = english;
    }

    public int getDay() {
        return day;
    }

    public void setDay(int day) {
        this.day = day;
    }

    public int getKanjiId() {
        return kanjiId;
    }

    public void setKanjiId(int kanjiId) {
        this.kanjiId = kanjiId;
    }

    public int getWordId() {
        return wordId;
    }

    public void setWordId(int wordId) {
        this.wordId = wordId;
    }

    public String getKanji() {
        return kanji;
    }

    public void setKanji(String kanji) {
        this.kanji = kanji;
    }

    public String getKana() {
        return kana;
    }

    public void setKana(String kana) {
        this.kana = kana;
    }

    public String getMeaning() {
        return meaning;
    }

    public void setMeaning(String meaning) {
        this.meaning = meaning;
    }

    public String getEnglish() {
        return english;
    }

    public void setEnglish(String english) {
        this.english = english;
    }

    public int getFavourite() {
        return favourite;
    }

    public void setFavourite(int favourite) {
        this.favourite = favourite;
    }
}
