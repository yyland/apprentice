
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
  FOREIGN KEY (prg_code, epi_id) REFERENCES prg_episodes(prg_code, epi_id)
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
    ('DR1', 'ドラマチャンネル1'), 
    ('DR2', 'ドラマチャンネル2'), 
    ('AN1', 'アニメチャンネル1'), 
    ('AN2', 'アニメチャンネル2'), 
    ('SP1', 'スポーツチャンネル1'), 
    ('SP2', 'スポーツチャンネル2');

INSERT INTO programs 
    (prg_code, title, description) 
VALUES
    ('DRM001', 'ドラマの魅力を徹底解剖！', '感動と笑いとサスペンスが満載のドラマを厳選してお届けします。'), 
    ('ANM001', 'アニメの世界に飛び込もう！', 'ファンタジーからSFまで幅広いジャンルのアニメをピックアップしてご紹介します。'), 
    ('SPT001', 'スポーツの熱狂を体感しよう！', '歴史に残るスポーツの名勝負や感動シーンを振り返ります。'), 
    ('DRM002', 'ドラマの裏側に迫る！', '衝撃の事実や意外なエピソードが満載です。'), 
    ('ANM002', 'アニメの裏側を大公開！', 'キャラクターの設定やストーリーの裏側など、ファン必見の情報が盛りだくさんです。'), 
    ('SPT002', 'スポーツ界の裏側に触れる！', 'スポーツ界の知られざる真実が明らかになります。'),
    ('DRM003', 'ドラマで恋する！', '恋愛や友情にまつわるドラマをセレクトしてお届けします。'), 
    ('ANM003', 'アニメで癒される！', '萌えや癒しに溢れたアニメを集めてご紹介します。'), 
    ('SPT003', 'スポーツ選手の魅力に惚れる！', 'スポーツ選手の魅力的な姿を追いかけます。'), 
    ('DRM004', 'ドラマで震える！', '怖いドラマを厳選してお届けします。'), 
    ('ANM004', 'アニメで泣く！', 'シリアスなアニメをピックアップしてご紹介します。'), 
    ('SPT004', 'スポーツで驚く！', '危険や挑戦に満ちたスポーツを紹介します。');

INSERT INTO genres 
    (genre_code, name) 
VALUES 
    ('DRM', 'ドラマ'), 
    ('ANM', 'アニメ'), 
    ('SPT', 'スポーツ');

INSERT INTO prg_genres 
    (prg_code, genre_code) 
VALUES 
    ('DRM001','DRM'),
    ('ANM001','ANM'),
    ('SPT001','SPT'),
    ('DRM002','DRM'),
    ('ANM002','ANM'),
    ('SPT002','SPT'),
    ('DRM003','DRM'),
    ('ANM003','ANM'),
    ('SPT003','SPT');

INSERT INTO episodes 
    (epi_id, title, description, length, release_date) 
VALUES
    (00000001, 'ドラマ 今日は今日', '主人公の今日は、人気ミステリー作家。ある日、自分の小説と同じ事件が起きるが…', '00:24:00', '2023-05-20'), 
    (00000002, 'ドラマ 明日は明日', '今日は警察の協力を得て、事件の真相を探るが、次々と犠牲者が出て…', '00:24:00', '2023-05-21'), 
    (00000003, 'ドラマ 明後日は明後日', '明後日は、天才的な料理人。しかし、彼女の料理にはある秘密があった…', '00:25:00', '2023-05-22'), 
    (00000004, 'ドラマ 昨日は昨日', '昨日は、国際的なスパイ。だが、彼女の正体は誰にも知られていない…', '00:23:00', '2023-05-23'), 
    (00000005, 'ドラマ 一昨日は一昨日', '一昨日は、超能力者。彼女は自分の力を使って人助けをするが、それが災いして…', '00:25:00', '2023-05-24'),
    (00000006, 'ドラマ 今日は明日', '今日は明日というタイトルの新作を発表するが、その内容がまた事件に関係していることに気づく…', '00:24:00', '2023-05-25'),
    (00000007, 'ドラマ 明日は明後日', '明日は明後日という料理番組に出演することになるが、その番組のプロデューサーが何者かに襲われる…', '00:24:00', '2023-05-26'),
    (00000008, 'ドラマ 明後日は昨日', '明後日は昨日というレストランのオーナーになるが、そのレストランがスパイ組織のアジトだと知る…', '00:25:00', '2023-05-27'),
    (00000009, 'ドラマ 昨日は一昨日', '昨日は一昨日というコードネームで活動するが、その正体が超能力者だとバレてしまう…', '00:23:00', '2023-05-28'),
    (00000010, 'ドラマ 一昨日は今日', '一昨日は今日という本名で生活するが、その名前が事件のカギを握っていることに気づく…', '00:25:00', '2023-05-29'),
    (00000011, '今日のアニメ', '主人公の今日は、普通の高校生。ある日、不思議なアプリをダウンロードしたことで、異世界に飛ばされるが…', '01:24:00', '2023-05-23'),
    (00000012, '明日のアニメ', '主人公の明日は、魔法少女に憧れる小学生。ある日、不思議なぬいぐるみから魔法の力を授かるが…', '00:24:00', '2023-05-24'),
    (00000013, '明後日のアニメ', '主人公の明後日は、宇宙飛行士を目指す大学生。ある日、不思議な宇宙船に乗り込んだことで、未知の惑星に降り立つが…', '02:24:00', '2023-05-25'),
    (00000014, '昨日のアニメ', '主人公の昨日は、歴史に興味がない高校生。ある日、不思議な時計に触ったことで、過去の時代にタイムスリップするが…', '00:24:00', '2023-05-26'),
    (00000015, '一昨日のアニメ', '主人公の一昨日は、ゲームに夢中な中学生。ある日、不思議なゲーム機に入り込んだことで、ゲームの世界に閉じ込められるが…', '03:24:00', '2023-05-27'),
    (00000016, '今日のアニメ 2', '今日は異世界で冒険を続けるが、そこで出会った仲間たちとの絆が深まる…', '01:24:00', '2023-05-30'),
    (00000017, '明日のアニメ 2', '明日は魔法少女として悪と戦うが、その中には自分の知っている人もいて…', '00:24:00', '2023-05-31'),
    (00000018, '明後日のアニメ 2', '明後日は未知の惑星で生き残るために奮闘するが、そこには驚くべき秘密が隠されていた…', '02:24:00', '2023-06-01'),
    (00000019, '昨日のアニメ 2', '昨日は過去の時代で歴史の偉人たちと出会うが、そのことが現代に影響を及ぼす…', '00:24:00', '2023-06-02'),
    (00000020, '一昨日のアニメ 2', '一昨日はゲームの世界で仲間たちと協力して脱出を目指すが、そこには罠や敵が待ち構えていた…', '03:24:00', '2023-06-03'),
    (00000021, '今日のスポーツ Aチーム対Bチーム', 'AチームとBチームは、ラグビーのライバル同士。今日の試合は、決勝戦に進むかどうかを決める重要な一戦だが…', '00:24:00', '2023-05-26'),
    (00000022, '明日のスポーツ Cチーム対Dチーム', 'CチームとDチームは、バスケットボールの強豪校。明日の試合は、両校のエースが直接対決する注目の一戦だが…', '01:24:00', '2023-05-27'),
    (00000023, '明後日のスポーツ Eチーム対Fチーム', 'EチームとFチームは、テニスの名門校。明後日の試合は、両校のダブルスが激突する白熱の一戦だが…', '00:23:00', '2023-05-28'),
    (00000024, '昨日のスポーツ Gチーム対Hチーム', 'GチームとHチームは、野球の新興校。昨日の試合は、両校のピッチャーが完全試合を目指す熱戦だったが…', '00:25:00', '2023-05-29'),
    (00000025, '一昨日のスポーツ Iチーム対Jチーム', 'IチームとJチームは、サッカーの伝統校。一昨日の試合は、両校のフォワードがゴールを争う攻防戦だったが…', '00:22:00', '2023-05-30'),
    (00000026, '今日のスポーツ Aチーム対Cチーム', 'AチームとCチームは、ラグビーの決勝戦に進んだ。今日の試合は、優勝をかけた壮絶な戦いになるが…', '00:24:00', '2023-05-31'),
    (00000027, '明日のスポーツ Bチーム対Dチーム', 'BチームとDチームは、バスケットボールの3位決定戦に進んだ。明日の試合は、名誉を賭けた激しい争いになるが…', '01:24:00', '2023-06-01'),
    (00000028, '明後日のスポーツ Eチーム対Gチーム', 'EチームとGチームは、テニスと野球の異種競技対決に挑む。明後日の試合は、どちらのスポーツが優れているかを証明するために行われるが…', '00:23:00', '2023-06-02'),
    (00000029, '昨日のスポーツ Fチーム対Hチーム', 'FチームとHチームは、テニスと野球の異種競技対決に挑む。昨日の試合は、どちらのスポーツが優れているかを証明するために行われたが…', '00:25:00', '2023-06-03'),
    (00000030, '一昨日のスポーツ Iチーム対Jチーム', 'IチームとJチームは、サッカーの最終戦に進んだ。一昨日の試合は、両校のサポーターが熱狂する歴史的な一戦だったが…', '00:22:00', '2023-06-04');

INSERT INTO prg_episodes 
    (prg_code,epi_id, prg_serial_no, season_no, season_epi_no) 
VALUES
    ('DRM001', '00000001', 1, 1, 1),
    ('DRM001', '00000002', 2, 1, 2),
    ('DRM001', '00000006', 3, 1, 3),
    ('DRM001', '00000007', 4, 1, 4),
    ('DRM003', '00000008', 5, 1, 5),
    ('DRM003', '00000009', 6, 1, 6),
    ('DRM003', '00000010', 0, 0, 0),
    ('DRM002', '00000003', 1, 1, 1),
    ('DRM002', '00000004', 2, 1, 2),
    ('DRM002', '00000005', 3, 1, 3),
    ('ANM001', '00000011', 1, 1, 1),
    ('ANM001', '00000012', 2, 1, 2),
    ('ANM003', '00000013', 3, 1, 3),
    ('ANM003', '00000014', 4, 1, 4),
    ('ANM003', '00000015', 5, 1, 5),
    ('ANM002', '00000016', 6, 2, 1),
    ('ANM002', '00000017', 7, 2, 2),
    ('ANM002', '00000018', 8, 2, 3),
    ('ANM002', '00000019', 9, 2, 4),
    ('ANM002', '00000020', 0, 0, 0),
    ('SPT001','00000021' ,1 ,1 ,1 ),
    ('SPT001','00000022' ,2 ,1 ,2 ),
    ('SPT001','00000023' ,3 ,1 ,3 ),
    ('SPT001','00000024' ,4 ,1 ,4 ),
    ('SPT001','00000025' ,5 ,1 ,5 ),
    ('SPT002','00000026' ,6 ,2 ,1 ),
    ('SPT002','00000027' ,7 ,2 ,2 ),
    ('SPT003','00000028' ,8 ,2 ,3 ),
    ('SPT003','00000029' ,9 ,2 ,4 ),
    ('SPT003','00000030' ,0, 0, 0 );

INSERT INTO ch_schedules 
    (ch_sch_id, ch_code, prg_code, epi_id, date, start_time, end_time) 
VALUES
    (10000000, 'DR1', 'DRM001', 00000001, '2023-05-20', '16:00', '17:00'),
    (10000001, 'DR1', 'DRM001', 00000002, '2023-05-21', '16:00', '17:00'),
    (10000002, 'DR1', 'DRM001', 00000006, '2023-05-25', '16:00', '17:00'),
    (10000003, 'DR1', 'DRM001', 00000007, '2023-05-26', '16:00', '17:00'),
    (10000004, 'DR1', 'DRM003', 00000008, '2023-05-27', '16:00', '17:00'),
    (10000005, 'DR2', 'DRM003', 00000009, '2023-05-28', '16:00', '17:00'),
    (10000006, 'DR2', 'DRM003', 00000010, '2023-05-29', '16:00', '17:00'),
    (10000007, 'DR2', 'DRM002', 00000003, '2023-05-22', '16:00', '17:00'),
    (10000008, 'DR2', 'DRM002', 00000004, '2023-05-23', '16:00', '17:00'),
    (10000009, 'DR2', 'DRM002', 00000005, '2023-05-24', '16:00', '17:00'),
    (10000100, 'AN1', 'ANM001', 00000011, '2023-05-23', '18:00', '19:00'),
    (10000101, 'AN1', 'ANM001', 00000012, '2023-05-24', '18:00', '19:00'),
    (10000102, 'AN1', 'ANM003', 00000013, '2023-05-25', '18:00', '19:00'),
    (10000103, 'AN1', 'ANM003', 00000014, '2023-05-26', '18:00', '19:00'),
    (10000104, 'AN1', 'ANM003', 00000015, '2023-05-27', '18:00', '19:00'),
    (10000105, 'AN2', 'ANM002', 00000016, '2023-05-30', '18:00', '19:00'),
    (10000106, 'AN2', 'ANM002', 00000017, '2023-05-31', '18:00', '19:00'),
    (10000107, 'AN2', 'ANM002', 00000018, '2023-06-01', '18:00', '19:00'),
    (10000108, 'AN2', 'ANM002', 00000019, '2023-06-02', '18:00', '19:00'),
    (10000109, 'AN2', 'ANM002', 00000020, '2023-06-03', '18:00', '19:00'),
    (10000200, 'SP1', 'SPT001', 00000021, '2023-05-26', '20:00', '21:30'),
    (10000201, 'SP1', 'SPT001', 00000022, '2023-05-27', '20:30', '22:30'),
    (10000202, 'SP1', 'SPT001', 00000023, '2023-05-28', '20:30', '22:30'),
    (10000203, 'SP1', 'SPT001', 00000024, '2023-05-29', '20:30', '22:30'),
    (10000204, 'SP1', 'SPT001', 00000025, '2023-05-30', '20:30', '22:30'),
    (10000205, 'SP2', 'SPT002', 00000026, '2023-05-31', '20:30', '22:30'),
    (10000206, 'SP2', 'SPT002', 00000027, '2023-06-01', '20:30', '22:30'),
    (10000207, 'SP2', 'SPT003', 00000028, '2023-06-02', '20:30', '22:30'),
    (10000208, 'SP2', 'SPT003', 00000029, '2023-06-03', '20:30', '22:30'),
    (10000209, 'SP2', 'SPT003', 00000030, '2023-06-04', '20:30', '22:30');

INSERT INTO countries 
    (country_code, name) 
VALUES
    ('JPN', 'Japan');

INSERT INTO broadcasts 
    (ch_sch_id, country_code, views) 
VALUES
    (10000000, 'JPN', 10),
    (10000001, 'JPN', 100),
    (10000002, 'JPN', 100),
    (10000003, 'JPN', 1000),
    (10000004, 'JPN', 1000),
    (10000005, 'JPN', 10000),
    (10000006, 'JPN', 100000),
    (10000007, 'JPN', 100000),
    (10000008, 'JPN', 1000000),
    (10000009, 'JPN', 1000000),
    (10000100, 'JPN', 10),
    (10000101, 'JPN', 100),
    (10000102, 'JPN', 100),
    (10000103, 'JPN', 1000),
    (10000104, 'JPN', 1000),
    (10000105, 'JPN', 10000),
    (10000106, 'JPN', 100000),
    (10000107, 'JPN', 100000),
    (10000108, 'JPN', 1000000),
    (10000109, 'JPN', 1000000),
    (10000200, 'JPN', 10),
    (10000201, 'JPN', 100),
    (10000202, 'JPN', 100),
    (10000203, 'JPN', 1000),
    (10000204, 'JPN', 1000),
    (10000205, 'JPN', 10000),
    (10000206, 'JPN', 100000),
    (10000207, 'JPN', 100000),
    (10000208, 'JPN', 10000000),
    (10000209, 'JPN', 10000000);
````