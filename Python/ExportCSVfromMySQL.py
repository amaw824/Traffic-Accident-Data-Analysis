import pandas as pd
import pymysql


conn = pymysql.connect(
    host="192.168.36.16",
    user='teamone',
    password='teamone',
    database='teamone'
)

# 建立連接

# 執行查詢並讀取到 DataFrame
df = pd.read_sql('SELECT * from ann_clean where CITY ="新北市"', conn)


dest_folder = 'C:/專題/合併總檔案/'
# 將 DataFrame 保存為 CSV
df.to_csv(f'{dest_folder}NTPE_Clean.csv', encoding='utf-8', index=False)

conn.close()
