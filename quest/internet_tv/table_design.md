<details>
<summary>ER図</summary>
<br>

![er_diagram](https://www.plantuml.com/plantuml/png/XLD1RiGW3Bpp2exj8N_OKozzH4I3bI0HY31fjKhsxxLCv5gBsfx2s1xFs90RLbVglaPZ8DLGxtPQN4eGyR36MajmdBA71eQ1Fycj57W8POPK0Et1IGQDyoTfAtakRaNRX0ZFlH9LnYlY0QSIjXfoKbt87auB-3sAWHOQWrUDP8oNj_TNBQSYi0KY_M3lAl21LpJMi3O8oJDGBeYAsOk3rgaVv7aEnX7IN1S-5eZW44PIrgjYhrhYV_iiB8K89RWufjp68OsS25aDYSuXjTgyfrg2I3PyPzbBGLsj8dwKxFpai7OtmkwwPftdpm1V-Bm0VbU_Zy_flXtraCsTvr26yz3hHAE1LEXNPHIG2ZMZCImjAMNMADyFpfxox8svJapqdQ_hDspPpfFSZQIreHialw_n6m00)

</details>

<details>
<summary>テーブル設計</summary>
<p><br>
テーブル：channels

|カラム名|データ型|NULL|キー|初期値|AUTO INCREMENT|
| ---- | ---- | ---- | ---- | ---- | ---- |
|ch_code|char(3)||PRIMARY|||
|name|varchar(50)|||||

テーブル：programs

|カラム名|データ型|NULL|キー|初期値|AUTO INCREMENT|
| ---- | ---- | ---- | ---- | ---- | ---- |
|prg_code|char(6)||PRIMARY|||
|title|text|||||
|description|text|||||

テーブル：genres

|カラム名|データ型|NULL|キー|初期値|AUTO INCREMENT|
| ---- | ---- | ---- | ---- | ---- | ---- |
|genre_code|char(3)||PRIMARY|||
|name|varchar(50)|||||

テーブル：prg_genres

|カラム名|データ型|NULL|キー|初期値|AUTO INCREMENT|
| ---- | ---- | ---- | ---- | ---- | ---- |
|prg_code|char(6)||PRIMARY|||
|genre_code|char(3)||PRIMARY|||

- 外部キー制約：prg_code に対して、programs テーブルの prg_code カラムから設定
- 外部キー制約：genre_code に対して、genres テーブルの genre_code カラムから設定

テーブル：episodes

|カラム名|データ型|NULL|キー|初期値|AUTO INCREMENT|
| ---- | ---- | ---- | ---- | ---- | ---- |
|epi_id|int(8)||PRIMARY||YES|
|title|varchar(100)|||||
|description|text|||||
|length|time|||||
|release_date|date|||||

テーブル：prg_episodes

|カラム名|データ型|NULL|キー|初期値|AUTO INCREMENT|
| ---- | ---- | ---- | ---- | ---- | ---- |
|prg_code|char(6)||PRIMARY|||
|epi_id|int(8)||PRIMARY||YES|
|prg_serial_no|int|||||
|season_no|int|||||
|season_epi_no|int|||||

- 外部キー制約：prg_code に対して、programs テーブルの prg_code カラムから設定
- 外部キー制約：epi_id に対して、episodes テーブルの epi_id カラムから設定

テーブル：ch_schedules

|カラム名|データ型|NULL|キー|初期値|AUTO INCREMENT|
| ---- | ---- | ---- | ---- | ---- | ---- |
|ch_sch_id|int(8)||PRIMARY||YES|
|ch_code|char(3)||INDEX|||
|prg_code|char(6)||INDEX|||
|epi_id|int(8)||INDEX|||
|date|date|||||
|start_time|time|||||
|end_time|time|||||

- 外部キー制約：ch_code に対して、channels テーブルの ch_code カラムから設定
- 外部キー制約：prg_code に対して、prg_episodes テーブルの prg_code カラムから設定
- 外部キー制約：epi_id に対して、prg_episodes テーブルの epi_id カラムから設定

テーブル：countries

|カラム名|データ型|NULL|キー|初期値|AUTO INCREMENT|
| ---- | ---- | ---- | ---- | ---- | ---- |
|country_code|char(3)||PRIMARY|||
|name|varchar(30)|||||

テーブル：broadcasts

|カラム名|データ型|NULL|キー|初期値|AUTO INCREMENT|
| ---- | ---- | ---- | ---- | ---- | ---- |
|ch_sch_id|int(8)||PRIMARY|||
|country_code|char(3)||PRIMARY|||
|views|int|YES||||

- 外部キー制約：ch_sch_id に対して、ch_schedules テーブルの ch_sch_id カラムから設定
- 外部キー制約：country_code に対して、countries テーブルの country_code カラムから設定
</p>
</details>

