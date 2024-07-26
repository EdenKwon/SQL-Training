-- 하나의 스키마에서 여러 테이블이 존재하고 정보를 저장하고 있다.
-- 테이블 간의 관계를 기반으로 수행되는 연산
-- join sql : 1999 문법 이전과 이후 구분
-- join 종류는 등가조인(equi join) ==> 오라클 : natural / inner join
-- outer join (외부 조인)  ==> left outer join, right outer join
-- self join(자체 조인)
-- 비등가 조인 
-- 카티시안 곱 ==> cross join



select emp.last_name, loc.location_id, dept.department_id, dept.department_name
from employees emp, locations loc, departments dept
where emp.department_id = dept.department_id and dept.location_id = dept.location_id and loc.location_id = 1700;


-- self join
select * from employees;

select distinct concat(e1. first_name,' ',e1.last_name) 사원이름 from employees e1 inner join employees e2
on e1.employee_id = e2.manager_id;

-- left outer join
select *
from departments dept, employees emp
where dept.department_id = emp.department_id;







select * from regions;
select * from locations;
select * from employees;
select * from departments;
select * from job_history;
select * from jobs;

-- 1. 모든 사원의 이름, 부서번호, 부서 이름을 조회하세요
select concat(emp.first_name," ",emp.last_name) 이름, emp.department_id, dept.department_name
from employees emp, departments dept
where emp.department_id = dept.department_id;

-- 2. 부서번호 80 에 속하는 모든 업무의 고유 목록을 작성하고(?) 출력결과에 부서의 위치를 출력하세요
select loc.street_address
from departments dept, locations loc
where dept.department_id = 80;


-- 3. 커미션을 받는 사원의 이름, 부서 이름, 위치번호와 도시명을 조회하세요
select concat(emp.first_name,' ',emp.last_name) 이름, dept.department_name, dept.location_id 
from employees emp, departments dept, locations loc
where emp.department_id = dept.department_id and dept.location_id = loc.location_id;

-- 4. 이름에 a(소문자)가 포함된 모든 사원의 이름과 부서명을 조회하세요
select concat(emp.first_name,' ',emp.last_name) 이름, dept.department_name 
from employees emp, departments dept
where emp.department_id = dept.department_id and concat(emp.first_name,' ',emp.last_name) like '%a%';

-- 5. 'Toronto'에서 근무하는 모든 사원의 이름, 업무, 부서 번호 와 부서명을 조회하세요
select concat(emp.first_name,' ',emp.last_name) 이름, emp.job_id, dept.department_name 
from employees emp, departments dept, jobs, locations loc 
where emp.department_id = dept.department_id and dept.location_id = loc.location_id and emp.job_id = jobs.job_id and loc.city = 'Toronto';
 
-- 6. 사원의 이름 과 사원번호를 관리자의 이름과 관리자 아이디와 함께 표시하고 각각의 컬럼명을 Employee, Emp#, Manger, Mgr#으로 지정하세요
select e1.employee_id as 'Employee', concat(e1.first_name,' ',e1.last_name) as 'Emp#', e2.employee_id as 'Manager', concat(e2.first_name,' ',e2.last_name) as 'Mgr#'
from employees e1, employees e2 -- e2가 관리자
where e2.employee_id = e1.manager_id;

-- 7. 사장인'King'을 포함하여 관리자가 없는 모든 사원을 조회하세요 (사원번호를 기준으로 정렬하세요)
select distinct e1.employee_id as '관리자가 없는 사원'
from employees e1
where e1.manager_id is null;

-- 8. 지정한 사원의 이름, 부서 번호 와 지정한 사원과 동일한 부서에서 근무하는 모든 사원을 조회하세요
select concat(e1.first_name,' ',e1.last_name) as '지정 사원', e1.department_id as '부서 번호', concat(e2.first_name,' ',e2.last_name) as '동일 부서 사원'
from employees e1, employees e2
where e1.employee_id = 100 and e1.department_id = e2.department_id;
	
-- 9. JOB_GRADES 테이블을 생성하고 모든 사원의 이름, 업무,부서이름, 급여 , 급여등급을 조회하세요
select concat(emp.first_name,' ',emp.last_name) 이름, jobs.job_title, dept.department_name, emp.salary, jg.grade_level
from employees emp, departments dept, jobs, job_grades jg
where emp.job_id = jobs.job_id and emp.department_id = dept.department_id and salary between jg.lowest_sal and jg.highest_sal
order by jg.grade_level;



CREATE TABLE job_grades(
    grade_level char(1) primary key,
    lowest_sal int,
    highest_sal int
);
insert into job_grades values('A',1000,2999);
insert into job_grades values('B',3000,5999);
insert into job_grades values('C',6000,9999);
insert into job_grades values('D',10000,14999);
insert into job_grades values('E',15000,24999);
insert into job_grades values('F',25000,40000);
COMMIT;
select * from job_grades;