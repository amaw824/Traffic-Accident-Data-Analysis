#經緯度錯誤(在海上）
#1
SELECT count(*)FROM ann_accident WHERE city='臺北市' and LONGITUDE >121.527 and LATITUDE >25.32;#2筆
SELECT count(*)FROM ann_accident WHERE city='新北市' and LONGITUDE >121.607 and LATITUDE <24.836;#41筆
SELECT count(*)FROM ann_accident WHERE city='新北市' and LONGITUDE <121.337 and LATITUDE >25.173;#2筆
SELECT count(*)FROM ann_accident WHERE city='桃園市' and LONGITUDE <121.131 and LATITUDE <24.856;#63筆
SELECT count(*)FROM ann_accident WHERE city='臺中市' and LONGITUDE <120.462 and LATITUDE <24.189;#41
SELECT count(*)FROM ann_accident WHERE city='臺中市' and LONGITUDE <120.505 and LATITUDE >24.258;#7
SELECT count(*)FROM ann_accident WHERE city in ('台南市','高雄市') and LONGITUDE >120.886 and LATITUDE <23.146;#26
SELECT count(*)FROM ann_accident WHERE city in ('台南市','高雄市') and LONGITUDE >120.476 and LATITUDE <22.767;#243
SELECT count(*)FROM ann_accident WHERE city in ('台南市','高雄市') and LONGITUDE <120.345 and LATITUDE <22.464;#1960
SELECT count(*)FROM ann_accident WHERE city in ('台南市','高雄市') and LONGITUDE <120.234 and LATITUDE <22.723;#2079

#2
SELECT count(*)FROM ann_accident WHERE city='臺北市' and LONGITUDE <121.364 and LATITUDE >25.152;#24筆
SELECT count(*)from ann_accident WHERE city='桃園市' and LONGITUDE >121.603 and LATITUDE <24.778;#22筆
SELECT count(*)from ann_accident WHERE city='高雄市' and LONGITUDE <120.026 and LATITUDE <23.01;#2
SELECT count(*)from ann_accident WHERE city='臺中市' and LONGITUDE <120.571 and LATITUDE >24.362;#6
SELECT count(*)from ann_accident WHERE city='新北市' and LONGITUDE >121.776 and LATITUDE <24.883;#238

#3
SELECT count(*)FROM ann_accident WHERE city='桃園市' and LONGITUDE <121.25 and LATITUDE >25.212;#2
SELECT count(*)FROM ann_accident WHERE LONGITUDE >120.543 and LONGITUDE <120.635 and LATITUDE <23.655 and LATITUDE >23.581;#3
SELECT count(*)FROM ann_accident WHERE LONGITUDE >120.361 and LONGITUDE <120.522 and LATITUDE <24.149 and LATITUDE >23.925;#393
SELECT count(*)FROM ann_accident WHERE LONGITUDE >120.148 and LONGITUDE <120.243 and LATITUDE <22.728 and LATITUDE >22.636;#6
SELECT count(*)FROM ann_accident WHERE LONGITUDE >120.238 and LONGITUDE <120.342 and LATITUDE <22.546 and LATITUDE >22.444;#223
SELECT count(*)FROM ann_accident WHERE LONGITUDE >121.413 and LONGITUDE <121.491 and LATITUDE <23.763 and LATITUDE >23.693;#2




-- update_age_for_v3 

select OBJ_GENDER,count(*)from six_city where OBJ_AGE is null group by OBJ_GENDER;
UPDATE six_city SET OBJ_AGE=NULL WHERE OBJ_GENDER not in ('男','女');


-- AVG_temperature
# -- 查詢各縣市日均溫，根據平均各測站溫度，排除海拔偏高的測站進行補值
select city,whole_date,ROUND(AVG(CAST(temperature AS DECIMAL)), 3) as AVGT_TP from weather_city where altitude<=173 and city='臺北市' and whole_date>='2018-01-01' and whole_date <='2023-05-18' group by city,whole_date order by whole_date;

select city,whole_date,ROUND(AVG(CAST(temperature AS DECIMAL)), 3) as AVGT_NP from weather_city where altitude<=279 and city='新北市' and whole_date>='2018-01-01' and whole_date <='2023-05-18' group by city,whole_date order by whole_date;

select city,whole_date,ROUND(AVG(CAST(temperature AS DECIMAL)), 3) as AVGT_TY from weather_city where altitude<=439 and city='桃園市' and whole_date>='2018-01-01' and whole_date <='2023-05-18' group by city,whole_date order by whole_date;

select city,whole_date,ROUND(AVG(CAST(temperature AS DECIMAL)), 3) as AVGT_TC from weather_city where altitude<=377 and city='臺中市' and whole_date>='2018-01-01' and whole_date <='2023-05-18' group by city,whole_date order by whole_date;

select city,whole_date,ROUND(AVG(CAST(temperature AS DECIMAL)), 3) as AVGT_TN from weather_city where altitude<=24 and city='臺南市' and whole_date>='2018-01-01' and whole_date <='2023-05-18' group by city,whole_date order by whole_date;

select city,whole_date,ROUND(AVG(CAST(temperature AS DECIMAL)), 3) as AVGT_KS from weather_city where altitude<=29 and city='高雄市' and whole_date>='2018-01-01' and whole_date <='2023-05-18' group by city,whole_date order by whole_date;


-- add weekday
ALTER TABLE clean
ADD COLUMN WEEKDAYS VARCHAR(10) AFTER WHOLE_DATE;
UPDATE clean
SET WEEKDAYS = CASE DAYOFWEEK(WHOLE_DATE)
    WHEN 1 THEN 'Sunday'
    WHEN 2 THEN 'Monday'
    WHEN 3 THEN 'Tuesday'
    WHEN 4 THEN 'Wednesday'
    WHEN 5 THEN 'Thursday'
    WHEN 6 THEN 'Friday'
    WHEN 7 THEN 'Saturday'
END;

select *from clean where WHOLE_DATE like '2023-%';



-- 批次處理數據
CREATE TABLE new_table (
    -- 定義資料型別
);

-- 分批插入數據
INSERT INTO new_table
SELECT * FROM (
    SELECT
        awc_concat.WHOLE_DATE,
        WHOLE_TIME,
        ACCIDENT_TYPE
	FROM
        weather
    JOIN
        awc_concat ON weather.Station_ID = awc_concat.STATION_ID
            AND weather.whole_date = awc_concat.WHOLE_DATE
            AND weather.ObsTime = awc_concat.WHOLE_TIME
    LIMIT 1000 OFFSET 0 -- 第一批數據
) AS batch;

-- 依次處理後續批次數據
INSERT INTO new_table
SELECT * FROM (
    SELECT
        awc_concat.WHOLE_DATE,
        WHOLE_TIME,
        ACCIDENT_TYPE
        
    FROM
        weather
    JOIN
        awc_concat ON weather.Station_ID = awc_concat.STATION_ID
            AND weather.whole_date = awc_concat.WHOLE_DATE
            AND weather.ObsTime = awc_concat.WHOLE_TIME
    LIMIT 1000 OFFSET 1000 -- 第二批数据
) AS batch;

-- 重複此過程，更改OFFSET值，直到處理完所有數據

