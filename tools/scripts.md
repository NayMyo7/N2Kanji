**Slim KANJIDIC2 export (only kanji that exist in your app WORD table)**

```bash
python3 tools/export_kanjidic2_slim.py \
  --db assets/N2Kanji \
  --kanjidic2 /tools/data/kanjidic2.xml \
  --out assets/kanjidic2_slim.json
``` 