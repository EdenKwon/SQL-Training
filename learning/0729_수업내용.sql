use movieDB;
create table movietbl(
	movie_id int,
	movie_title varchar(30),
	movie_director varchar(20),
	movie_star varchar(20),
	movie_script longtext,
    movie_film longblob
)default charset = utf8mb4;

drop table movietbl;

insert into movietbl values (1,'쉰들러리스트','스티븐 스필버그','리암 니슨',
load_file('C:/Study/database/movies/Schindler.txt'),
load_file('C:/Study/database/movies/Schindler.mp4'));

insert into movietbl values (2,'쇼생크탈출','프랭크 다라본트','팀 로빈스',
load_file('C:/Study/database/movies/Shawshank.txt'),
load_file('C:/Study/database/movies/Shawshank.mp4'));

insert into movietbl values (3,'라스트 모히칸','마이클 만','다니엘 데이 루이스',
load_file('C:/Study/database/movies/Mohican.txt'),
load_file('C:/Study/database/movies/Mohican.mp4'));

-- 다운로드 하기
select movie_script from movietbl where movie_id = 1
	into outfile 'C:/study/database/movies/Schindler_out.txt'
    lines terminated by '\\n'; -- 줄바꿈 문자도 그대로 다운받아서 저장한다.



select * from movietbl;

-- movie_script와 movie_film 입력되지 않은 이유 알아보기
/*
	1. 최대 패킷 크기(= 최대 파일 크기) 시스템 변수	:max_allowed_packet 값 조회
    2. 파일을 업로드/다운로드 할 폴더 경로를 볆도로 허용해 주어야 한다. (my-sql server) 'secure_file_priv' 조회
    

*/
show variables like 'max_allowed_packet'; -- > 4M  max_allowed_packet = 4194304
show variables like 'secure_file_priv';

truncate movietbl;

-- movie_film 다운로드 받기 : LONGBLOB 형식인 동영상 INTO DUMPFILE문 이용 : 바이너리 파일로 내려받는다.
select movie_film from movietbl where movie_id=3
into dumpfile 'C:/Study/database/movies/Mohican_out.mp4';

/*
	피봇(pivot) : 한 열에 포함된 여러 값을 출력하고, 여러 열로 변환하여 테이블 반환 식을 회전하고 필요하면 집계까지 수행하는 과정을 의미한다.
*/

create table pivotTest(
	uName char(5),
    season char(2),
    amount int
);

insert into pivotTest values ('김진수','겨울',10),('윤민수','여름',15),('김진수','가을',25),('윤민수','봄',3),('김진수','봄',40),('윤민수','겨울',64),('김진수','겨울',50),('김진수','여름',15);
insert into pivotTest values ('김진수','봄',47);

commit;
select*from pivotTest;

-- 판매자 별로 판매 계절, 판매수량 : sum(),IF() 함수 활용해서 피벗테이블을 생성하기
select uName,
	   sum(if(season= '봄',amount,0)) as '봄',
       sum(if(season= '여름',amount,0)) as '여름',
       sum(if(season= '가을',amount,0)) as '가을',
       sum(if(season= '겨울',amount,0)) as '겨울',
       sum(amount) as '합계' from pivotTest group by uName;

-- 계절 별로 판매자의 판매수량을 집계하여 출력하는 피벗 만들기
select season,
		sum(if(uName='김진수',amount,0)) as '김진수의 판매수량',
		sum(if(uName='윤민수',amount,0)) as '윤민수의 판매수량',
        sum(amount) as '총합' from pivotTest group by season;	
	
    
/* 
JSON 데이터
웹과 모바일 응용 프로그램에서는 데이터를 교환하기 위해 개발형 표준 포맷인 JSON을 활용한다.
JSON은 속성(KEY)와 값(VALUE)으로 쌍으로 구성되어있다. 독립적인 데이터 포맷이다. 포맷이 단순하고 공개되어 있어 여러 프로그래밍 언어에서 채택하고 있다.
{
	{
		"userName" : "김삼순",
        "birthyear" : 2002,
        "address" : "서울 성동구 북가좌동",
        "mobile" : "01012348989",
    } ==> 김상순 회원의 정보
    
}
*/
use bookstore;
select * from userTbl;

select json_object('name',name,'height',height) as '키 180이상 회원 정보' from usertbl where height >= 180;

-- JSON 을 위한 MySQL은 다양한 내장함수를 제공한다.
set @json = '{
	"usertbl1" : [
		{"name": "임재범", "height": 182},
        {"name": "이승기", "height": 182}, 
        {"name": "성시경", "height": 186}
    ]
}';

select JSON_VALID(@json) as JSON_VALID; -- 문자열이 JSON 형식을 만족하면 1, 만족하지 않으면 0 반환
select JSON_SEARCH(@json,'one','성시경') as JSON_SEARCH; -- one은 최초 조회 하나만, all은 전부
select JSON_INSERT(@json,'$.usertbl1[0].mdate','2024-07-29') as JSON_INSERT;
select JSON_REPLACE(@json, '$.usertbl1[0].name', '임영웅') AS JSON_replace;
select JSON_REMOVE(@json, '$.usertbl[1]') as json_remove;

-- 제어흐름 함수, 문자열 함수, 수학함수, 날짜/시간 함수, 전체 텍스트 함수, 형변환 함수
-- 1. 제어흐름 함수 if(), IFNULL(), NULLIF(), CASE~WHEN~ELSE~END()
-- 1-1 IF(수식) 수식이 참인 지 거짓인 지 결과에 따라 분기
select if (100>200,'참','거짓');
-- 1-2 IFNULL(수식1, 수식2) 수식1이 NULL이 아니면 수식1이 반환되고, 수식1이 NULL이면 수식2 반환
select ifnull(null,'널이네'),ifnull(100,'널러리');
-- 1-3 NULLIF(수식1, 수식2) : 수식1과 수식2가 같으면 NULL 반환하고, 다르면 수식1 반환한다.
select NULLIF(100,100), NULLIF(100,200);
-- 1-4 CASE~WHEN~ELSE~END 함수는 아니지만 연산자(Operator)로 분류된다. 다중분기 + 내장함수
select case 10
	when 1 then '일'
    when 2 then '이'
    when 5 then '오'
    else '모름'
end as 'case test';

-- 문자열 함수 ** 활용도 최상 **

-- 1-1 ASCII(아스키 코드), char(숫자)
select ascii('A'), char(65);

-- MySQL은 기본 UTF-8 코드를 사용하기 때문에
-- 영문자는 한 글자 당 1byte, 한글은 3byte 할당한다.
-- BIT_LENGTH() -> BIT 크기 또는 문자 크기 변환
-- CHAR_LENGTH() -> 문자의 개수 반환
-- LENGTH() -> 할당된 Byte 수 반환
select BIT_LENGTH('abc'), char_length('abc'), length('abc'); -- 24/3/3
select BIT_LENGTH('가나다'), char_length('가나다'), length('가나다'); -- 72/3/9

-- concat(문자열1, 문자열2...), concat_ws(구분자, 문자열1, 문자열2...) -> 구분자와 함께 문자열을 이어준다.

select concat_ws('-','2024','해커톤 우승자','래리 킴');
select ELT(2,'one','two','three'),			-- two
	   field('둘','one','two','three'),		-- 0 // 만약 two가 둘이였다면 위치값 2 
       find_in_set('둘','one,two,three'),	-- 0 // 만약 two가 둘이였다면 위치값 2 (,가 구분자)
       instr('하나둘셋', '둘'),				-- 3 // 제일 활용된다. 둘의 최초 위치 값 
       locate('둘','하나둘셋');				-- 3 // 둘의 최초 위치 값
       
-- FORMAT(숫자, 소숫점 자릿수) : 숫자를 소숫점 아래 자릿수까지 표현, 1000 단위로 콤마(,) 표시
select format(123456.123456,4);
select bin(31),hex(31),oct(31); -- 10진수를 2,16,8진수로 변환하여 출력

select insert('abcdefghijk',3,4,'####'); -- insert(기준 문자열, 위치, 길이, 삽입할 문자열) 기준 문자열의 위치부터 길이만큼 지우고 삽입할 문자열 끼워넣기
select left('abcdefghi',3), right('abcdefghi',3); -- 왼쪽, 오른쪽 문자열의 길이만큼 반환한다.

-- upper(문자열), lower(문자열)
select lower('ABC'), upper('def');
select lcase('ABC'), ucase('def');

-- lpad(문자열, 채움 문자열), rpad()
select lpad('SSG', 5,'&');
select rpad('SSG I', 7,'&C');

-- trim() 양쪽 공백 제거
select trim('     신세계 자바 프로그래밍      ');
select ltrim('     신세계 자바 프로그래밍      ');
select rtrim('     신세계 자바 프로그래밍      ');

-- substring(문자열, 시작 위치, 길이) substring(문자열 from 시작위치 for 길이)
select substring('자바프로그래밍',3,5);

-- 날짜 및 시간 함수 

-- 1. ADDDATE(날짜, 차이), SUBDATE(날짜, 차이)
select adddate('2024-01-01', interval 31 day);
select subdate('2025-01-01', interval 2 month);
select subdate('2025-01-01', interval 1 year);

select addtime('2025-01-01 23:59:59', '0:0:1');
select subtime('2025-01-01 23:59:59', '1:1:1');

-- 2. CURDATE() : 현재 연-월-일	CURTIME() : 현재 시:분:초 NO(),SYSDATE(),LOCALTIME(),LOCALSTAMP() -> 연-월-일-시:분:초

-- 3. YEAR(날짜), MONTH(날짜), DAY(날짜), HOUR(시간), MINUTE(시간), SECOND(시간), MICROSECOND(시간)
select year(curdate());
select month(curdate());
select day(curdate());
select hour(curtime()), microsecond(current_time);

select date(now()), time(now());