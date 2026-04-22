CREATE USER c##madang IDENTIFIED BY madang -- c##madang 계정 생성, madnag 비밀번호
 DEFAULT TABLESPACE users -- 데이터 저장 창고 지정
 TEMPORARY TABLESPACE temp -- 임시 작업 공간 지정
 QUOTA UNLIMITED ON users; -- 창고 공간 무제한
GRANT CONNECT, RESOURCE TO c##madang; -- c##madang 계정에 db접속, 테이블생성 등 권한 부여
ALTER USER c##madang ACCOUNT UNLOCK; -- 혹시몰라서 계정 잠금 해제

CREATE TABLE users (
    id INT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT sysdate
);

ALTER TABLE users ADD email VARCHAR(100);

ALTER TABLE users MODIFY username VARCHAR(100);

ALTER TABLE users DROP COLUMN email;

DROP TABLE users;

TRUNCATE TABLE users;

CREATE TABLE if not exists orders (
    order_id INT PRIMARY KEY,                           -- 기본키
    user_id INT NOT NULL,                               -- 빈 값 불가
    product_name VARCHAR(50) UNIQUE,                    -- 중복 불가
    quantity INT CHECK (quantity > 0),                  -- 0보다 큰 값만 허용
    order_date DATE DEFAULT CURRENT_DATE,               -- 생략 시 오늘 날짜
    constraint us_fr_key FOREIGN KEY (user_id) REFERENCES users(id) on delete cascade     -- 외래키 연결
);

부모데이터 삭제시 외래키 옵션
on delete restrict(기본값) / cascade / set null

desc orders; : 테이블 구조보기

-- 지정한 컬럼에만 값을 넣을 때 (나머지 컬럼은 NULL이나 DEFAULT 값이 들어감)
INSERT INTO users (id, username, email) VALUES (1, '홍길동', 'hong@test.com');

-- 테이블의 모든 컬럼에 순서대로 값을 넣을 때는 컬럼명을 생략할 수 있습니다.
INSERT INTO users VALUES (2, '김철수', 'kim@test.com', '010-1234-5678', SYSDATE);

-- id가 1인 사용자의 이메일과 이름을 변경
UPDATE users SET email = 'new_hong@test.com', username = '홍길동_수정' WHERE id = 1;

-- id가 1인 사용자 데이터(행 전체) 삭제
DELETE FROM users WHERE id = 1;

-- 1. 시스템 권한: user_a에게 DB 접속 권한과 테이블 생성 권한 주기(with grant option : 다른사람에게도 권한줄수 있음)
GRANT CREATE SESSION, CREATE TABLE TO user_a with grant option;

-- 2. 객체 권한: user_b에게 'employees' 테이블의 조회(SELECT) 및 추가(INSERT) 권한 주기
GRANT SELECT, INSERT ON employees TO user_b;

-- 3. 모든 객체 권한 한 번에 주기
GRANT ALL PRIVILEGES ON employees TO user_c;

-- 1. 시스템 권한 회수: user_a에게서 테이블 생성 권한 뺏기
REVOKE CREATE TABLE FROM user_a;

-- 2. 객체 권한 회수: user_b에게서 'employees' 테이블의 추가(INSERT) 권한만 뺏기
REVOKE INSERT ON employees FROM user_b;



예약 날짜가 2024년 1월 1일 이후인 고객 정보와 예약 내용을 출력하시오
select * from 고객 left outer join 예약 on 고객.고객번호 = 예약.고객번호 and 예약.날짜 > to_date('2024-01-01', 'YYYY-MM-DD');

강남에 있는 모든 극장을 예약한 고객의 이름과 극장번호를 출력하시오
select c.이름 from 고객 c join 예약 r on c.고객번호 = r.고객번호
  2  join 극장 t on r.극장번호 = t.극장번호
  3  where t.위치 = '강남'
  4  group by c.이름
  5  having count(distinct t.극장번호) = (select count(*) from 극장 where 위치 = '강남');

모든 과목에 등록한 학생의 이름을 보이시오
select s.이름 from 학생 s where not exists (select 과목코드 from 과목 minus select 과목코드 from 수강 e where e.학번 = s.학번)

박지성이 구매하지 않은 도서
select b.bookname from book b where not exists (select 1 from orders o 
join customer c on o.custid = c.custid where o.bookid = b.bookid and c.name = '박지성');

도서의 가격(Book테이블)과 판매가격(Orders 테이블)의 차이가 가장 많은 주문을 구하시
오
select orderid, bookname, 차이액 from (
    select o.orderid, b.bookname, (b.price - o.saleprice) as 차이액, 
    rank() over(order by (b.price-o.saleprice) desc) as rnk 
    from orders o join book b on o.bookid = b.bookid
) where rnk = 1;

‘박지성’이 구매한 도서의 출판사와 같은 출판사의 도서를 구매한 고객의 이름을 구하시오
select distinct c.name from customer c join orders o on o.custid = c.custid join book b on o.bookid = b.bookid where c.name != '박지성' and b.publisher in  
(select b2.publisher from book b2 join orders o2 on o2.bookid = b2.bookid join customer c2 on c2.custid = o2.custid 
where c2.name = '박지성');

두 개 이상의 서로 다른 출판사의 도서를 구매한 고객의 이름을 구하시오
select c.name from customer c where exists 
(select 1 from orders o join book b on o.bookid = b.bookid where o.custid = c.custid having count(distinct b.publisher) >= 2);

전체 고객의 30%이상이 구매한 책 리스트를 구하시오
select b.bookid, b.bookname from book b where b.bookid in (select o.bookid from orders o group by o.bookid
having count(distinct o.custid) >= (select count(*)*0.3 from customer));

select b.bookid, b.bookname from book b where exists (select 1 from orders o where b.bookid = o.bookid
having count(distinct o.custid) >= (select count(*)*0.3 from customer));

마당서점 데이터베이스에서 주문에 관한 사항은 Orders테이블에 저장되어 있다. Orders 테이블을 사용하여 도서번호(bookid)가 1번인 책은 주문하였으나 2번과 3번 책은 주
문하지 않은 고객의 아이디(custid)를 찾는 SQL문을 작성하시오
select custid from orders where bookid = '1'
minus
select distinct custid from orders where bookid = '2' or bookid = '3';
-- 다른 버전
select distinct o.custid from orders o where o.bookid = '1' and 
not exists (select 1 from orders o2 where o2.custid = o.custid and (o2.bookid = '2' or o2.bookid = '3'));

⓽평균 급여가 가장 높은 부서의 번호를 출력하시오. 
select deptno from emp group by deptno having avg(sal) = (select max(avg(sal)) from emp e2 group by deptno);
select deptno from (
    select e.deptno, rank() over(order by avg(sal) desc) as rnk
    from emp e
    group by e.deptno
) where rnk = 1;

⓶각 부서에서 가장 높은 급여를 받는 사원의 이름, 급여, 부서번호를 출력하시오. 
# 상관쿼리
select e.ename, e.sal, e.deptno from emp e where e.sal = (select max(e2.sal) from emp e2 where e.deptno = e2.deptno);
# 가상테이블 조인
select e.ename, e.sal, e.deptno from emp e join (select e2.deptno, max(e2.sal) as max_sal from emp e2 group by e2.deptno) m on e.deptno = m.deptno
and e.sal = m.max_sal;

⓻입사일이 가장 최근인 사원과 가장 오래된 사원을 함께 출력하시오. 
select * from (select e.*, RANK() OVER(order by hiredate asc) as rnk, count(*) over() as total_count from emp e) where rnk = 1 or rnk = total_count;

⑫급여가 모든 CLERK보다 많은 사원의 이름과 급여를 출력하시오(ALL)
select ename, sal from emp where sal > all(select sal from emp where job = 'CLERK');
# all, any는 비교연산자 뒤에서 의미 추가해주는 역할. all은 전부, any는 하나만이라도 만족하면 true

⑬SALESMAN 중 누구보다도 급여가 많은 사원의 이름과 급여를 출력하시오.(ANY)
select ename, sal from emp where sal > any(select sal from emp where job = 'SALESMAN');

⑬사원의 이음, 입사일, 입사 요일을 부서이름과 함께 출력하시오. 
select d.dname, e.ename, e.hiredate, to_char(e.hiredate, 'DAY') from emp e join dept d on e.deptno = d.deptno;
# 날짜 요일로 바꿀때: to_char(date, 'DAY' / 'DA' / 'D') ('목요일' / '목' / '숫자로 바꿈(1~7)')

⑭같은 부서에서 근무하는 사원끼리 이름을 나란히 출력하시오.(셀프 조인, 중복제거)
select e.deptno, e.ename, e2.ename from emp e join emp e2 on e.deptno = e2.deptno and e.ename < e2.ename;

⓷직원별 총 급여(sal*12+comm)를 내림차순으로 출력하시오. 
select ename, sal*12+nvl(comm,0) as 총급여 from emp order by 총급여 desc;
null 확인할때 nvl()

⑤입사년도별 사원 수를 출력하시오. 
select to_char(hiredate,'yyyy') as 입사년도, count(*) from emp group by 입사년도;
# 날짜 연도로 바꿀때 to_char(date, 'yyyy') / 'mm' / 'dd'


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

⓻급여가 자신이 속한 부서 평균보다 높은 직원의 이름,급여,부서번호를 출력하시오(상관부속질의)
select e.last_name, e.salary, e.department_id from employees e 
where e.salary > (select avg(e2.salary) from employees e2 where e.department_id = e2.department_id);


⓾FI_ACCOUNT 직원 중 급여가 FI_ACCOUNT 평균보다 높은 직원을 출력하시오.
select employee_id, last_name from (
    select e.*, avg(e.salary) over(partition by e.department_id) as 평균
    from employees e
) where department_id = (select department_id from departments where department_name = 'FI_ACCOUNT')
and salary > 평균;

문제 9.
고객별로 가장 비싸게 구매한 도서명과 그 금액을 보여주는 뷰 v_cust_max_order를 작
성하시오.
(출력 컬럼: 고객이름, 도서명, 최고구매금액)
select name, bookname, saleprice
from (
    select c.name, b.bookname, o.saleprice, rank() over(partition by c.name order by o.saleprice desc) as rnk
    from customer c join orders o on c.custid = o.custid join book b on o.bookid = b.bookid
) where rnk = 1


문제 10.
도서명, 고객이름, 판매가, 해당 도서 평균 판매가, 평균 대비 차이를 보여주는 뷰
v_book_price_compare를 작성하시오.
(출력 컬럼: 도서명, 고객이름, 판매가, 도서평균판매가, 차이)
create view v_book_price_compare as (
    select b.bookname, c.name, o.saleprice, m.평균판매가, (o.saleprice-m.평균판매가) as 차이
    from customer c join orders o on c.custid = o.custid join book b on o.bookid = b.bookid
    join (select o2.bookid, avg(o2.saleprice) as 평균판매가 from orders o2 group by o2.bookid) m on o.bookid = m.bookid
);

문제 6.
도서 정가 대비 평균 할인율이 가장 높은 출판사 순으로 보여주는 뷰
v_publisher_discount_rate를 작성하시오.
(출력 컬럼: 출판사, 평균할인율)
단, 정가보다 낮게 팔린 경우만 포함한다. 
create view v_publisher_discount_rate as
    select b.publisher, avg(b.price-o.saleprice/b.price * 100) as 평균할인율
    from book b join orders o on b.bookid = o.bookid
    where b.price > o.saleprice
    group by b.publisher
    order by 평균할인율 desc;


    문제 7.
한 번이라도 주문한 적 있는 고객과 한 번도 주문하지 않은 고객을 구분하여 보여주는 뷰
v_customer_order_status를 작성하시오.
(출력 컬럼: 고객이름, 주문여부)
단, 주문여부는 '주문있음' / '주문없음'으로 표시한다. 
# case when ~ then ~ else ~ end as ~ : select 문에서 if문 쓰고싶을때
create or replace view v_customer_order_states as
    select distinct c.name,
    case
        when o.orderid is not null then '주문있음'
        else '주문없음'
    end as 주문여부
    from customer c left outer join orders o on c.custid = o.custid;

문제 4.
입사일이 2019년 이전인 사원의 사원번호, 이름, 부서명, 입사일, 근속연수를 보여주는 뷰
v_veteran_employee를 작성하시오.
(근속연수는 현재 연도 기준으로 계산)
create view v_veteran_employee as 
    select e.empno, e.ename, d.dname, e.hiredate, trunc(months_between(sysdate, e.hiredate)/12) as 근속연수
    from emp e join dept d on e.deptno = d.deptno
    where e.hiredate < to_date('2019-01-01', 'yyyy-mm-dd');

문제 7.
자신이 속한 부서의 평균 급여보다 높은 급여를 받는 사원의 이름, 부서명, 급여, 부서평
균급여를 보여주는 뷰 v_above_dept_avg를 작성하시오. 
create view v_above_dept_avg as
    select m.ename, m.dname, m.sal, 평균급여 
    from (select e.*, d.*, avg(e.sal) over (partition by e.deptno) as 평균급여
    from emp e join dept d on e.deptno = d.deptno) m
    where m.sal > 평균급여;

문제 10.
부서별로 'PM' 역할을 맡은 사원 수와 해당 부서의 평균 급여를 보여주는 뷰
v_dept_pm_stats를 작성하시오.
(출력 컬럼: 부서명, PM수, 부서평균급여)
create or replace view v_dept_pm_stats as 
    select d.dname, count(case when e.job = 'CLERK' then 1 end) as 사원수, avg(e.sal) as 평균급여
    from emp e join dept d on e.deptno = d.deptno
    group by d.dname;

문제 2.
급여가 10,000원 이상인 판매원의 이름과 급여를 보여주는 읽기 전용 뷰 v_high_salary_sp를 작성하시오. 
create view v_high_salary_sp as
    select name, age from salesperson where salary >= 10000 with read only;

문제 5.
직업이 '개발자'인 고객의 이름, 도시, 직업을 보여주는 뷰 v_developer_customer를 작성하시오. 단, 조건을 벗어나는 데이터는 입력할 수 없도록 설정하시오. 
create view v_developer_customer as
    select * from customer where industrytype = '개발자' with check option;

문제 15.
판매원별로 주문금액의 합계를 구하고, 전체 주문금액 대비 각 판매원의 주문 비중을 보여주는
뷰 v_sp_order_ratio를 작성하시오.
(출력 컬럼 : 판매원이름, 총주문금액, 전체주문금액, 주문비중)
create or replace view v_sp_order_ratio as
    select o1.salesperson, o1.총주문금액, o1.전체주문금액, (o1.총주문금액 / o1.전체주문금액) as 주문비중
    from (
        select distinct o.salesperson, sum(o.amount) over (partition by o.salesperson) as 총주문금액, sum(o.amount) over () as 전체주문금액
        from orders o
    ) o1;

    # sum(sum()) over() : group으로 묶어서 내부 sum 계산 후 그 데이터들 가지고 전체합계 구함
    select salesperson, sum(amount) as 개인합계, sum(sum(amount)) over() as 전체총합 
    from orders
    group by salesperson;


문제 8.
상영관별 예약 건수와 전체 좌석수 대비 예약된 좌석의 비율을 보여주는 뷰 v_screen_reservation_rate를 작성하시오.
(출력 컬럼 : 극장번호, 상영관번호, 영화제목, 좌석수, 예약건수, 예약률) 단, 예약률은 소수점 2자리까지 표시한다. 
create view v_screen_reservation_rate as 
    select s.*, count(*) over (partition by s.극장번호, s.상영관번호)as 예약건수, round(count(*) over(partition by s.극장번호, s.상영관번호)/ s.좌석수, 2) as 예약률
    from 상영관 s join 예약 y on s.극장번호 = y.극장번호 and s.상영관번호 = y.상영관번호;

문제 14.
극장별로 예약 건수가 가장 많은 상영관의 극장이름, 상영관번호, 영화제목, 예약건수를 보여주는 뷰 v_most_reserved_screen을 작성하시오. 
# 극장이름, 상영관번호, 영화제목으로 그룹화 되어있는 상태에서 partition by g.극장이름 : 극장이름이 같은 그룹끼리 묶은 후 order by count(*) : 그들끼리 숫자 카운트 해서 정렬 하기

create or replace view v_most_reserved_screen as
    select m.극장이름, m.상영관번호, m.영화제목, m.예약건수, m.rnk from (
        select g.극장이름, s.상영관번호, s.영화제목, count(*) as 예약건수, row_number() over (partition by g.극장이름 order by count(*) desc) as rnk 
        from 극장 g join 상영관 s on g.극장번호 = s.극장번호 join 예약 y on s.극장번호 = y.극장번호 and s.상영관번호 = y.상영관번호
        group by g.극장이름, s.상영관번호, s.영화제목
    ) m where m.rnk = 1;

문제 15.
고객별 총 예약금액을 계산하고전체 예약금액 대비 각 고객의 예약 비중을 보여주는 뷰 v_customer_payment_ratio를 작성하시오.
(출력 컬럼 : 고객이름, 총예약금액, 전체예약금액, 예약비중)
create view v_customer_payment_ratio as
    select 이름, 총예약금액, 전체예약금액, 총예약금액 / 전체예약금액 as 예약비중
    from (
        select k.이름, sum(s.가격) over (partition by k.이름) as 총예약금액, sum(s.가격) over () as 전체예약금액
        from 고객 k join 예약 y on k.고객번호 = y.고객번호 join 상영관 s on s.극장번호 = y.극장번호 and s.상영관번호 = y.상영관번호
    );
    
    9. 영업사원 급여 등급 뷰를 작성하시오
 (급여 구간별로 영업사원을 분류하는 뷰)
create view v34 as
    select s.*,
    case
        when s.salary >= 4000000 then 'A'
        when s.salary >= 3000000 then 'B'
        else 'C'
    end as salary_grade
    from salesperson s;

13. 영업사원 급여 대비 매출 효율 뷰를 작성하시오
(영업사원 급여 대비 총 매출 비율로 효율성 측정 뷰)
create or replace view v38 as
    select distinct s.name, (sum(o.amount) over (partition by s.name) / s.salary) as 매출효율
    from salesperson s join orders o on s.name = o.salesperson