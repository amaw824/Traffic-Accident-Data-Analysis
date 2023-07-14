from flask import Flask, make_response, render_template, request
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
@app.route('/home')
def home():
    return render_template('home.html', page_header="首頁")


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


@app.route('/TPE_accident', methods=['GET'])
def taipei_accident():

    json_path = './data/TPE_A1.json'

    with open(json_path, encoding="utf-8") as json_file:
        data = json.load(json_file)
        # print(data)

    # 自訂回應，同時將臺北事故地區放在回應中
    response = make_response(json.dumps(data, ensure_ascii=False))

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
