--- 患者情報用テーブル
CREATE TABLE Training.Patient(
    PID VARCHAR(50),
    Name NVARCHAR(50),
    DOB DATE,
    CONSTRAINT PatientPK PRIMARY KEY (PID)
)

--- 診察情報用テーブル
CREATE TABLE Training.Visit(
    Patient VARCHAR(50),
    VisitDate DATE,
    Symptom VARCHAR(100),
    CONSTRAINT PatientFK FOREIGN KEY (Patient) REFERENCES Training.Patient(PID)
)

---　外部キーに付与するインデックス
CREATE INDEX PatientFKIdx ON Training.Visit(Patient)

--- 1件ずつ登録してみましょう
---　管理ポータルから実行する場合は「ODBCモード」を選択してから実行します。
INSERT INTO Training.Patient (PID,Name,DOB) VALUES('P0001', '赤川次郎', '2005-08-01')

--- データを2件登録してみましょう
--- 管理ポータルから実行する場合は「ODBCモード」を選択してから実行します。
--- ✅エラーが出ます。どのようなエラーが出るでしょうか。
INSERT INTO Training.Patient (PID, Name, DOB) VALUES
('P0002', N'川岸三郎', '2004-09-12'),
('P0003', N'百田直次郎', '2001-03-11');

--- データを検索してみましょう。
--- TO_DATE関数を利用して日付のフォーマットを変えることができます。
SELECT * FROM Training.Patient
WHERE DOB < TO_DATE('2003-01-01', 'YYYY-MM-DD')



--- ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆
---【複数行を実行したい場合に便利なデータ登録方法（LOAD SQL）】
--- 実行したいINSERT文を別ファイル（insert.sql）に記載しています。
--- ファイルはフルパスで指定します。実行環境に合わせて変更してください。
--- ※ insert.sqlはSJISで保存しています。
---    Windows以外のOSにIRISをインストールしている場合は文字コードをUTF8に変換してから実行してください。
--- ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆
LOAD SQL FROM FILE 'c:\temp\insert.sql' DIALECT 'IRIS' 
 LOG TO FILE 'c:\temp\insert_log.txt' IGNORE ERRORS



--- ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆
--- 💡参考情報：LOAD DATAを利用した一括登録
--- 実行にJava実行環境が必要な方法です。
--- ファイル名は実行環境に合わせて変更してください。
--- ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆
--- LOAD DATA ：患者情報
LOAD DATA FROM FILE 'c:\temp\Patientインポートデータ.txt'
 INTO Training.Patient
 USING {"from":{"file":{"charset":"UTF8","header":true}}}

--- LOAD DATA ：診察情報
LOAD DATA FROM FILE 'c:\temp\Visitインポートデータ.txt'
 INTO Training.Visit
 USING {"from":{"file":{"charset":"UTF8","header":true}}}


--- Training.Visitのデータ登録は管理ポータルの「データのインポート」機能を利用
--- または、以下のようなINSERT文を利用しても登録可能です。
--- INSERT INTO Training.Visit (Patient, VisitDate, Symptom) VALUES('P0001', '2023-01-15', '頭痛と発熱')

