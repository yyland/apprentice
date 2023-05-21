-- 1.
SELECT episodes.title AS title, 
       broadcasts.views AS views
  FROM episodes
 INNER JOIN ch_schedules 
       ON episodes.epi_id = ch_schedules.epi_id
 INNER JOIN broadcasts 
       ON ch_schedules.ch_sch_id = broadcasts.ch_sch_id
 ORDER BY views DESC
 LIMIT 3;

-- 2.
SELECT programs.title AS program_title, 
       prg_episodes.season_no AS season_no,
       prg_episodes.season_epi_no AS season_episode_no,
       episodes.title AS episode_title, 
       broadcasts.views AS views
  FROM broadcasts
 INNER JOIN ch_schedules 
       ON broadcasts.ch_sch_id = ch_schedules.ch_sch_id
 INNER JOIN prg_episodes 
       ON   ch_schedules.epi_id = prg_episodes.epi_id
       AND  ch_schedules.prg_code = prg_episodes.prg_code
 INNER JOIN programs 
       ON   prg_episodes.prg_code = programs.prg_code
 INNER JOIN episodes 
       ON   prg_episodes.epi_id = episodes.epi_id
 ORDER BY views DESC
 LIMIT 3;

-- 3.
SELECT channels.name AS channel, 
       ch_schedules.date AS date,
       ch_schedules.start_time AS start_time,
       ch_schedules.end_time AS end_time,
       prg_episodes.season_no AS season_no, 
       prg_episodes.season_epi_no AS season_episode_no, 
       episodes.title AS episode_title,
       episodes.description AS episode_description
  FROM ch_schedules
 INNER JOIN channels 
       ON channels.ch_code = ch_schedules.ch_code
 INNER JOIN prg_episodes 
       ON   prg_episodes.epi_id = ch_schedules.epi_id
       AND  prg_episodes.prg_code = ch_schedules.prg_code
 INNER JOIN episodes 
       ON   episodes.epi_id = prg_episodes.epi_id
 WHERE ch_schedules.date = (SELECT CURDATE())
 ORDER BY date;

-- 4.
SELECT channels.name AS channel, 
       ch_schedules.date AS date,
       ch_schedules.start_time AS start_time,
       ch_schedules.end_time AS end_time,
       prg_episodes.season_no AS season_no, 
       prg_episodes.season_epi_no AS season_episode_no, 
       episodes.title AS episode_title,
       episodes.description AS episode_description
  FROM ch_schedules
 INNER JOIN channels 
       ON   channels.ch_code = ch_schedules.ch_code
 INNER JOIN prg_episodes 
       ON   prg_episodes.epi_id = ch_schedules.epi_id
       AND  prg_episodes.prg_code = ch_schedules.prg_code
 INNER JOIN episodes 
       ON   episodes.epi_id = prg_episodes.epi_id
 WHERE channels.ch_code = 'AB1'
       AND  ch_schedules.date BETWEEN (SELECT CURDATE()) 
                                  AND (SELECT CURDATE()) + 6
 ORDER BY date;




