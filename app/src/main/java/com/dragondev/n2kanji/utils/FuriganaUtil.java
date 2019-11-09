package com.dragondev.n2kanji.utils;

public class FuriganaUtil {

    public static String getOriginalText(String text) {
        String originalText = "";
        // Spannify text
        while (text.length() > 0) {
            int idx = text.indexOf('{');
            if (idx >= 0) {
                // Prefix string
                if (idx > 0) {
                    // Spans
                    originalText += text.substring(0, idx);

                    // Remove text
                    text = text.substring(idx);
                }

                // End bracket
                idx = text.indexOf('}');
                if (idx < 1) {
                    // Error
                    text = "";
                    break;
                } else if (idx == 1) {
                    // Empty bracket
                    text = text.substring(2);
                    continue;
                }

                // Spans
                String[] split = text.substring(1, idx).split(";");
                originalText += split[0];

                // Remove text
                text = text.substring(idx + 1);

            } else {
                // Single span
                originalText += text;
                text = "";
            }
        }

        return originalText;
    }
}
