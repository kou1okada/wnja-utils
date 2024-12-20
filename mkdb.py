#!/usr/bin/env python3
import sqlite3
import csv

# SQLite3 データベースの作成
conn = sqlite3.connect('wnjpn.db')
cursor = conn.cursor()

# テーブル定義を作成
cursor.executescript(
"""
CREATE TABLE IF NOT EXISTS 'wnjpn-all' (
    synset TEXT,
    lemma TEXT,
    src TEXT,
    PRIMARY KEY (synset, lemma, src)
);

CREATE TABLE IF NOT EXISTS 'wnjpn-def' (
    synset TEXT,
    sid TEXT,
    def_en TEXT,
    def_ja TEXT,
    PRIMARY	KEY (synset, sid)
);

CREATE TABLE IF NOT EXISTS 'wnjpn-exe' (
    synset TEXT,
    sid TEXT,
    def_en TEXT,
    def_ja TEXT,
    PRIMARY	KEY (synset, sid)
);
""")

# 各ファイルを読み込んでインポート
def import_tab_file(file_path, table_name, columns, selected_columns=None):
    """
    データを指定された列で SQLite3 に挿入する。

    :param file_path: ファイルのパス
    :param table_name: 対象テーブル名
    :param columns: テーブルの全カラム名
    :param selected_columns: ファイルから挿入するカラムのインデックス
    """
    with open(file_path, 'r', encoding='utf-8') as f:
        reader = csv.reader(f, delimiter='\t')
        rows = []

        # カラム選択がある場合はフィルタリング
        if selected_columns:
            for row in reader:
                rows.append([row[i] for i in selected_columns])
        else:
            rows = [row for row in reader]

        placeholders = ','.join(['?'] * len(columns))
        cursor.executemany(
            f"INSERT OR IGNORE INTO '{table_name}' ({','.join(columns)}) VALUES ({placeholders})",
            rows
        )
        print(f"Imported {len(rows)} rows into {table_name}")

# データインポート
import_tab_file('src/wnjpn-all.tab', 'wnjpn-all', ['synset', 'lemma', 'src'], selected_columns=[0, 1, 2])
import_tab_file('src/wnjpn-def.tab', 'wnjpn-def', ['synset', 'sid', 'def_en', 'def_ja'], selected_columns=[0, 1, 2, 3])
import_tab_file('src/wnjpn-exe.tab', 'wnjpn-exe', ['synset', 'sid', 'def_en', 'def_ja'], selected_columns=[0, 1, 2, 3])

# コミットしてクローズ
conn.commit()
conn.close()

print("wnjpn.db has been successfully created!")
