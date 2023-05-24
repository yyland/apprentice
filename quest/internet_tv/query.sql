-- 1. エピソード視聴数トップ3のエピソードタイトルと視聴数を取得してください。
--   （同順位が複数ある時、後続の順位は飛びます。）
SELECT e.title AS 'エピソードタイトル', 
       b.views AS '視聴数',
       r_v.rk AS '順位'
  FROM broadcasts AS b
 INNER JOIN ch_schedules AS c_s
         ON c_s.ch_sch_id = b.ch_sch_id
 INNER JOIN episodes AS e
         ON e.epi_id = c_s.epi_id
 INNER JOIN (SELECT ch_sch_id, 
                    RANK() OVER (ORDER BY views DESC) AS rk
               FROM broadcasts) AS r_v
         ON r_v.ch_sch_id = b.ch_sch_id
 WHERE r_v.rk <= 3
 ORDER BY b.views DESC;

--   （同順位が複数ある時でも、後続の順位は飛びません。）
SELECT e.title AS 'エピソードタイトル', 
       b.views AS '視聴数',
       r_v.rk AS '順位'
  FROM broadcasts AS b
 INNER JOIN ch_schedules AS c_s
         ON c_s.ch_sch_id = b.ch_sch_id
 INNER JOIN episodes AS e
         ON e.epi_id = c_s.epi_id
 INNER JOIN (SELECT ch_sch_id, 
                    DENSE_RANK() OVER (ORDER BY views DESC) AS rk
               FROM broadcasts) AS r_v
         ON r_v.ch_sch_id = b.ch_sch_id
 WHERE r_v.rk <= 3
 ORDER BY b.views DESC;

--   （ウィンドウ関数使わない場合）
SELECT e.title AS 'エピソードタイトル', 
       b.views AS '視聴数'
  FROM broadcasts AS b
 INNER JOIN ch_schedules AS c_s
         ON c_s.ch_sch_id = b.ch_sch_id
 INNER JOIN episodes AS e
         ON e.epi_id = c_s.epi_id
 WHERE b.views >= (SELECT DISTINCT b.views
                              FROM broadcasts AS b
                             ORDER BY b.views DESC
                             LIMIT 2, 1)
 ORDER BY b.views DESC;

-- 2. エピソード視聴数トップ3の番組タイトル、シーズン数、エピソード数、エピソードタイトル、視聴数を取得してください。
SELECT p.title AS '番組タイトル', 
       CASE WHEN p_e.season_no = 0
            THEN ''
            ELSE p_e.season_no
       END AS 'シーズン数',
       CASE WHEN p_e.season_epi_no = 0
            THEN ''
            ELSE p_e.season_epi_no
       END AS 'エピソード数',
       e.title AS 'エピソードタイトル', 
       b.views AS '視聴数',
       r_v.rk AS '順位'
  FROM broadcasts AS b
 INNER JOIN ch_schedules AS c_s
         ON c_s.ch_sch_id = b.ch_sch_id
 INNER JOIN prg_episodes AS p_e 
         ON p_e.epi_id = c_s.epi_id
        AND p_e.prg_code = c_s.prg_code
 INNER JOIN programs AS p
         ON p.prg_code = p_e.prg_code
 INNER JOIN episodes AS e
         ON e.epi_id = p_e.epi_id
 INNER JOIN (SELECT ch_sch_id,
                    RANK() OVER (ORDER BY views DESC) AS rk
               FROM broadcasts) AS r_v
         ON r_v.ch_sch_id = b.ch_sch_id
 WHERE r_v.rk <= 3
 ORDER BY b.views DESC;

-- 3. 本日放送される全ての番組に対して、チャンネル名、放送開始時刻(日付+時間)、放送終了時刻、
--    シーズン数、エピソード数、エピソードタイトル、エピソード詳細を取得してください。
SELECT c.name AS 'チャンネル名', 
       c_s.date AS '放送日',
       c_s.start_time AS '放送開始時刻',
       c_s.end_time AS '放送終了時刻',
       CASE WHEN p_e.season_no = 0
            THEN ''
            ELSE p_e.season_no
       END AS 'シーズン数', 
       CASE WHEN p_e.season_epi_no = 0
            THEN ''
            ELSE p_e.season_epi_no
       END AS 'エピソード数', 
       e.title AS 'エピソードタイトル',
       e.description AS 'エピソード詳細'
  FROM ch_schedules AS c_s
 INNER JOIN channels AS c
         ON c.ch_code = c_s.ch_code
 INNER JOIN prg_episodes AS p_e
         ON p_e.epi_id = c_s.epi_id
        AND p_e.prg_code = c_s.prg_code
 INNER JOIN episodes AS e
         ON e.epi_id = p_e.epi_id
 WHERE c_s.date = CURDATE()
 ORDER BY c_s.date;

-- 4. ドラマチャンネル1に対して、放送開始時刻、放送終了時刻、シーズン数、エピソード数、
--    エピソードタイトル、エピソード詳細を本日から一週間分取得してください。
SELECT c.name AS 'チャンネル名', 
       c_s.date AS '放送日',
       c_s.start_time AS '放送開始時刻',
       c_s.end_time AS '放送終了時刻',
       CASE WHEN p_e.season_no = 1
            THEN ''
            ELSE p_e.season_no
       END AS 'シーズン数', 
       CASE WHEN p_e.season_epi_no = 5
            THEN ''
            ELSE p_e.season_epi_no
       END AS 'エピソード数', 
       e.title AS 'エピソードタイトル',
       e.description AS 'エピソード詳細'
  FROM ch_schedules AS c_s
 INNER JOIN channels AS c
         ON c.ch_code = c_s.ch_code
 INNER JOIN prg_episodes AS p_e
         ON p_e.epi_id = c_s.epi_id
        AND p_e.prg_code = c_s.prg_code
 INNER JOIN episodes AS e
         ON e.epi_id = p_e.epi_id
 WHERE c.ch_code = 'DR1'
   AND c_s.date BETWEEN CURDATE() 
                    AND CURDATE() + INTERVAL 6 DAY
 ORDER BY c_s.date;

-- 5. 直近一週間に放送された番組の中で、エピソード視聴数合計トップ2の番組に対して、
--    番組タイトル、視聴数を取得してください。
SELECT sum_prg_v.title AS '番組タイトル',
       sum_prg_v.v AS '合計視聴数'
  FROM (SELECT p.title, 
               SUM(b.views) AS v,
               RANK() OVER (ORDER BY SUM(b.views) DESC) AS rk
          FROM broadcasts AS b
         INNER JOIN ch_schedules AS c_s
                 ON c_s.ch_sch_id = b.ch_sch_id
         INNER JOIN programs AS p
                 ON p.prg_code = c_s.prg_code
         WHERE c_s.date BETWEEN CURDATE()
                            AND CURDATE() + INTERVAL 6 DAY
         GROUP BY p.prg_code) AS sum_prg_v
 WHERE sum_prg_v.rk <= 2;

-- 6. ジャンルごとに視聴数トップの番組に対して、ジャンル名、番組タイトル、エピソード平均視聴数を取得してください。
--    番組の視聴数ランキングはエピソードの平均視聴数ランキングとします。
SELECT rk_in_g.name AS 'ジャンル名',
       rk_in_g.title AS '番組タイトル',
       rk_in_g.v AS '平均視聴数'
  FROM (SELECT g.name,
               prg_avg_v.title,
               prg_avg_v.v,
               RANK() OVER (PARTITION BY g.genre_code
                                ORDER BY prg_avg_v.v DESC) AS rk
          FROM (SELECT p.prg_code,
                       p.title,
                       CAST(AVG(b.views) AS UNSIGNED) AS v
                  FROM broadcasts AS b
                 INNER JOIN ch_schedules AS c_s
                         ON c_s.ch_sch_id = b.ch_sch_id
                 INNER JOIN programs AS p
                         ON p.prg_code = c_s.prg_code
                 GROUP BY p.prg_code) AS prg_avg_v
         INNER JOIN prg_genres AS p_g
                 ON p_g.prg_code = prg_avg_v.prg_code
         INNER JOIN genres AS g
                 ON g.genre_code = p_g.genre_code) AS rk_in_g
 WHERE rk_in_g.rk = 1;