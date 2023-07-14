import pandas as pd
import json
import csv


# 指定CSV和JSON檔案的路徑
csv_path = r'C:\Python\python_web_scraping\TEAM1_PROJECT\data\sepDate_TP.csv'
json_path = r'C:\Python\python_web_scraping\TEAM1_PROJECT\data\sepDate_TP.json'


def csv_to_json(csv_path, json_path, encoding='utf-8', errors='ignore'):
    print("開始讀取CSV檔案...")
    # 開啟CSV檔案
    with open(csv_path, 'r', encoding=encoding) as csv_file:
        # 讀取CSV內容
        csv_data = csv.DictReader(csv_file)
        # 將CSV資料轉換為JSON格式
        json_data = json.dumps(list(csv_data), indent=4, ensure_ascii=False)

    # print(json_data)
    # 寫入JSON檔案
    with open(json_path, 'w', encoding='utf-8') as json_file:
        json_file.write(json_data)
        print("JSON檔案寫入完成！")


# 呼叫函式進行轉換
csv_to_json(csv_path, json_path, encoding='utf-8')
