use hr;

select * from regions;
select * from locations;
select * from employees;
select * from departments;
select * from job_history;
select * from jobs;
select * from job_grades;

-- [문제 0] hr 스키마에 존재하는 Employees, Departments, Locations 테이블의  구조를 파악한 후 
-- Oxford에 근무하는 사원의 성과 이름(Name으로 별칭), 업무, 부서명, 도시명을 출력하시오. 이때 첫 번째 
-- 열은 회사명인 ‘Han-Bit’이라는 상수값이 출력되도록 하시오

select 
	'Han-bit' as 회사명 ,
    concat(emp.first_name,' ',emp.last_name) 'Name',
    jobs.job_title 업무,
    dept.department_name 부서명,
    loc.city 도시명
from 
	employees emp,
    departments dept, 
    locations loc, 
    jobs
where 
	emp.department_id = dept.department_id
	and dept.location_id = loc.location_id 
    and jobs.job_id = emp.job_id 
    and loc.city = 'Oxford';

-- [문제 1] HR 스키마에 있는 Employees, Departments 테이블의 구조를 파악한 후 사원수가 5명 이상인 
-- 부서의 부서명과 사원수를 출력하시오. 이때 사원수가 많은 순으로 정렬하시오

select 
	dept.department_name, 
    count(emp.employee_id) 
from 
	employees emp, 
    departments dept
where 
	emp.department_id = dept.department_id
group by
	emp.department_id
having 
	count(dept.department_id) >= 5;


-- [문제 2] 각 사원의 급여에 따른 급여 등급을 보고하려고 한다. 급여 등급은 JOB_GRADES 테이블에 표시
-- 된다. 해당 테이블의 구조를 살펴본 후 사원의 성과 이름(Name으로 별칭), 업무, 부서명, 입사일, 급여, 
-- 급여등급을 출력하시오

select 
	concat(emp.first_name,' ',emp.last_name) 이름,
    jobs.job_title 업무,
    dept.department_name 부서명,
    emp.hire_date 입사일,
    emp.salary 급여,
    jg.grade_level
from 
	employees emp,
    departments dept,
    job_grades jg,
    jobs
where 
	emp.department_id = dept.department_id 
	and emp.job_id = jobs.job_id 
    and emp.salary between jg.lowest_sal
    and jg.highest_sal;

-- [문제 3] 각 사원과 직속 상사와의 관계를 이용하여 다음과 같은 형식의 보고서를 작성하고자 한다. 
-- □예 홍길동은 허균에게 보고한다 → Eleni Zlotkey report to Steven King
-- 어떤 사원이 어떤 사원에서 보고하는지를 위 예를 참고하여 출력하시오. 단, 보고할 상사가 없는 사원이 
-- 있다면 그 정보도 포함하여 출력하고, 상사의 이름은 대문자로 출력하시오
-- concat(e1.first_name,' ',e1.last_name,' report to ',e2.first_name,' ',e2.last_name), concat(e2.first_name,' ',e2.last_name,'is top manager'))
select ifnull(
	concat(e1.first_name,' ',e1.last_name,' report to ',upper(e2.first_name),' ',upper(e2.last_name)),
    concat(upper(e1.first_name),' ',upper(e1.last_name),' is top manager')) 보고서
from 
	employees e1 
left outer join employees e2
on 
	e1.manager_id = e2.employee_id;
