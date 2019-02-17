package com.dragondev.n2kanji.utils;

import android.content.Context;
import android.database.Cursor;
import android.database.DatabaseErrorHandler;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import com.dragondev.n2kanji.model.Kanji;
import com.dragondev.n2kanji.model.Word;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;

/**
 * Created by Nay Myo Htet on 10/12/2018.
 */

public class DatabaseHandler extends SQLiteOpenHelper {

    private static final String DB_NAME = "N2Kanji";
    private static final String DB_PATH_SUFFIX = "/database/";
    private SQLiteDatabase myDB;
    private Context context;

    public DatabaseHandler(Context context) {
        super(context, DB_NAME, null, 1);
        this.context = context;
    }

    public DatabaseHandler(Context context, String name, SQLiteDatabase.CursorFactory factory, int version, DatabaseErrorHandler errorHandler) {
        super(context, name, factory, version, errorHandler);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {

    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }

    //Open database
    public void openDatabase() {

        String dbPath = context.getApplicationInfo().dataDir + DB_PATH_SUFFIX + DB_NAME;
        File dbFile = new File(dbPath);
        Log.d("dbPath", dbPath + "\t==\t" + dbFile.getPath());

        if (!dbFile.exists()) {
            try {
                Log.d("Task", "Copying...");
                File dbDirectory = new File(context.getApplicationInfo().dataDir + DB_PATH_SUFFIX);
                dbDirectory.mkdir();
                copyDatabase(dbFile);
            } catch (IOException e) {
                throw new RuntimeException("Error creating source database", e);
            }
        }

        myDB = SQLiteDatabase.openDatabase(dbFile.getPath(), null, SQLiteDatabase.OPEN_READWRITE);
    }

    //Copy database if not exist
    private void copyDatabase(File dbFile) throws IOException {

        InputStream is = context.getAssets().open(DB_NAME);
        OutputStream os = new FileOutputStream(dbFile);

        byte[] buffer = new byte[1024];
        int length;
        while ((length = is.read(buffer)) > 0) {
            os.write(buffer, 0, length);
            Log.d("buffer", String.valueOf(length));
        }

        os.flush();
        os.close();
        is.close();
    }

    //Close the database
    public void closeDatabase() {
        myDB.close();
    }

    public ArrayList<Kanji> retrieveKanji(int day) {
        ArrayList<Kanji> kanjiList = new ArrayList<Kanji>();

        Cursor c;
        String sql = "SELECT * FROM KANJI WHERE DAY=?";
        String[] args = {String.valueOf(day)};
        c = myDB.rawQuery(sql, args);

        c.moveToFirst();
        while (!c.isAfterLast()) {
            Kanji k = new Kanji();
            k.setId(c.getInt(c.getColumnIndex("ID")));
            k.setDay(c.getInt(c.getColumnIndex("DAY")));
            k.setKanji(c.getString(c.getColumnIndex("KANJI")));
            k.setOnyomi(c.getString(c.getColumnIndex("ONYOMI")));
            k.setKunyomi(c.getString(c.getColumnIndex("KUNYOMI")));

            kanjiList.add(k);
            c.moveToNext();
        }

        c.close();

        return kanjiList;
    }

    public ArrayList<Word> retrieveWord(int kanjiId) {
        ArrayList<Word> wordList = new ArrayList<Word>();

        Cursor c;
        String sql = "SELECT * FROM WORD WHERE KANJI_ID=?";
        String[] args = {String.valueOf(kanjiId)};
        c = myDB.rawQuery(sql, args);

        c.moveToFirst();
        while (!c.isAfterLast()) {
            Word w = new Word();
            w.setWordId(c.getInt(c.getColumnIndex("ID")));
            w.setKanjiId(c.getInt(c.getColumnIndex("KANJI_ID")));
            w.setDay(c.getInt(c.getColumnIndex("DAY")));
            w.setKanji(c.getString(c.getColumnIndex("KANJI")));
            w.setKana(c.getString(c.getColumnIndex("KANA")));
            w.setMeaning(c.getString(c.getColumnIndex("MEANING")));
            w.setEnglish(c.getString(c.getColumnIndex("ENGLISH")));

            wordList.add(w);
            c.moveToNext();
        }

        c.close();

        return wordList;
    }


}
