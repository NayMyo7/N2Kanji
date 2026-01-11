#!/usr/bin/env python3
import argparse
import json
import sqlite3
import sys
import xml.etree.ElementTree as ET


def is_kanji(cp: int) -> bool:
    return (
        (0x4E00 <= cp <= 0x9FFF) or  # CJK Unified Ideographs
        (0x3400 <= cp <= 0x4DBF) or  # CJK Extension A
        (0xF900 <= cp <= 0xFAFF)     # CJK Compatibility Ideographs
    )


def extract_needed_kanji_from_db(db_path: str) -> set[str]:
    conn = sqlite3.connect(db_path)
    conn.row_factory = sqlite3.Row
    try:
        cur = conn.cursor()

        # WORD table expected from your app: columns include KANJI
        cur.execute("SELECT KANJI FROM WORD")
        needed = set()

        for row in cur.fetchall():
            text = row["KANJI"] or ""
            for ch in text:
                if is_kanji(ord(ch)):
                    needed.add(ch)

        return needed
    finally:
        conn.close()


def parse_kanjidic2_xml(xml_path: str, needed: set[str]) -> dict:
    # KANJIDIC2 root: <kanjidic2>, entries: <character>
    tree = ET.parse(xml_path)
    root = tree.getroot()

    out: dict[str, dict] = {}
    found = 0

    for ch in root.findall("character"):
        literal_el = ch.find("literal")
        if literal_el is None or not literal_el.text:
            continue

        literal = literal_el.text.strip()
        if literal not in needed:
            continue

        # Meanings (English only): <meaning> elements without m_lang attribute
        meanings = []
        for m in ch.findall("reading_meaning/rmgroup/meaning"):
            if m.get("m_lang") is None and m.text:
                t = m.text.strip()
                if t:
                    meanings.append(t)

        # Readings:
        onyomi = []
        kunyomi = []
        for r in ch.findall("reading_meaning/rmgroup/reading"):
            if not r.text:
                continue
            t = r.text.strip()
            if not t:
                continue
            r_type = r.get("r_type")
            if r_type == "ja_on":
                onyomi.append(t)
            elif r_type == "ja_kun":
                kunyomi.append(t)

        out[literal] = {
            "meanings": meanings,
            "on": onyomi,
            "kun": kunyomi,
        }
        found += 1

        # Early stop optimization if we found them all
        if found >= len(needed):
            break

    return out


def main():
    ap = argparse.ArgumentParser(
        description="Export slim KANJIDIC2 JSON containing only kanji used in app WORD table."
    )
    ap.add_argument(
        "--db",
        default="assets/N2Kanji",
        help="Path to SQLite DB (default: assets/N2Kanji)",
    )
    ap.add_argument(
        "--kanjidic2",
        required=True,
        help="Path to kanjidic2.xml",
    )
    ap.add_argument(
        "--out",
        default="assets/kanjidic2_slim.json",
        help="Output JSON path (default: assets/kanjidic2_slim.json)",
    )
    ap.add_argument(
        "--pretty",
        action="store_true",
        help="Pretty-print JSON (bigger file). Default is compact.",
    )
    args = ap.parse_args()

    needed = extract_needed_kanji_from_db(args.db)
    print(f"[1/3] Unique kanji found in WORD.KANJI: {len(needed)}")

    if not needed:
        print("No kanji found in WORD.KANJI; output will be empty.")
        data = {}
    else:
        data = parse_kanjidic2_xml(args.kanjidic2, needed)
        print(f"[2/3] Entries found in KANJIDIC2: {len(data)}")
        missing = len(needed) - len(data)
        print(f"[2/3] Missing from KANJIDIC2: {missing}")

    if args.pretty:
        content = json.dumps(data, ensure_ascii=False, indent=2)
    else:
        content = json.dumps(data, ensure_ascii=False, separators=(",", ":"))

    with open(args.out, "w", encoding="utf-8") as f:
        f.write(content)

    print(f"[3/3] Wrote: {args.out}")


if __name__ == "__main__":
    try:
        main()
    except sqlite3.Error as e:
        print(f"SQLite error: {e}", file=sys.stderr)
        sys.exit(1)
    except ET.ParseError as e:
        print(f"XML parse error: {e}", file=sys.stderr)
        sys.exit(1)