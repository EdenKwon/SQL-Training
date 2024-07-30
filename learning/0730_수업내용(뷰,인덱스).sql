	select abs(-78), abs(78);
    select round(4.875,1);
    
    use bookstore;
    select custid, round(avg(saleprice),-2) 
    from orders 
    group by custid;
    
    select replace(bookname,'야구','농구') from book where bookname like '%야구%';
	
    select bookname, length(bookname) from book where publisher = '굿스포츠';
    select bookname, char_length(bookname) from book where publisher = '굿스포츠';
    
    select substr(name,1,1), count(*) from usertbl group by substr(name,1,1);
    
    select orderid 주문번호, orderdate 주문일,adddate(orderdate, interval 10 day) 확정일 from orders;
    
    select orderid 주문번호, date_format(orderdate,'%Y-%m-%d') 주문일, custid '고객번호', bookid '도서번호' 
    from orders 
    where orderdate = str_to_date('20240707', '%Y%m%d');
    
    select sysdate(), now(), date_format(sysdate(),'%Y/%m/%d %a %h:%i') sysdate1;
    
    create table mybook (bookid int, price int);
    insert into mybook values (1,10000);
    insert into mybook values (2,20000);
    insert into mybook values (3,null);
    
    select sum(price) from mybook;
    select price + 100 from mybook where bookid = 3;
    select sum(price), avg(price), count(*), count(price) from mybook;
    select * from mybook where price is null;
    
    select name 이름, ifnull(phone,'연락처 없음') 전화번호 from customer;
    select * from usertbl limit 2;
    
    
    set @seq:=0;
    select (@seq:=@seq+1) '순번', custid, name, phone from customer where @seq<2;
    
    
    create view Vorders
    as select o.orderid, o.custid,c.name, o.bookid,bookname,saleprice,o.orderdate
	from Customer c, orders o, Book b
    where c.custid = o.custid and b.bookid = o.bookid;
    
    create view soccerBook
    as select * from book where bookname like '%축구%';
    select * from soccerbook;
    
    create view koreanView
    as select * from customer where address like '%대한민국%';
    select * from koreanview;
    
    create or replace view koreanView(custid,name,address)
    as select custid,name,address from customer where address like '%대한민국%';
    
    drop view koreanview;
    
    -- 1.
    create view highorders
    as select b.bookid 도서번호, b.bookname 도서이름, c.name 고객이름, b.publisher 출판사, o.saleprice 판매가격
    from book b, orders o, customer c
    where b.bookid = o.bookid and o.custid = c.custid and o.saleprice >= 20000; 
    
    -- 2.
    select 도서이름, 고객이름 from highorders; 
    -- select * from highorders; 
    
    -- 3.
    create or replace view highorders
    as select b.bookid 도서번호, b.bookname 도서이름, c.name 고객이름, b.publisher 출판사
    from book b, orders o, customer c
    where b.bookid = o.bookid and o.custid = c.custid and o.saleprice >= 20000; 
    
    select * from book;
    select * from orders;
    select * from customer;
    
    -- 인덱스 
    create index ix_book on book(bookname);
    create index ix_book2 on book(publisher,price);
    show index from book;
    
    select * from book where publisher = '대한미디어' and price >= 30000;
    
    analyze table book;
    drop index ix_book on book;
    drop index ix_book2 on book;
    