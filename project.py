from flask import Flask, make_response, render_template, request, jsonify
import requests as req
import json
import math


'''
Flask 初始化
'''
app = Flask(__name__, template_folder='templates',
            static_folder="****", static_url_path="/****")
app.static_folder = 'static'


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


@app.route('/weather', methods=['GET'])
def get_weather():
    # 串天氣資料api

    return render_template('weather.html')

    # response.headers['Access-Control-Allow-Origin'] = '*'


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
    for item in data:  # 這一行跟下一行 看起來做一樣的事情
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


if __name__ == "__main__":
    app.run(debug=True)
