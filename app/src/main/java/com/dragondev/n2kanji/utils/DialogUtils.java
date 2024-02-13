package com.dragondev.n2kanji.utils;

import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import androidx.appcompat.app.AlertDialog;

import com.dragondev.n2kanji.R;

/**
 * Created by Nay Myo Htet on 12/12/17.
 */

public class DialogUtils {

    public static void showExitDialog(final Context context) {
        AlertDialog.Builder exitDialogBuilder = new AlertDialog.Builder(context, R.style.AppDialogStyle);
        exitDialogBuilder
                .setTitle(R.string.app_name)
                .setIcon(R.mipmap.ic_launcher)
                .setMessage("Are you sure to exit?")
                .setCancelable(false)
                .setNeutralButton("Rate App", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        context.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=" + ((Activity) context).getPackageName())));
                        dialog.dismiss();
                    }
                })
                .setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        ((Activity) context).finish();
                    }
                })
                .setNegativeButton("No", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.cancel();
                    }
                });

        AlertDialog exitDialog = exitDialogBuilder.create();
        exitDialog.show();
    }

}