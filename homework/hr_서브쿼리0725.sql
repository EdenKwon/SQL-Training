use hr;

select * from countries;
select * from departments;
select * from employees;
select * from job_grades;
select * from job_history;
select * from jobs;
select * from locations;
select * from regions;

-- [문제 1] HR 부서의 어떤 사원은 급여정보를 조회하는 업무를 맡고 있다. Tucker(last_name) 사원보다 
-- 급여를 많이 받고 있는 사원의 성과 이름(Name으로 별칭), 업무, 급여를 출력하시오
select 
	concat(emp.first_name,' ',emp.last_name) 이름,
    jobs.job_title 업무,
    emp.salary 급여 from employees emp,
    jobs 
where 
	emp.job_id = jobs.job_id 
    and emp.salary > (
		select 
			salary 
		from 
			employees 
        where 
			last_name = 'Tucker'
	);

-- [문제 2] 사원의 급여 정보 중 업무별 최소 급여를 받고 있는 사원의 성과 이름(Name으로 별칭), 업무, 
-- 급여, 입사일을 출력하시오
select 
	concat(emp.first_name,' ',emp.last_name) 이름,
	jobs.job_title 업무,
    emp.salary 급여,
    emp.hire_date 입사일
from 
	employees emp,
    jobs 
where 
	emp.job_id = jobs.job_id
group by 
	jobs.job_id
having 
	min(salary);

-- [문제 3] 소속 부서의 평균 급여보다 많은 급여를 받는 사원에 대하여 사원의 성과 이름(Name으로 별칭), 
-- 급여, 부서번호, 업무를 출력하시오 // keep
select 
	concat(emp.first_name,' ',emp.last_name) 이름,
    emp.salary 급여, 
    emp.department_id 부서번호, 
    jobs.job_title 업무
from 
	employees emp, 
    departments dept ,
    jobs
where
	emp.department_id = dept.department_id
	and emp.job_id = jobs.job_id
	and emp.salary > (
        SELECT 
            AVG(e.salary)
        FROM 
            employees e
        WHERE 
            e.department_id = emp.department_id
    );

-- [문제 4] 사원들의 지역별 근무 현황을 조회하고자 한다. 도시 이름이 영문 'O' 로 시작하는 지역에 살고 
-- 있는 사원의 사번, 이름, 업무, 입사일을 출력하시오
select 
	emp.employee_id 사번, 
	concat(emp.first_name,' ',emp.last_name) 이름,
    jobs.job_title 업무, 
    emp.hire_date 입사일 from employees emp, 
    departments dept, 
    locations loc,
    jobs
where
	emp.department_id = dept.department_id 
    and dept.location_id = loc.location_id 
    and jobs.job_id = emp.job_id 
    and loc.city like 'O%';

-- [문제 5] 모든 사원의 소속부서 평균연봉을 계산하여 사원별로 성과 이름(Name으로 별칭), 업무, 급여, 부
-- 서번호, 부서 평균연봉(Department Avg Salary로 별칭)을 출력하시오 /keep
select 
	concat(emp.first_name, ' ', emp.last_name) as 이름,
    jobs.job_title as 업무,
    emp.salary as 급여,
    emp.department_id as 부서번호,
    avg_sal.평균연봉 as '부서 평균연봉'
from -- 조회 해야 할 세 테이블과 서브쿼리로 조회한 테이블까지 같이 조인
	employees emp,
    departments dept,
    jobs, 
	(
		select 
			dept.department_id 사번, 
            avg(salary) 평균연봉
		from 
			employees emp, 
			departments dept 
		where 
			emp.department_id = dept.department_id
		group by 
			emp.department_id
	) avg_sal -- 모든 사원의 소속부서 평균연봉을 계산
where 
	emp.department_id = dept.department_id 
    and emp.job_id = jobs.job_id 
    and dept.department_id = avg_sal.사번;

-- select avg(salary) from employees emp, departments dept where emp.department_id = dept.department_id
-- group by emp.department_id;

-- [문제 6] ‘Kochhar’의 급여보다 많은 사원의 정보를 사원번호,이름,담당업무,급여를 출력하시오.
select 
	emp.employee_id 사번,
    concat(emp.first_name,' ',emp.last_name) 이름,
    jobs.job_title 업무,
    emp.salary 급여
from 
	employees emp, 
    jobs 
where 
	emp.job_id = jobs.job_id
    and emp.salary > 
    (
		select 
			salary 
		from 
			employees 
        where 
			last_name = 'Kochhar'
	);

-- [문제 7] 급여의 평균보다 적은 사원의 사원번호,이름,담당업무,급여,부서번호를 출력하시오
select 
	emp.employee_id 사번, 
    concat(emp.first_name,' ',emp.last_name) 이름,
    jobs.job_title 업무, 
    emp.salary 급여,
    dept.department_id 부서번호
from 
	employees emp, 
    departments dept,
    jobs 
where 
	emp.department_id = dept.department_id 
	and emp.job_id = jobs.job_id 
    and emp.salary < (
		select 
			avg(salary) 
		from 
			employees
	);

-- [문제 8] 100번 부서의 최소 급여보다 최소 급여가 많은 다른 모든 부서를 출력하시오
select 
	dept.department_name 
from 
	employees emp,
    departments dept 
where 
	emp.department_id = dept.department_id 
group by 
	dept.department_id
having
	min(emp.salary) > (
		select
			min(e.salary)
		from 
			employees e
        where 
			e.department_id = 100
	);

-- [문제 9] 업무별로 최소 급여를 받는 사원의 정보를 사원번호,이름,업무,부서번호를 출력하시오
-- 출력시 업무별로 정렬하시오
select 
	emp.employee_id 사번, 
    concat(emp.first_name,' ',emp.last_name) 이름,
    jobs.job_title 업무,
    dept.department_id 부서번호 from employees emp, 
    jobs, 
    departments dept 
where 
	emp.department_id = dept.department_id 
	and emp.job_id = jobs.job_id 
group by 
	dept.department_id 
having 
	min(emp.salary) 
order by 
	jobs.job_title;

-- [문제 10] 100번 부서의 최소 급여보다 최소 급여가 많은 다른 모든 부서를 출력하시오 // 중복
select 
	dept.department_name 
from 
	employees emp,
	departments dept 
where 
	emp.department_id = dept.department_id 
group by 
	dept.department_id
having 
	min(emp.salary) > (
		select 
			min(e.salary) 
		from 
			employees e 
		where 
        e.department_id = 100
	);

-- [문제 11] 업무가 SA_MAN 사원의 정보를 이름,업무,부서명,근무지를 출력하시오. //서브쿼리 써야지!
select 
	concat(emp.first_name,' ',emp.last_name) 이름, 
    jobs.job_title 업무,
    dept.department_name 부서명, 
    loc.city 근무지
from 
	employees emp,
    departments dept, 
    jobs, 
    locations loc
where 
	emp.department_id = dept.department_id 
    and emp.job_id = jobs.job_id 
    and dept.location_id = loc.location_id
	and jobs.job_id = 'SA_MAN';

-- [문제 12] 가장 많은 부하직원을 갖는 MANAGER의 사원번호와 이름을 출력하시오 max(count(emp.manager_id))? // keep
SELECT e.employee_id
     , CONCAT(e.first_name, ' ', e.last_name) AS Name
FROM employees e
WHERE e.employee_id = (SELECT manager_id
                       FROM employees e
                       GROUP BY manager_id
                       ORDER BY COUNT(manager_id) DESC
                       LIMIT 1);

-- [문제 13] 사원번호가 123인 사원의 업무와 같고
-- 사원번호가 192인 사원의 급여(SAL))보다 많은 사원의 사원번호,이름,직업,급여를 출력하시오
select 
	emp.employee_id 사번,
	concat(emp.first_name,' ',emp.last_name) 이름, 
    jobs.job_title 직업,
    emp.salary 급여
from 
	employees emp, 
    jobs 
where 
	emp.job_id = jobs.job_id 
	and emp.job_id = (select job_id from employees where employee_id = 123)
	and emp.salary > (select salary from employees where employee_id = 192);

-- [문제 14] 50번 부서에서 최소 급여를 받는 사원보다 많은 급여를 받는 사원의 사원번호,이름,업무,입사일
-- 자,급여,부서번호를 출력하시오.  단 50번 부서의 사원은 제외합니다.
select 
	emp.employee_id 사번, 
    concat(emp.first_name,' ',emp.last_name) 이름, 
    jobs.job_title 업무, 
    emp.hire_date 입사일, 
    emp.salary 급여, 
    emp.department_id 부서번호
from 
	employees emp,
    departments dept,
    jobs
where
	emp.department_id = dept.department_id 
    and emp.job_id = jobs.job_id 
    and emp.salary > (
		select 
			min(e.salary) 
		from 
        	employees e 
        where 
			e.department_id = 50
	)
	and emp.department_id <> 50;

-- [문제 15]  (50번 부서의 최고 급여)를 받는 사원 보다 많은 급여를 받는 사원의 사원번호,이름,업무,입사일
-- 자,급여,부서번호를 출력하시오.  단 50번 부서의 사원은 제외합니다
select 
	emp.employee_id 사번, 
    concat(emp.first_name,' ',emp.last_name) 이름, 
    jobs.job_title 업무, 
    emp.hire_date 입사일, 
    emp.salary 급여,
    emp.department_id 부서번호
from 
	employees emp,
	departments dept, 
    jobs
where 
	emp.department_id = dept.department_id 
    and emp.job_id = jobs.job_id 
    and emp.salary > (
		select 
			max(e.salary) 
        from 
			employees e 
        where 
			e.department_id = 50
        )
and 
	emp.department_id <> 50;
