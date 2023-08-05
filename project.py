from MachineLearning.Catboost.instant_forecast_funtion import get_instant_weather_data, add_data_to_six_city_hot_spots, preprocessing_for_feeding_model, get_probability, get_six_city_hot_spots_json, determine_the_csv_to_read
from flask import Flask, make_response, render_template, request, jsonify
import requests as req
import json
import math
import pymysql

# import MySQLdb
# from mysql.connector import connect


'''
Flask 初始化
'''
app = Flask(__name__, template_folder='templates',
            static_folder="****", static_url_path="/****")
app.static_folder = 'static'


# 資料庫連線設定
db_host = "192.168.36.16"
db_user = "teamone"
db_password = "teamone"
db_name = "teamone"


@app.route('/')
@app.route('/index')
def home():
    return render_template('index.html', page_header="首頁")


@app.route('/team')
def team():
    return render_template('team.html', page_header="團隊介紹")


@app.route('/map')
def map():
    return render_template('map.html', page_header="地圖分析")


@app.route('/da')
def da():
    return render_template('da.html', page_header="資料分析")


@app.route('/prediction')
def weather():

    return render_template('prediction.html', page_header="預測事故熱點")


@app.route('/hotSpot', methods=['GET'])
def hotSpot():
    df_six_city_hot_spots = determine_the_csv_to_read()
    weather_api_data_dict = get_instant_weather_data()

    city = request.args.get('cityValue')
    # print(city)
    vehicle = request.args.get('vehicle')
    # print(vehicle)
    gender = request.args.get('gender')
    # print(gender)
    age = request.args.get('age')
    # print(age)

    df = add_data_to_six_city_hot_spots(
        df_six_city_hot_spots, weather_api_data_dict, vehicle, gender, age)
    df_prob = df
    X_test = preprocessing_for_feeding_model(df)
    df_prob = get_probability(X_test, df_prob)
    six_city_hot_spots_json = get_six_city_hot_spots_json(df_prob)

    response = make_response(six_city_hot_spots_json)

    # 回傳自訂回應
    response.headers["Content-Type"] = "application/json"
    response.headers['Access-Control-Allow-Origin'] = '*'

    return response


@app.route('/accident', methods=['GET'])
def accident():
    city = request.args.get('city')
    # print(city)
    year = request.args.get('year')
    # print(year)
    month = request.args.get('month')
    # print(month)
    type = request.args.get('type')
    # print(type)
    json_path = ""
    if (city == "NTP"):
        json_path = './data/sepDATE_NP.json'
    elif (city == "TY"):
        json_path = './data/sepDATE_TY.json'
    elif (city == "TC"):
        json_path = './data/sepDATE_TC.json'
    elif (city == "TN"):
        json_path = './data/sepDATE_TN.json'
    elif (city == "KS"):
        json_path = './data/sepDATE_KS.json'
    else:  # 預設TPE
        json_path = './data/sepDATE_TP.json'

    with open(json_path, encoding="utf-8") as json_file:
        # 透過Year Month Type 去過濾 json_file，過濾後再回傳
        data = json.load(json_file)
        # print(data)
    # 後端加入年月類型的篩選邏輯
    global filter_data
    filter_data = []
    for item in data:
        if item['Year'] == year and item['Month'] == month and item['ACCIDENT_TYPE'] == type:
            filter_data.append(item)

    # print(filter_data)
    # 自訂回應，同時將臺北事故地區放在回應中
    response = make_response(json.dumps(filter_data, ensure_ascii=False))

    # 回傳自訂回應
    response.headers["Content-Type"] = "application/json"
    response.headers['Access-Control-Allow-Origin'] = '*'

    return response


@app.route('/traffic_camera', methods=['GET'])
def traffic_camera():

    json_path = './data/CAMERA.json'

    with open(json_path, encoding="utf-8") as json_file:
        data = json.load(json_file)
        # print(data)

    # 自訂回應，同時將科技執法列表資訊附加在回應中
    response = make_response(json.dumps(data, ensure_ascii=False))

    # 回傳自訂回應
    response.headers["Content-Type"] = "application/json"
    response.headers['Access-Control-Allow-Origin'] = '*'

    return response


@app.route('/localdb')
def access_database():
    city = request.args.get('city')
    # print(city)
    year = request.args.get('year')
    if (year == None):
        year = 2022
   # print(year)
    month = request.args.get('month')
    if (month == None):
        month = 1
   # print(month)
    type = request.args.get('type')
    if (type == None):
        type = 'A1'
   # print(type)

    if city == "NTP":
        city = "新北市"
    elif city == "TY":
        city = "桃園市"
    elif city == "TC":
        city = "臺中市"
    elif city == "TN":
        city = "臺南市"
    elif city == "KS":
        city = "高雄市"
    else:  # 預設 TPE
        city = "臺北市"

    # 建立資料庫連線
    connection = pymysql.connect(
        host=db_host, user=db_user, passwd=db_password, db=db_name
    )

    # 建立 cursor 物件
    cursor = connection.cursor()

    # 輸入 MySQL 查詢或操作
    CallSP = '''
    CALL RETURN_LL('{}', '{}', '{}', '{}')
    '''.format(city, month, year, type)

    print(CallSP)

    cursor.execute(CallSP)
    data = cursor.fetchall()

    # 將資料與表頭對應成字典形式
    converted_data = [{
        "LONGITUDE": d[0],
        "LATITUDE": d[1],
        "ACCIDENT_DEAD": d[2],
        "ACCIDENT_INJURY": d[3]
    } for d in data]

    response = make_response(json.dumps(converted_data, ensure_ascii=False))

    print(response)

    # 回傳自訂回應
    response.headers["Content-Type"] = "application/json"
    response.headers['Access-Control-Allow-Origin'] = '*'

    # 關閉 cursor 與資料庫連線
    cursor.close()
    connection.close()

    return response


# @app.route('/db')
# def db_connection():

#     conn = connect(user='teamone', password='teamone',
#                         host='db', database='teamone')
#     cursor = conn.cursor()

#     cursor.execute('SELECT * FROM sepdate_tp')
#     Result = str(cursor.fetchall())

#     Result.headers["Content-Type"] = "application/json"
#     Result.headers['Access-Control-Allow-Origin'] = '*'
#     cursor.close()
#     conn.close()
#     return Result


if __name__ == "__main__":
    app.run(debug=True)
