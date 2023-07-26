-- 事故資料 SQL Schema

create table ACCIDENT (
WHOLE_DATE DATE , 
WHOLE_TIME TIME ,
ACCIDENT_TYPE VARCHAR (10) ,
ADMIN_UNIT VARCHAR (20),
CITY VARCHAR(20),
ACCIDENT_ADDR VARCHAR (100) ,
WEATHER VARCHAR(20),
LIGHT VARCHAR (20),
ROAD_TYPE_MAIN VARCHAR (20),
SPEED_LIMIT VARCHAR (20),
ROAD_TYPE_SUB1 VARCHAR (20),
ROAD_TYPE_SUB2 VARCHAR (20),
LOCATION_MAIN VARCHAR (50),
LOCATION_SUB VARCHAR (50),
PAVE_MTL VARCHAR (50),
PAVE_CDN VARCHAR (50),
PAVE_FLAW VARCHAR (50),
BAR VARCHAR (50),
BAR_QUA VARCHAR (50),
BAR_VIS VARCHAR (50),
SIGNAL_TYPE VARCHAR (50),
SIGNAL_CDN VARCHAR (50),
LANE_MAIN VARCHAR (50),
LANE_SUB VARCHAR (50),
LANE_LINE VARCHAR (50),
LANE_LINE_SPEED VARCHAR (50),
LANE_LINE_EDGE VARCHAR (50),
ACCIDENT_OBJ VARCHAR (50),
ACCIDENT_CASE VARCHAR (50),
CAUSE_MAIN VARCHAR (50),
CAUSE_SUB VARCHAR (50),
ACCIDENT_DEAD VARCHAR (50),
ACCIDENT_INJURY VARCHAR (50),
ACCIDENT_OBJ_ORDER VARCHAR (50),
VEHICLE_MAIN VARCHAR (50),
VEHICLE_SUB VARCHAR (50),
OBJ_GENDER VARCHAR (50),
OBJ_AGE VARCHAR (50),
PROTECTION VARCHAR (50),
C_PDT_USAGE VARCHAR (50),
OBJ_CDN_MAIN VARCHAR (50),
OBJ_CDN_SUB VARCHAR (50),
CRASH_MAIN VARCHAR (50),
CRASH_SUB VARCHAR (50),
CRASH_OTHER_MAIN VARCHAR (50),
CRASH_OTHER_SUB VARCHAR (50),
CAUSE_MAIN_DETAIL VARCHAR (50),
CAUSE_SUB_DETAIL VARCHAR (50),
HAR VARCHAR (50),
LONGITUDE VARCHAR (50),
LATITUDE VARCHAR (50));

-- 天氣資料Schema 
create table weather (
Station_ID VARCHAR (10) not null,
whole_date DATE,
ObsTime	VARCHAR (10),
StnPres	VARCHAR (10),
SeaPres	VARCHAR (10),
Temperature	VARCHAR (10),
Td_dew_point VARCHAR (10),
RH	VARCHAR (10),
WS	VARCHAR (10),
WD	VARCHAR (10),
WSGust	VARCHAR (10),
WDGust	VARCHAR (10),
Precp	VARCHAR (10),
PrecpHour	VARCHAR (10),
SunShine	VARCHAR (10),
GloblRad	VARCHAR (10),
Visb	VARCHAR (10),
UVI	VARCHAR (10),
Cloud_Amount VARCHAR (10)
);


-- 科技執法Schema
create TABLE TRAFFIC_STATION(
DATA_SOURCE VARCHAR (20),
TEMP_ID VARCHAR (20) not null,
CITY VARCHAR (20) not null,
EQUIP_TYPE VARCHAR (100) not null,
DISTRICT VARCHAR (50),
ADMIN_UNIT VARCHAR (20),
LOCATION VARCHAR (300),
DIRECTION VARCHAR (50),
LONGITUDE VARCHAR (50),
LATITUDE VARCHAR (50),
JUDGMENT_RAW VARCHAR (100),
JUDGMENT_CLEAN VARCHAR (100),
SPEED_LIMIT VARCHAR (20),
SENSOR_AREA VARCHAR (20),
PUN_LINE_SIGNAL VARCHAR (20),
PUN_RED_LIGHT VARCHAR (20),
PUN_OVER_SPPED VARCHAR (20),
PUN_IGNORE_WALKER VARCHAR (20),
PUN_ROAD_KIND VARCHAR (20),
PUN_PARKING VARCHAR (20)
);

-- 天氣測站 SQL Schema
create TABLE WEATHER_STATION(
Station_STATUS VARCHAR (10),
Station_ID VARCHAR (10) not null,
Station_NAME VARCHAR (20) not null,
KIND VARCHAR (20) not null,
ALTITUDE  VARCHAR (50),
LONGITUDE VARCHAR (50),
LATITUDE VARCHAR (50),
CITY  VARCHAR (50),
ADDR VARCHAR (100),
RECORD_START_D  DATE,
RECORD_END_D  DATE,
NOTE VARCHAR (300),
OLD_ID VARCHAR (10),
NEW_ID VARCHAR (10)
);