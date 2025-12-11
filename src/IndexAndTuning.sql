--- ◆◆以下、インデックスとチューニングの題材◆◆
--- (1)～(3)を実行しテーブルとデータの準備を行います。


--- (1) インデックス確認用テーブル（Training.Employee）を作成
CREATE TABLE Training.Employee (
    EmpID VARCHAR(10) COMPUTECODE {
        set {*}="EMP"_$TR($J({%%ID},4)," ","0")
    },
    Name VARCHAR(50),
    Dept VARCHAR(50),
    Location VARCHAR(50),
    Tel VARCHAR(15),
    CONSTRAINT EmployeePK PRIMARY KEY (EmpID)
)

--- (2) データ一括消去用ストアドプロシージャ
CREATE PROCEDURE DeleteAll()
FOR Training.Utils
BEGIN
    TRUNCATE TABLE Training.Employee;
END

--- (3) データ一括登録用ストアドプロシージャ（第1引数に追加したい件数を数値で入力します）
--- 例）CALL Training.CreateData(1000) で1000件登録
--- 登録中にエラーが発生した場合は、そのエラーメッセージを表示します。
CREATE PROCEDURE CreateData(cn INTEGER)
RETURNS INTEGER
FOR Training.Utils
PROCEDURE LANGUAGE OBJECTSCRIPT {
	#dim ex As %Exception.AbstractException
	set st=$$$OK
	 Set namelist= $LB( 
 "相原","青木","秋山","浅野","天野","新井","荒井","荒木","安藤",
 "飯島","飯田","飯塚","五十嵐","池田","石井","石川","石塚","石原","石渡","市川","伊藤","伊東","井上","今井","岩崎","岩田","岩本",
 "上田","上野","上原","内田","内山",
 "榎本","遠藤",
 "大川","大久保","大島","太田","大谷","大塚","大野","大橋","大森","岡田","岡本","小川","小沢","小澤","落合","小野","小野寺",
 "加藤","金井","金子","川上","川口","川崎","川島","川村","菅野",
 "菊地","岸","北村","木下","木村",
 "工藤","久保","久保田","熊谷","栗原",
 "小池","小泉","河野","小島","小林","小松","小山","近藤","後藤",
 "斉藤","斎藤","齋藤","酒井","坂本","佐久間","桜井","佐々木","佐藤","佐野",
 "柴田","渋谷","島田","清水","志村","白井",
 "菅原","杉本","杉山","鈴木","須藤",
 "関","関口","瀬戸",
 "高木","高野","高橋","田口","竹内","田代","田中","田辺","谷口","田村",
 "千葉","土屋","角田",
 "内藤","中川","中島","中野","中村","中山","永井","成田",	
 "西村","西山",
 "根本",
 "野口","野村",
 "萩原","橋本","長谷川","服部","浜田","早川","林","原","原田","馬場",
 "樋口","平井","平田","平野","広瀬",
 "福島","福田","藤井","藤田","藤本","古川",
 "星野","本田","本間",
 "前田","増田","松井","松尾","松岡","松下","松田","松本","丸山",
 "三浦","水野","宮崎","宮田","宮本",
 "武藤","村上","村田",
 "望月","森","森田",
 "八木","安田","矢野","山内","山口","山崎","山下","山田","山中","山本",
 "横田","横山","吉川","吉田",
 "渡辺","渡部","和田") 

		Set JpPref(1)="三重県"
		Set JpPref(2)="京都府"
		Set JpPref(3)="佐賀県"
		Set JpPref(4)="兵庫県"
		Set JpPref(5)="北海道"
		Set JpPref(6)="千葉県"
		Set JpPref(7)="和歌山県"
		Set JpPref(8)="埼玉県"
		Set JpPref(9)="大分県"
		Set JpPref(10)="大阪府"
		Set JpPref(11)="奈良県"
		Set JpPref(12)="宮城県"
		Set JpPref(13)="宮崎県"
		Set JpPref(14)="富山県"
		Set JpPref(15)="山口県"
		Set JpPref(16)="山形県"
		Set JpPref(17)="山梨県"
		Set JpPref(18)="岐阜県"
		Set JpPref(19)="岡山県"
		Set JpPref(20)="岩手県"
		Set JpPref(21)="島根県"
		Set JpPref(22)="広島県"
		Set JpPref(23)="徳島県"
		Set JpPref(24)="愛媛県"
		Set JpPref(25)="愛知県"
		Set JpPref(26)="新潟県"
		Set JpPref(27)="東京都"
		Set JpPref(28)="栃木県"
		Set JpPref(29)="沖縄県"
		Set JpPref(30)="滋賀県"
		Set JpPref(31)="熊本県"
		Set JpPref(32)="石川県"
		Set JpPref(33)="神奈川県"
		Set JpPref(34)="福井県"
		Set JpPref(35)="福岡県"
		Set JpPref(36)="福島県"
		Set JpPref(37)="秋田県"
		Set JpPref(38)="群馬県"
		Set JpPref(39)="茨城県"
		Set JpPref(40)="長崎県"
		Set JpPref(41)="長野県"
		Set JpPref(42)="青森県"
		Set JpPref(43)="静岡県"
		Set JpPref(44)="香川県"
		Set JpPref(45)="高知県"
		Set JpPref(46)="鳥取県"
		Set JpPref(47)="鹿児島県"

		set dept=$LB("","営業部","カスタマーサポート部","教育部","マーケティング部","総務部","人事部","広報部")
	
    do DISABLE^%NOJRN // プロセス内のジャーナル無効化
	try {

		for i=1:1:cn {
			// Dept
			set val(4)=$listGet(dept,$random($listlength(dept))+1)
			// Location
			set val(5)=JpPref($random(47)+1)
			// Name
			set val(3)=$list(namelist,$random($listlength(namelist))+1)
			// Tel
			if $Random(2)=1 { set val(6)=0_($Random(9)+1)_"-"_($Random(8999)+1000)_"-"_($Random(8999)+1000) }
			else {set val(6)=0_($Random(799)+200)_"-"_($Random(89)+10)_"-"_($Random(8999)+1000)}

			&sql(insert into Training.Employee values :val())
			if SQLCODE<0 {
				throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
			}
		}
	}
	catch ex {
		set st=ex.AsStatus()
		write $system.Status.GetErrorText(st)
	}
    do ENABLE^%NOJRN // プロセス内のジャーナル有効化
	quit st

}


--- Training.Employeeのデータ作成（管理ポータルのクエリ実行画面を利用してCall文で実行する場合）
--- 例）1000件登録する場合
CALL Training.CreateData(1000)



--- ◆◆以下、インデックスとチューニングの演習◆◆
--- (1) Locationに対して標準インデックスを定義する
CREATE INDEX LocationIdx On Training.Employee(Location)

--- (2) Nameに対する標準インデックスを定義する
CREATE INDEX NameIdx On Training.Employee(Name)


--- (3) LocationとNameに対する複合インデックスを定義する
CREATE INDEX NameLocationIdx On Training.Employee(Name,Location)

--- (4) LocationとNameとDeptのビットマップインデックスを追加
CREATE BITMAP INDEX BitMapLocationIdx On Training.Employee(Location)
CREATE BITMAP INDEX BitMapNameIdx On Training.Employee(Name)
CREATE BITMAP INDEX BitMapDeptIdx On Training.Employee(Dept)


--- (5) DEFERオプションを利用してLocationに対するインデックスを作成する  
--- 既に作成済の場合はわかりやすくするためにインデックスを削除する
DROP INDEX %NOJOURN LocationIdx ON Training.Employee

--- (6) DEFERオプションを利用してLocationに対するインデックスを作成する
CREATE INDEX LocationIdx On Training.Employee(Location) DEFER

--- (7) インデックスの構築を実行する
BUILD INDEX FOR TABLE Training.Employee INDEX LocationIdx