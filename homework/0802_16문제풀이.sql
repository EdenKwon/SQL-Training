use world;
select * from city;
select * from country;
select * from countrylanguage;

-- code, name, continent, region,surfacearea, indepyear,
-- 	population,lifeexpectancy,gnp,gnpold,localname,governmentform,headofstate,capital,code2

-- Q1.
select concat(name,' ',continent,' ',population) from country;

-- Q2.
select ifnull(indepyear,'데이터 없음') indepyear
from country 
where indepyear is null;

-- Q3.
select upper(name),lower(name) from country;

-- Q4.
select ltrim(name),rtrim(name),trim(name) from country;

-- Q5.
select name from country where length(name) > 20 order by length(name) desc;

-- Q6.
select round(surfacearea) from country;

-- Q7.
select substring(name, 2, 4) from country;

-- Q8.
select replace(code,'A','Z') from country;

-- Q9. ?
select replace(code,'A','ZZZZZZZZZZ') from country;

-- Q10.
select adddate(now(),1); 

-- Q11.
select adddate(now(),-1); 

-- Q12.
-- 문제 없음

-- Q13.
select count(*) from country;

-- Q14.
select avg(gnp),max(gnp),min(gnp) from country;

-- Q15.
select round(lifeexpectancy, 1) from country;

-- Q16.
select row_number() over(order by lifeexpectancy desc, name) as num, lifeexpectancy, code from country;

-- Q17.
select rank() over(order by lifeexpectancy desc) as num, lifeexpectancy from country;

-- Q18.
select dense_rank() over(order by lifeexpectancy desc) as num, lifeexpectancy from country;

