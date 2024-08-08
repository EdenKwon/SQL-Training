delimiter $$
create procedure userproc2(in birth int, in height1 int)
begin 
	select * from usertbl where birthyear>birth and height >= height1;
end $$
delimiter ;
call userproc2(1970,178);

delimiter $$
create procedure userproc3(in txtValue char(10), out outValue INT)
begin 
	insert into testTBL Values(NULL, txtValue);
    select max(id) into outValue from testTBL;
end $$
delimiter ;

create table testTBL (id int auto_increment primary key, txt char(10));
call userproc3('테스트2', @myValue);
select concat('현재 입력된 아이디 값 ==>', @myValue);



create table gugutbl(txt varchar(100));
delimiter $$
create procedure guguTbl1()
begin
	declare str varchar(100);
	declare i int;
    declare j int;
	set i = 2;
    
    while (i < 10) do
		set str = '';
        set j = 1;
        while (j < 10) do
			set str = concat(str,' ',i,'*',j,'=',i*j);
            set j = j + 1;
		end while;
        set i = i + 1;
        insert into gugutbl values(str);
	end while;
end $$
delimiter ;
call gugutbl1();
select * from gugutbl;



select * from information_schema.routines where routine_schema = 'bookstore' and routine_type = 'PROCEDURE';

select * from information_schema.parameters where specific_name = 'userproc3';

show create procedure bookstore.userProc3;

delimiter $$
create procedure nameTableProc(IN tblName varchar(30))
begin 
	set @sqlquery = concat('select * from ',tblName);
	prepare myQuery from @sqlQuery;
    execute myQuery;
    deallocate prepare myQuery;
end $$
delimiter ;
call nameTableProc('book');
call nameTableProc('buytbl');
call nameTableProc('orders');



delimiter $$
create procedure gradeProc1(in jumsoo int)
begin 
	declare point int;
    declare credit char(1);
    set point = jumsoo;
    
    case
		when point >= 90 then
			set credit = 'A';
		when point >= 80 then
			set credit = 'B';
		when point >= 70 then
			set credit = 'C';
		when point >= 60 then
			set credit = 'D';
		else
			set credit = 'F';
	end case;
		select concat('당신의 학점은 ==>',credit,' 입니다.');
end $$
delimiter ;

call GradeProc1(50);


delimiter $$
create procedure gradeProc3(in jumsoo int, out txt varchar(100))
begin 
	declare point int;
    declare credit char(1);
    set point = jumsoo;
    
    case
		when point >= 90 then
			set credit = 'A';
		when point >= 80 then
			set credit = 'B';
		when point >= 70 then
			set credit = 'C';
		when point >= 60 then
			set credit = 'D';
		else
			set credit = 'F';
	end case;
		select concat('당신의 학점은 ==>',credit,' 입니다.') into txt;
end $$
delimiter ;

call gradeProc3(80, @result);
select @result;




select * from buytbl;

delimiter $$
create procedure CustomerGradeProc1()
begin 
	declare 구매액 int;
    declare 회원등급 varchar(10);
    set 구매액 = bookstore.buytbl.price * bookstore.buytbl.amount;
    
    case 
		when 구매액 >= 1500 then
			set 회원등급 = '최우수고객';
		when 구매액 >= 1000 then
			set 회원등급 = '우수고객';
		when 구매액 >= 1 then
			set 회원등급 = '일반고객';
		else
			set 회원등급 = '유령고객';
	end case;
    select 구매액, 회원등급 from buytbl;
end $$
delimiter ;
call custProc();

drop procedure custproc;

select * from buytbl;
select * from usertbl;

select u.userid, u.name, sum(price*amount) as 총구매액,
	case 
		when (sum(price*amount) >= 1500) then '최우수고객'
		when (sum(price*amount) >= 1000) then '우수고객'
		when (sum(price*amount) >= 1) then '일반고객'
        else '유령고객'
	end as '고객등급'
from buytbl b right outer join usertbl u on b.userid = u.userid
group by b.userid, u.name
order by sum(price * amount) desc;



--
delimiter $$
create procedure whileProc1()
begin 
	declare i int;
    declare sum int;
    
    set i = 1;
    set sum = 0;
    
    while (i <= 100) do
		set sum = sum + i;
        set i = i + 1;
	end while;
	
    select sum;
end $$
delimiter ;

call whileproc1;
		

--
delimiter $$
create procedure whileProc3()
begin 
	declare i int;
    declare sum int;
    
    set i = 1;
    set sum = 0;
    
    myWhile: while (i <= 100) do
		if(i%7 = 0) then
			set i = i + 1;
			iterate mywhile;
		end if;
			set sum = sum + i;
		if(sum > 1000) then
			leave myWhile;
			end if;
		set i = i + 1;
	end while;
    select sum;
end $$
delimiter ;

call whileproc3();


-- mysql 오류 처리
-- declare 액션 handler for 오류조건 처리할 문장;
delimiter $$
create procedure errProc()
begin 
	declare continue handler for 1146 select '테이블이 존재하지 않습니다' as '메세지';
    select * from noTable;
end $$
delimiter ;

call errproc();

delimiter $$
create procedure errorProc3()
begin 
	declare continue handler for SQLEXCEPTION
    begin
		show errors;
		select '오류가 발생하여 작업을 취소시켰습니다.' as 메세지;
        rollback;
	end;
    insert into usertbl values('LSG1','이승기',1988,'서울',NULL,NULL,170,current_date());
end $$
delimiter ;

call errorProc3();
select * from usertbl;


-- 
delimiter $$
create procedure CustheightAVGProc()
begin
	declare userheight int;
	declare cnt int default 0;
	declare totalheight int default 0;
     
	declare endOfRow boolean default false;
	
    declare userCursor CURSOR FOR
		select height from usertbl;
        
	declare continue handler for not found set endofrow = true; -- 행의 끝이면 endrow 변수에 true 대입
    
    open userCursor;
    
    c_loop: LOOP
		FETCH userCursor into userHeight;
			if endofrow then
				leave c_loop;
			end if;
		set cnt = cnt + 1;
        set totalheight = totalheight + userheight;
		END LOOP c_loop;
	select concat('고객의 키 평균 => ', (totalheight/cnt));
    close usercursor;
end $$
delimiter ;
call CustheightAVGProc();

create schema testDB;
use testDB;

create table testTBL(id int, txt varchar(10));
insert into testtbl values(1,'레드벨벳');
insert into testtbl values(2,'잇지');
insert into testtbl values(3,'블랙핑크');
commit; 

delimiter $$
create trigger testTrg
	after delete 	-- before
    on testTBL
    for each row 
begin
	 set @msg = '가수 그룹이 해체함';
end $$

delimiter ;

set @msg = '';
insert into testTBL values (4,'BTS');
SELECT @msg;
delete from testTbl where id = 3;
