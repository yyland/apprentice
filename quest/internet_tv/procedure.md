
カレントディレクトリをinternet_tvにします。  
続いて以下のコマンドを実行します。  
````
docker compose up -d
docker compose exec db bash
````

bashの中に入ったら、MySQLにルートユーザーとしてログインします。  
今回はdocker-compose.ymlに記載してある、  
「password」がルートユーザーのパスワードです。  
````
mysql -u root -p 
````

今回使用するデータベースとテーブルを作成します。
````
CREATE DATABASE internet_tv;
USE internet_tv;

CREATE TABLE channels (
  ch_code CHAR(3) NOT NULL,
  name VARCHAR(50) NOT NULL,
  PRIMARY KEY (ch_code)
);

CREATE TABLE programs (
  prg_code CHAR(6) NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  PRIMARY KEY (prg_code)
);

CREATE TABLE genres (
  genre_code CHAR(3) NOT NULL,
  name VARCHAR(50) NOT NULL,
  PRIMARY KEY (genre_code)
);

CREATE TABLE prg_genres (
  prg_code CHAR(6) NOT NULL,
  genre_code CHAR(3) NOT NULL,
  FOREIGN KEY (prg_code) REFERENCES programs(prg_code),
  FOREIGN KEY (genre_code) REFERENCES genres(genre_code)
);

CREATE TABLE episodes (
  epi_id INT(8) NOT NULL AUTO_INCREMENT,
  title VARCHAR(100) NOT NULL,
  description TEXT NOT NULL,
  length TIME NOT NULL,
  release_date DATE NOT NULL,
  PRIMARY KEY (epi_id)
);

CREATE TABLE prg_episodes (
  prg_code CHAR(6) NOT NULL,
  epi_id INT(8) NOT NULL,
  prg_serial_no INT NOT NULL,
  season_no INT NOT NULL,
  season_epi_no INT NOT NULL,
  PRIMARY KEY (prg_code, epi_id),
  FOREIGN KEY (prg_code) REFERENCES programs(prg_code),
  FOREIGN KEY (epi_id) REFERENCES episodes(epi_id)
);

CREATE TABLE ch_schedules (
  ch_sch_id INT(8) NOT NULL AUTO_INCREMENT,
  ch_code CHAR(3) NOT NULL,
  prg_code CHAR(6) NOT NULL,
  epi_id INT(8) NOT NULL,
  date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  PRIMARY KEY (ch_sch_id),
  FOREIGN KEY (ch_code) REFERENCES channels(ch_code),
  FOREIGN KEY (prg_code) REFERENCES programs(prg_code),
  FOREIGN KEY (epi_id) REFERENCES episodes(epi_id)
);

CREATE TABLE countries (
  country_code CHAR(3) NOT NULL,
  name VARCHAR(30) NOT NULL,
  PRIMARY KEY (country_code)
);

CREATE TABLE broadcasts (
  ch_sch_id INT(8) NOT NULL,
  country_code CHAR(3) NOT NULL,
  views INT,
  PRIMARY KEY (ch_sch_id, country_code),
  FOREIGN KEY (ch_sch_id) REFERENCES ch_schedules(ch_sch_id),
  FOREIGN KEY (country_code) REFERENCES countries(country_code)
);
````

サンプルデータを入れます。

````
INSERT INTO channels 
    (ch_code, name) 
VALUES 
    ('AB1', 'channel1'), 
    ('CD2', 'channel2'), 
    ('EF3', 'channel3'), 
    ('GH4', 'channel4'), 
    ('IJ5', 'channel5');

INSERT INTO programs 
    (prg_code, title, description) 
VALUES 
    ('AABB01', 'program1', 'description1'), 
    ('CCDD02', 'program2', 'description2'), 
    ('EEFF03', 'program3', 'description3'), 
    ('GGHH04', 'program4', 'description4'), 
    ('IIJJ05', 'program5', 'description5');

INSERT INTO genres 
    (genre_code, name) 
VALUES 
    ('ABC', 'genre1'), 
    ('DEF', 'genre2'), 
    ('GHI', 'genre3'), 
    ('JKL', 'genre4'), 
    ('MNO', 'genre5');

INSERT INTO prg_genres 
    (prg_code, genre_code) 
VALUES 
    ('AABB01','ABC'),
    ('CCDD02','DEF'),
    ('EEFF03','GHI'),
    ('GGHH04','JKL'),
    ('IIJJ05','MNO');

INSERT INTO episodes 
    (epi_id, title, description, length, release_date) 
VALUES
    (00000001,'episode1','episode_description1','01:00:00','2020-05-21'),
    (00000002,'episode2','episode_description2','01:00:00','2020-05-22'),
    (00000003,'episode3','episode_description3','01:00:00','2020-05-23'),
    (00000004,'episode4','episode_description4','01:00:00','2020-05-24'),
    (00000005,'episode5','episode_description5','01:00:00','2020-05-25'),
    (00000006,'episode6','episode_description6','01:00:00','2020-05-26'),
    (00000007,'episode7','episode_description7','01:00:00','2020-05-27');

INSERT INTO prg_episodes 
    (prg_code,epi_id, prg_serial_no, season_no, season_epi_no) 
VALUES
    ('AABB01', 00000001, 1, 1, 1),
    ('AABB01', 00000002, 1, 1, 2),
    ('AABB01', 00000006, 1, 1, 2),
    ('AABB01', 00000007, 1, 1, 3),
    ('CCDD02', 00000002, 2, 2, 2),
    ('EEFF03', 00000003, 3, 3, 3),
    ('GGHH04', 00000004, 4, 4, 4),
    ('IIJJ05', 00000005, 1, 0, 0),
    ('IIJJ05', 00000006, 6, 0, 0),
    ('IIJJ05', 00000007, 7, 0, 0);

INSERT INTO ch_schedules 
    (ch_sch_id, ch_code, prg_code,epi_id,date,start_time,end_time) 
VALUES
    (10000000, 'AB1', 'AABB01', 00000001, '2023-05-20', '16:00', '17:00'),
    (10000001, 'AB1', 'AABB01', 00000002, '2023-05-21', '16:00', '17:00'),
    (10000002, 'CD2', 'CCDD02', 00000002, '2023-05-22', '17:00', '18:00'),
    (10000003, 'EF3', 'EEFF03', 00000003, '2023-05-23', '18:00', '19:00'),
    (10000004, 'GH4', 'GGHH04', 00000004, '2023-05-24', '19:00', '20:00'),
    (10000005, 'IJ5', 'IIJJ05', 00000005, '2023-05-25', '20:00', '21:00'),
    (10000006, 'EF3', 'EEFF03', 00000003, '2023-05-26', '18:00', '19:00'),
    (10000007, 'GH4', 'GGHH04', 00000004, '2023-05-27', '19:00', '20:00'),
    (10000008, 'GH4', 'GGHH04', 00000004, '2023-05-28', '19:00', '20:00'),
    (10000009, 'GH4', 'GGHH04', 00000004, '2023-05-29', '19:00', '20:00'),
    (10000010, 'GH4', 'GGHH04', 00000004, '2023-05-30', '19:00', '20:00'),
    (10000011, 'IJ5', 'IIJJ05', 00000005, '2023-05-31', '20:00', '21:00'),
    (10000100, 'AB1', 'AABB01', 00000006, '2023-05-23', '16:00', '17:00'),
    (10000101, 'AB1', 'AABB01', 00000007, '2023-05-25', '16:00', '17:00');

INSERT INTO countries 
    (country_code, name) 
VALUES
    ('AAA', 'country_aaa'),
    ('BBB', 'country_bbb'),
    ('CCC', 'country_ccc'),
    ('DDD', 'country_ddd'),
    ('EEE', 'country_eee');

INSERT INTO broadcasts 
    (ch_sch_id, country_code, views) 
VALUES
    (10000001, 'AAA', 10),
    (10000002, 'BBB', 12000),
    (10000003, 'CCC', 14000),
    (10000004, 'DDD', 16000),
    (10000005, 'EEE', 100000);
````


