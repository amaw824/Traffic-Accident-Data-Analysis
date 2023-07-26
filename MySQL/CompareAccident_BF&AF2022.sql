-- 比較2022/12/01前後的月平均事故量

-- 非鄰近科技執法點的事故地點 月平均
SELECT sub1.accident_ADDR,
       AVG(sub1.before_) AS before_avg_BY_MONTH,
       AVG(sub2.after_) AS after_avg_BY_MONTH
FROM (
    SELECT accident_ADDR, YEAR(whole_date), MONTH(whole_date), COUNT(Accident_dead) AS before_
    FROM clean
    WHERE camera_id IS NULL AND whole_date <= '2022-11-30'
    GROUP BY accident_ADDR, YEAR(whole_date), MONTH(whole_date)
) AS sub1
JOIN (
    SELECT accident_ADDR, YEAR(whole_date), MONTH(whole_date), COUNT(Accident_dead) AS after_
    FROM clean
    WHERE camera_id IS NULL AND whole_date >= '2022-12-01'
    GROUP BY accident_ADDR, YEAR(whole_date), MONTH(whole_date)
) AS sub2 ON sub1.accident_ADDR = sub2.accident_ADDR
GROUP BY sub1.accident_ADDR;

-- 鄰近科技執法點的事故地點 月平均

SELECT sub1.camera_id,
       AVG(sub1.before_) AS before_avg_BY_MONTH,
       AVG(sub2.after_) AS after_avg_BY_MONTH
FROM (
    SELECT camera_id, YEAR(whole_date), MONTH(whole_date), COUNT(Accident_dead) AS before_
    FROM clean
    WHERE camera_id IS not NULL AND whole_date <= '2022-11-30'
    GROUP BY camera_id, YEAR(whole_date), MONTH(whole_date)
) AS sub1
JOIN (
    SELECT camera_id, YEAR(whole_date), MONTH(whole_date), COUNT(Accident_dead) AS after_
    FROM clean
    WHERE camera_id IS not NULL AND whole_date >= '2022-12-01'
    GROUP BY camera_id, YEAR(whole_date), MONTH(whole_date)
) AS sub2 ON sub1.camera_id = sub2.camera_id
GROUP BY sub1.camera_id;