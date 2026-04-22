23
(1)교재 질의
⓵사원의 이름과 업무를 출력하시오. 단 사원의 이름은 ‘사원이름’, ‘업무는 ’사원업무‘, 머리글이 나오도록 출력하시오.
select ename as 사원이름, job as 사원업무 from emp;

⓶30번 부서에 근무하는 모든 사원의 이름과 급여를 출력하시오
select ename, sal from emp where deptno = 30;

⓷사원번호와 이름, 현재급여, 증가된 급여분(열 이름은 증가액), 10% 인상된 급여(열 이름은 ’인상된 급여‘)를 사원 번호 순으로 출력하시오. 
select empno, ename, sal, sal/10 as 증가액, sal*1.1 as 인상된급여 from emp order by empno;

⓸’S’로 시작하는 모든 사원과 부서번호를 출력하시오. 
select ename, empno from emp where ename like 'S%';

⑤모든 사원의 최대 및 최소 급여, 합계 및 평균 급여를 출력하시오. 열이름은 각각 MAX, MIN, SUM, AVG로 한다. 단 소수점 이하는 반올림하여 정수로 출력한다.
select max(sal) as MAX, min(sal) as MIN, sum(sal) as SUM, round(avg(sal), 2) as AVG from emp;

⓺업무(job)별로 동일한 업무를 하는 사원의 수를 출력하시오. 열이름은 각각 ‘업무’ 와 ‘업무별 사원수’로 한다.
select job as 업무, count(*) as "업무별 사원수" from emp group by job;

⓻사원의 최대 급여와 최소 급여의 차액을 출력하시오. 
select max(sal) - min(sal) as 차액 from emp;

⓼30번 부서의 사원 수와 사원들 급여의 합계와 평균을 출력하시오.
select count(*) as 사원수, sum(sal), round(avg(sal),2) from emp where deptno = 30;

⓽평균 급여가 가장 높은 부서의 번호를 출력하시오. 
select deptno from emp group by deptno having avg(sal) = (select max(avg(sal)) from emp e2 group by deptno);
select deptno from (
    select e.deptno, rank() over(order by avg(sal) desc) as rnk
    from emp e
    group by e.deptno
) where rnk = 1;
# max(avg()) 이렇게쓸거면 혼자만 써야됨. 
# 서브쿼리안에서 where로 연결(상관커리) 와 group으로 그룹화 하는거 차이
# 메인쿼리 행마다 한번실행 vs 딱 한번 전체 실행후 메인에 전달

⓾세일즈맨(SALESMAN)을 제외하고, 각 업무별 사원의 총급여가 3000 이상인 업무에 대해서, 업무명과 각 업무별 평균 급여를 출력하시오. 
select job as 업무명, avg(sal) as 평균급여 from emp group by job having sum(sal) >= 3000;

⑪전체 사원 가운데 직속상관이 있는 사원의 수를 출력하시오. 
select count(*) from emp where mgr is not NULL;

⑫EMP 테이블에서 이름, 급여, 커미션 금액(comm), 총액(sal*12+comm)을 구하여 총액이 많은 순서대로 출력하시오. 
select ename, sal, comm, sal*12+comm as 총액 from emp order by 총액 desc;

⑬부서별로 같은 업무를 하는 사람의 인원수를 구하여 부서번호, 업무 이름, 인원수를 출력하시오. 
select deptno, job, count(*) from emp group by deptno,job order by deptno;

⑭사원이 한 명도 없는 부서의 이름을 출력하시오. 
select d.dname from dept d where not exists (select 1 from emp e where d.deptno = e.deptno);

⑮같은 업무를 하는 사람의 수가 4명 이상인 업무와 인원수를 출력하시오. 
select job, count(*) from emp group by job having count(*) >= 4;

⑯사원번호가 7400 이상 7600 이하인 사원의 이름을 출력하시오. 
select ename from emp where empno between 7400 and 7600;

⑰사원의 이름과 사원의 부서이름을 출력하시오. 
select e.ename, d.dname from emp e join dept d on e.deptno = d.deptno;

⑱사원의 이름과 팀장(mgr)의 이름을 출력하시오. 
select e.ename as 사원, e2.ename as 팀장 from emp e join emp e2 on e.mgr = e2.empno;

⑲사원 SCOTT보다 급여를 많이 받는 사람의 이름을 출력하시오. 
select ename from emp where sal > (select sal from emp where ename = 'SCOTT');

⑳사원 SCOTT이 일하는 부서번호 혹은 DALLAS 에 있는 부서번호를 출력하시오
select distinct e.deptno from emp e join dept d on e.deptno = d.deptno where d.loc = 'DALLAS' or e.deptno = (select deptno from emp where ename = 'SCOTT');


(2)단순질의
⓵comm(커미션)이 NULL이 아닌 사원의 이름과 커미션을 출력하시오. 
select ename, comm from emp where comm is not NULL;

⓶급여가 1500이상 3000 이하인 사원의 이름과 급여를 급여 오름차순으로 출력하시오. 
select ename, sal from emp where sal between 1500 and 3000 order by sal;

⓷1981년에 입사한 사원의 이름과 입사일을 출력하시오. 
select ename, hiredate from emp where hiredate between to_date('1981/01/01', 'YYYY/MM/DD') and to_date('1981/12/31', 'YYYY/MM/DD');

⓸이름의 세 번째 글자가 ‘A’인 사원을 출력하시오. 
select * from emp where ename like '__A%';

⑤사원의 이름을 소문자로 출력하시오. 
select lower(ename) from emp;

⓺사원 이름, 입사일, 오늘까지의 근무 개월 수를 출력하시오. 
select ename, hiredate, trunc(months_between(sysdate,hiredate)) as 근무개월수 from emp;
# 개월수 구할때 months_between
# 버림: trunc , 반올림: round, 올림: ceil

⓻사원 이름과 이름의 글자 수를 글자 수 내림차순으로 출력하시오. 
select ename, length(ename) as 글자수 from emp order by 글자수 desc;
# 글자길이 length, len은 mssql

⓼comm이 NULL이면 0으로 대체하여 총소득(sal+comm)을 출력하시오. 
select ename, sal + nvl(comm,0) from emp;
null이면 대체값 지정: nvl

⓽ANALYST 또는 PRESIDENT인 사원의 이름, 업무, 급여를 출력하시오. 
select ename, job, sal from emp where job = 'ANALYST' or job = 'PRESIDENT';

⓾이름 길이가 긴 순, 같으면 알파벳 순으로 사원 이름을 출력하시오.
select ename from emp order by length(ename) desc, ename;


(3)부속질의
⓵JONES와 같은 부서에 근무하는 사원의 이름을 출력하시오(JONES본인 제외)
select ename from emp where deptno = (select deptno from emp where ename = 'JONES') and ename != 'JONES';

⓶각 부서에서 가장 높은 급여를 받는 사원의 이름, 급여, 부서번호를 출력하시오. 
# 상관쿼리
select e.ename, e.sal, e.deptno from emp e where e.sal = (select max(e2.sal) from emp e2 where e.deptno = e2.deptno);
# 가상테이블 조인
select e.ename, e.sal, e.deptno from emp e join (select e2.deptno, max(e2.sal) as max_sal from emp e2 group by e2.deptno) m on e.deptno = m.deptno
and e.sal = m.max_sal;

⓷30번 부서 평균 급여보다 급여가 높은 사원의 이름과 급여를 출력하시오. 
select ename, sal from emp where sal > (select avg(sal) from emp where deptno = 30);

⓸MANAGER 직급 평균 급여보다 적은 CLERK 사원의 이름과 급여를 출력하시오. 
select ename, sal from emp where job = 'CLERK' and sal < (select avg(sal) from emp where job = 'MANAGER');

⑤업무별 최고 급여를 받는 사원의 이름, 업무, 급여를 출력하시오. 
# 상관커리
select e.ename, e.job, e.sal from emp e where e.sal = (select max(e2.sal) from emp e2 where e.job = e2.job);
# 가상테이블 조인
select e.ename, e.job, e.sal from emp e join (select job, max(sal) as max_sal from emp group by job) m on e.job = m.job and e.sal = m.max_sal;

⓺KING에게 직접 보고하는 사원의 이름과 업무를 출력하시오. 
select ename, job from emp where mgr = (select empno from emp where ename = 'KING');

⓻입사일이 가장 최근인 사원과 가장 오래된 사원을 함께 출력하시오. 
select * from (select e.*, RANK() OVER(order by hiredate asc) as rnk, count(*) over() as total_count from emp e) where rnk = 1 or rnk = total_count;
# rank() over(order by ) as rnk : 정렬한 순으로 번호. over(): 행을 압축하지 않고 계산할 범위 지정

⓼전체 평균 급여보다 급여가 높고 직위가 MANAGER인 사원을 출력하시오. 
select * from emp where job = 'MANAGER' and sal > (select avg(sal) from emp);

⓽급여가 전체 사원 급여 합계의 10%를 초과하는 사원이 이름과 급여를 출력하시오. 
select ename, sal from emp where sal > (select)

⓾BLAKE와 같은 직위(job)를 가진 사원의 이름과 급여를 출력하시오(BLAKE 본인 제외)
select ename, sal from emp where job = (select job from emp where ename = 'BLAKE') and ename != 'BLAKE';

⑪30번 부서에 속한 사원과 같은 직위(job)를 가진 모든 사원을 출력하시오. 
select * from emp e where exists (select 1 from emp e2 where e.job = e2.job and e2.deptno = 30);

⑫급여가 모든 CLERK보다 많은 사원의 이름과 급여를 출력하시오(ALL)
select ename, sal from emp where sal > all(select sal from emp where job = 'CLERK');
# all, any는 비교연산자 뒤에서 의미 추가해주는 역할. all은 전부, any는 하나만이라도 만족하면 true

⑬SALESMAN 중 누구보다도 급여가 많은 사원의 이름과 급여를 출력하시오.(ANY)
select ename, sal from emp where sal > any(select sal from emp where job = 'SALESMAN');

⑭부하 직원이 존재하는 (관리자인) 사원의 이름과 직위를 출력하시오(EXITS)
select e.ename, e.job from emp e where exists (select 1 from emp e2 where e2.mgr = e.empno);

⑮급여 상위 3위 안에 드는 사원의 이름과 급여를 출력하시오.
select ename, sal from (select ename, sal, rank() over(order by sal desc) as rnk from emp) where rnk in (1,2,3);


(4)조인질의
⓵사원의 이름과 소속 부서 이름을 출력하시오. 
select e.ename, d.dname from emp e join dept d on e.deptno = d.deptno;

⓶사원의 이름과 팀장의 이름을 출력하시오.(셀프 조인)
select e.ename as 사원, e2.ename as 팀장 from emp e join emp e2 on e.mgr = e2.empno;

⓷사원이 한 명도 없는 부서의 이름을 출력하시오. 
# exists
select d.dname from dept d where not exists (select 1 from emp e where e.deptno = d.deptno);
# join
select dname from dept where dname not in (select d.dname from dept d join emp e on e.deptno = d.deptno);
⓸NEW YORK에 근무하는 사원의 이름과 업무를 출력하시오. 
select e.ename, e.job from emp e join dept d on e.deptno = d.deptno where d.loc = 'NEW YORK'; 

⑤사원이름, 급여, 급여 등급을 출력하시오.(SALGRADE 활용)
select e.ename, e.sal, s.grade from emp e join salgrade s on e.sal between s.losal and s.hisal;

⓺사원이름, 급여, 급여 등급, 부서 이름을 한 번에 출력하시오. 
select e.ename, e.sal, s.grade, d.dname from emp e join salgrade s on e.sal between s.losal and s.hisal
join dept d on e.deptno = d.deptno;

⓻자신의 상관보다 급여가 높은 사원의 이름과 두 사람의 급여를 출력하시오. 
select e.ename, e.sal, e2.sal from emp e join emp e2 on e.mgr = e2.empno where e.sal > e2.sal;

⓼사원 이름, 부서이름, 근무 도시를 출력하시오. 
select e.ename, d.dname, d.loc from emp e join dept d on e.deptno = d.deptno;

⓽CHOICAGO에 근무하는 사원 수를 출력하시오. 
select count(*) from emp e join dept d on e.deptno = d.deptno where d.loc = 'CHICAGO';

⓾부서별 인원 수가 많은 순으로 부서번호, 부서이름, 인원수를 출력하시오. 
select e.deptno, d.dname, count(*) as 인원수 from emp e join dept d on e.deptno = d.deptno group by e.deptno, d.dname order by 인원수 desc;

⑪부서별 평균 급여를 부서이름과 함께 출력하시오. 
select d.dname, round(avg(e.sal),2) from emp e join dept d on e.deptno = d.deptno group by d.dname;

⑫급여 등급이 3등급인 사원의 이름, 급여, 부서이름을 출력하시오. 
select e.ename, e.sal, d.dname from emp e join dept d on e.deptno = d.deptno join salgrade s on e.sal between s.losal and s.hisal where s.grade = 3;

⑬사원의 이음, 입사일, 입사 요일을 부서이름과 함께 출력하시오. 
select d.dname, e.ename, e.hiredate, to_char(e.hiredate, 'DAY') from emp e join dept d on e.deptno = d.deptno;
# 날짜 요일로 바꿀때: to_char(date, 'DAY' / 'DA' / 'D') ('목요일' / '목' / '숫자로 바꿈(1~7)')

⑭같은 부서에서 근무하는 사원끼리 이름을 나란히 출력하시오.(셀프 조인, 중복제거)
select e.deptno, e.ename, e2.ename from emp e join emp e2 on e.deptno = e2.deptno and e.ename < e2.ename;
# !=로 비교하면 중복발생. 동일한 쌍도 없애려면 사전순으로 뒤에 있는 사람만 쌍으로 만들면 됨

⑮사원이름, 상관이름, 상관의 부서이름을 출력하시오(셀프+DEPTt조인)
select e.ename, e2.ename, d.dname from emp e join emp e2 on e.mgr = e2.empno join dept d on e2.deptno = d.deptno;


(5)집계질의
⓵업무별 최고, 최소, 평균 급여와 사원 수를 출력하시오. 
select max(sal), min(sal), avg(sal), count(*) from emp group by job;

⓶부서별, 업무별 인원수를 출력하시오. 
select deptno, job, count(*) from emp group by deptno, job order by deptno, job;

select to_char(deptno), count(*) as 인원수 from emp group by deptno
union all
select job, count(*) as 인원수 from emp group by job;

select deptno, job, count(*) as 인원수 from emp group by grouping sets (deptno, job);

⓷직원별 총 급여(sal*12+comm)를 내림차순으로 출력하시오. 
select ename, sal*12+nvl(comm,0) as 총급여 from emp order by 총급여 desc;

⓸평균 급여보다 높은 급여를 받는 부서(번호)와 해당 부서의 평균 급여를 출력하시오
select deptno, avg(sal) from emp group by deptno having avg(sal) > (select avg(sal) from emp);

⑤입사년도별 사원 수를 출력하시오. 
select to_char(hiredate,'yyyy') as 입사년도, count(*) from emp group by 입사년도;
# 날짜 연도로 바꿀때 to_char(date, 'yyyy') / 'mm' / 'dd'

⓺급여 등급별 사원 수와 평균 급여를 출력하시오
select s.grade, count(*), round(avg(sal),2) from emp e join salgrade s on e.sal between s.losal and s.hisal group by s.grade;

⓻총급여가 5000 이상인 부서의 번호와 합계를 출력하시오. 
select deptno, sum(sal) from emp group by deptno having sum(sal) >= 5000;

⓼각 사원의 급여가 전체 급여 합계에서 차지하는 비율(%)을 출력하시오. 
select ename, sal/(sum(sal) over()) as 비율 from emp;
# 행을 뭉치지 않고 계산만 하게하는 함수: over(). where절에 비율 써야되면 서브쿼리로 from 안에 들어가야됨

⓽근속 연수 10년 이상인 사원의 이름, 입사일, 근속 연수를 출력하시오. 
select ename, hiredate, 근속연수 from (
    select e.*, trunc(months_between(sysdate,e.hiredate) / 12) as 근속연수
    from emp e
) where 근속연수 >=10;
# select 절에서 정의한걸 where절에 가져다 쓰려면 from 안에 서브쿼리로 들어가야됨

⓾급여 상위 5명의 사원 이름과 급여를 출력하시오
select ename, sal from (
    select e.*, rank() over(order by e.sal desc) as rnk
    from emp e
) where rnk in (1,2,3,4,5);
# rank() over(정렬방식) as rnk: from 안에서 정의.


24
(1)교재 질의
⓵Employees와 Departments테이블에 저장된 튜프의 개수를 출력하시오. 
select count(e.employee_id), count(distinct d.department_id) from employees e full outer join departments d on e.department_id = d.department_id;

⓶Employees테이블에 대한 employee_id, job_id, hire_date,를 출력하시오. 
select employee_id, job_id, hire_date from employees;

⓷Employees테이블에서 salary가 12,000이상인 last_name과 salary를 출력하시오. 
select last_name, salary from employees where salary >=12000;

⓸부서번호(department_id)가 20 혹은 50인 직원의 last_name과 department_id를 last_name에 대하여 오름차순으로 출력하시오. 
select last_name, department_id from employees where department_id = 20 or department_id = 50 order by last_name;

⑤last_name의 세 번째에 a가 들어가는 직원의 last_name을 출력하시오. 
select last_name from employees where last_name like '__a%';

⓺같은 일(job)을 하는 사람의 수를 세어 출력하시오
select job_id, count(*) from employees group by job_id;

⓻급여(salary)의 최대값과 최소값의 차이를 구하시오. 
select max(salary) - min(salary) from employees;

⓼Toronto에서 일하는 직원의 last_name, job,department_id,Department_name을 출력하시오.
select e.last_name, j.job_title, e.department_id, d.department_name from employees e join departments d on e.department_id = d.department_id
join jobs j on e.job_id = j.job_id
where d.location_id = (select location_id from locations where city = 'Toronto');


(2)부속질의
⓵전체 직원 평균 급여보다 많이 받는 직원의 last_name과 salary를 출력하시오
select last_name, salary from employees where salary >= (select avg(salary) from employees);

⓶dea hann과 같은 job_id를 가진 직원의 last_name과 job_id를 출력하시오. 
select last_name, job_id from employees where job_id = (select job_id from employees where last_name = 'De Haan');

⓷부서별 최고 급여를 받는 직원의 last_name, department_id를 출력하시오. 
# 상관질의
select last_name, department_id from (
    e.last_name, e.department_id,
    rank() over(partition by e.department_id order by e.salary desc) as rnk
    from employee e
) where rnk = 1;
RANK(),공동 순위만큼 건너뜀,"1등, 1등, 3등"
DENSE_RANK(),공동 순위가 있어도 연속됨,"1등, 1등, 2등"
ROW_NUMBER(),중복 없이 무조건 고유 번호,"1등, 2등, 3등"

⓸IT부서 직원의 평균 급여보다 많이 받는 직원의 last_name과 salary를 출력하시오. 
select last_name, salary from employees 
where salary > (select avg(e.salary) from employees e join departments d on e.department_id = d.department_id where d.department_name = 'IT');

⑤직무이력(JOB_HISTORY)이 있는 직원의 last_name과 현재 job_id를 출력하시오. 
select e.last_name, e.job_id from employees e where exists (select 1 from job_history h where e.employee_id = h.employee_id);

⓺직무이력이 없는 직원의 last_name과 employee_id를 출력하시오. 
select e.last_name, e.job_id from employees e where not exists (select 1 from job_history h where e.employee_id = h.employee_id);


⓻급여가 자신이 속한 부서 평균보다 높은 직원의 이름,급여,부서번호를 출력하시오(상관부속질의)
select e.last_name, e.salary, e.department_id from employees e 
where e.salary > (select avg(e2.salary) from employees e2 where e.department_id = e2.department_id);

⓼kochhar(101)를 관리자로 두는 직원의 이름과 급여를 출력하시오. 
select last_name, salary from employees where manager_id = 101;

⓽급여 최상위 3명의 last_name과 salary를 출력하시오. 
select last_name, salary from (
    select e.*,
    rank() over(order by e.salary desc) as rnk
    from employees e
) where rnk in (1,2,3);

⓾FI_ACCOUNT 직원 중 급여가 FI_ACCOUNT 평균보다 높은 직원을 출력하시오.
select employee_id, last_name from (
    select e.*, avg(e.salary) over(partition by e.department_id) as 평균
    from employees e
) where department_id = (select department_id from departments where department_name = 'FI_ACCOUNT')
and salary > 평균;

select employee_id, last_name from (
    select e.*, (select avg(salary) from employees where department_name = 'FI_ACCOUNT') as 평균
    from employees e
) where salary > 평균 and department_id = (select department_id from departments where department_name = 'FI_ACCOUNT');
# 안합치고 집계함수 쓰고싶을때 from절에서 over함수 (partition by, order by 등)
 