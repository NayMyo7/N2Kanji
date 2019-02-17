package com.dragondev.n2kanji.model;

/**
 * Created by Nay Myo Htet on 10/12/2018.
 */

public class Kanji {
    private int day;
    private int id;
    private String kanji;
    private String onyomi;
    private String kunyomi;

    public Kanji() {
    }

    public Kanji(int day, int id, String kanji, String onyomi, String kunyomi) {
        this.day = day;
        this.id = id;
        this.kanji = kanji;
        this.onyomi = onyomi;
        this.kunyomi = kunyomi;
    }

    public int getDay() {
        return day;
    }

    public void setDay(int day) {
        this.day = day;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getKanji() {
        return kanji;
    }

    public void setKanji(String kanji) {
        this.kanji = kanji;
    }

    public String getOnyomi() {
        return onyomi;
    }

    public void setOnyomi(String onyomi) {
        this.onyomi = onyomi;
    }

    public String getKunyomi() {
        return kunyomi;
    }

    public void setKunyomi(String kunyomi) {
        this.kunyomi = kunyomi;
    }
}
