package com.dragondev.n2kanji.utils.data;

import android.content.ContentValues;
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

    // N2 Kanji table name
    private static final String T_KANJI = "KANJI";
    private static final String T_WORD = "WORD";

    // Kanji table column name
    private static final String K_ID = "ID";
    private static final String K_DAY = "DAY";
    private static final String K_KANJI = "KANJI";
    private static final String K_ONYOMI = "ONYOMI";
    private static final String K_KUNYOMI = "KUNYOMI";

    // Word table column name
    private static final String W_ID = "ID";
    private static final String W_DAY = "DAY";
    private static final String W_KANJI_ID = "KANJI_ID";
    private static final String W_KANJI = "KANJI";
    private static final String W_KANA = "KANA";
    private static final String W_ENGLISH = "ENGLISH";
    private static final String W_MEANING = "MEANING";
    private static final String W_FAVOURITE = "FAVOURITE";

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
        String sql = "SELECT * FROM " + T_KANJI + " WHERE " + K_DAY + "=?";
        String[] args = {String.valueOf(day)};
        Cursor c = myDB.rawQuery(sql, args);
        return getKanjiList(c);
    }


    public ArrayList<Word> retrieveWord(int kanjiId) {
        String sql = "SELECT * FROM " + T_WORD + " WHERE " + W_KANJI_ID + "=?";
        String[] args = {String.valueOf(kanjiId)};
        Cursor c = myDB.rawQuery(sql, args);
        return getWordList(c);
    }

    public ArrayList<Word> retrieveAllWord() {
        Cursor c = myDB.rawQuery("SELECT * FROM " + T_WORD, null);
        return getWordList(c);
    }

    public ArrayList<Word> retrieveFavouriteWord() {
        String sql = "SELECT * FROM " + T_WORD + " WHERE " + W_FAVOURITE + "=?";
        String[] args = {String.valueOf("1")};
        Cursor c = myDB.rawQuery(sql, args);
        return getWordList(c);
    }


    public void markFavourite(int id) {
        ContentValues values = new ContentValues();
        values.put(W_FAVOURITE, 1);
        String whereClause = W_ID + "=?";
        String[] whereArgs = {String.valueOf(id)};
        myDB.update(T_WORD, values, whereClause, whereArgs);
        Log.d("Favourite", "Mark favourite : " + id);
    }

    public void removeFavourite(int id) {
        ContentValues values = new ContentValues();
        values.put(W_FAVOURITE, 0);
        String whereClause = W_ID + "=?";
        String[] whereArgs = {String.valueOf(id)};
        myDB.update(T_WORD, values, whereClause, whereArgs);
        Log.d("Favourite", "Remove favourite : " + id);
    }


    private ArrayList<Kanji> getKanjiList(Cursor c) {
        ArrayList<Kanji> kanjiList = new ArrayList<>();

        c.moveToFirst();
        while (!c.isAfterLast()) {
            Kanji k = new Kanji();

            k.setId(c.getInt(c.getColumnIndex(K_ID)));
            k.setDay(c.getInt(c.getColumnIndex(K_DAY)));
            k.setKanji(c.getString(c.getColumnIndex(K_KANJI)));
            k.setOnyomi(c.getString(c.getColumnIndex(K_ONYOMI)));
            k.setKunyomi(c.getString(c.getColumnIndex(K_KUNYOMI)));

            kanjiList.add(k);
            c.moveToNext();
        }

        c.close();

        return kanjiList;
    }

    private ArrayList<Word> getWordList(Cursor c) {
        ArrayList<Word> wordList = new ArrayList<>();

        c.moveToFirst();
        while (!c.isAfterLast()) {
            Word w = new Word();

            w.setWordId(c.getInt(c.getColumnIndex(W_ID)));
            w.setKanjiId(c.getInt(c.getColumnIndex(W_KANJI_ID)));
            w.setDay(c.getInt(c.getColumnIndex(W_DAY)));
            w.setKanji(c.getString(c.getColumnIndex(W_KANJI)));
            w.setKana(c.getString(c.getColumnIndex(W_KANA)));
            w.setMeaning(c.getString(c.getColumnIndex(W_MEANING)));
            w.setEnglish(c.getString(c.getColumnIndex(W_ENGLISH)));
            int index = c.getColumnIndex(W_FAVOURITE);
            if (!c.isNull(index))
                w.setFavourite(c.getInt(index));

            wordList.add(w);
            c.moveToNext();
        }
        c.close();

        return wordList;
    }


}
