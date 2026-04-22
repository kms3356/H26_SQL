(1)학생 수강 전체 현황 뷰를 작성하시오.
(학생정보+수강 과목+성적을 한 분에 확인가능하도록 작성)
create view v1 as
    select h.*, g.과목이름, s.성적 from 학생 h join 수강 s on h.학번 = s.학번 join 과목 g on g.과목코드 = s.과목코드;
    
(2)각 학생별 평균 성적 뷰를 작성하시오.
(각 학생의 전체 수강 과목 평균 성적 계산 뷰)
create or replace view v2 as
    select h.학번, h.이름, avg(s.성적) as 과목평균 from 학생 h join 수강 s on h.학번 = s.학번
    group by h.학번, h.이름;
(3)과목별 수강 인원 및 평균 성적 뷰를 작성하시오.
(각 과목의 수강 인원과 평균, 최고,최저 성적 통계 뷰)
create view v3 as
    select g.과목코드, count(s.학번) as 수강인원, avg(s.성적) as 평균, min(s.성적) as 최저, max(s.성적) as 최고주문금액
    from 수강 s join 과목 g on g.과목코드 = s.과목코드
    group by g.과목코드;

(4)성적 우수 학생 뷰를 작성하시오.(평균 90점 이상)
(평균 성적이 90점 이상이 우수 학생만 조회하는 뷰)
create view v4 as
    select h.학번, h.이름, avg(s.성적) as 평균 from 학생 h join 수강 s on h.학번 = s.학번
    group by h.학번, h.이름
    having 평균 >= 90;
(5)전공 별 수강 통계 뷰를 작성하시오. 전공별 총 수강 건수와 전공 평균 성적 비교 뷰)
create view v5 as
    select h.전공, count(*) as 총수강건수, avg(s.성적) as 전공평균성적 from 학생 h join 수강 s on h.학번 = s.학번
    group by h.전공;

(6)학기별 수강 현황 뷰를 작성하시오.
create view v6 as
    select s.수강학기, count(*) as 수강수 from 수강 s group by s.수강학기;

(7)미수강 학생 뷰를 작성하시오.
create view v7 as 
    select h.* from 학생 h where not exists (select 1 from 수강 s where s.학번 = h.학번);

(8)담당 교수별 강의 및 수강 현황 뷰를 작성하시오.
 과목별 담당 과목 수와 총 수강 학생수를 집계하는 뷰)
create or replace view v8 as
    select g.담당교수, count(distinct g.과목코드) as 과목수, count(s.학번) as 학생수
    from 수강 s join 과목 g on g.과목코드 = s.과목코드
    group by g.담당교수;

(9)학년별 수강 과목 수 및 평균 성적 뷰를 작성하시오.
(학년에 따른 수강 부담과 성적 추이를 파악하는 뷰 작성)
create view v9 as
    select h.학년, count(distinct s.과목코드) as 수강과목수, avg(s.성적) as 평균성적
    from 학생 h join 수강 s on h.학번 = s.학번
    group by h.학년;

(10)성적 미입력(NULL) 수강 내역 뷰를 작성하시오.
(성적이 아직 입력되지 않은 수강 내역 관리용이다.)
create view v10 as
    select * from 수강 where 성적 is NULL;


 뷰 생성 질의어 15개
1. 전체 상영 정보 통합 뷰를 작성하시오.
(극장 + 상영관 + 영화 정보를 한눈에 확인 가능하도록 작성)
create view v11 as 
    select g.*, s.상영관번호, s.영화제목, s.가격, s.좌석수 from 극장 g join 상영관 s on g.극장번호 = s.극장번호;

2 .예약 전체 현황 뷰를 작성하시오
(고객이 어떤 극장·상영관·영화를 예약했는지 통합 조회하도록 작성)
create view v12 as
    select y.*, s.영화제목 from 예약 y join 상영관 s on y.극장번호 = s.극장번호 and y.상영관번호 = s.상영관번호;

3. 극장별 상영 영화 목록 뷰를 작성하시오
 (각 극장에서 상영 중인 영화와 가격, 좌석수 조회)
create view v13 as  
    select g.극장이름, s.* from 극장 g join 상영관 s on g.극장번호 = s.극장번호;

4. 고객별 예약 내역 뷰를 작성하시오
 (고객별 예약한 영화 목록과 날짜, 금액 조회가능한 뷰)
create view v14 as
    select k.이름, y.극장번호, y.상영관번호, s.영화제목, y.날짜, s.가격 
    from 고객 k join 예약 y on k.고객번호 = y.고객번호 join 상영관 s on y.극장번호 = s.극장번호 and y.상영관번호 = s.상영관번호;

5. 상영관별 예약 인원 및 잔여 좌석 뷰를 작성하시오
 (상영관의 총 좌석 대비 예약 현황과 잔여 좌석 계산)
create view v15 as
    select s.극장번호, s.상영관번호, count(y.고객번호) as 예약인원, (s.좌석수-count(y.고객번호)) as 잔여좌석
    from 상영관 s join 예약 y on y.극장번호 = s.극장번호 and y.상영관번호 = s.상영관번호
    group by s.극장번호, s.상영관번호, s.좌석수;

6. 극장별 총 예약 수 및 매출 뷰를 작성하시오
 (극장별 총 예약 건수와 누적 매출 집계를 볼 수 있는 뷰)
create or replace view v16 as
    select s.극장번호, count(y.고객번호) as 총예약, sum(s.가격) as 누적매출 from 상영관 s join 예약 y on y.극장번호 = s.극장번호 and y.상영관번호 = s.상영관번호
    group by s.극장번호;

7. 영화별 예약 현황 뷰를 작성하시오
 (영화 제목별 총 예약 인원과 총 매출 집계 뷰)
create view v17 as
    select s.영화제목, count(y.고객번호) as 총예약, sum(s.가격) as 총매출 from 상영관 s join 예약 y on y.극장번호 = s.극장번호 and y.상영관번호 = s.상영관번호
    group by s.영화제목;

 8. 날짜별 예약 현황 뷰를 작성하시오
 (날짜별 예약 건수와 해당 날짜 매출 조회 가능한 뷰 작성)
create view v18 as
    select y.날짜, sum(s.가격) as 매출 from 상영관 s join 예약 y on y.극장번호 = s.극장번호 and y.상영관번호 = s.상영관번호
    group by y.날짜;

 9. 예약 이력이 없는 고객 뷰
(한 번도 예약한 적 없는 고객 조회하는 뷰 작서)
create view v19 as
    select k.* from 고객 k where not exists (select 1 from 예약 y where y.고객번호 = k.고객번호);

10. 고객별 총 예약 횟수 및 결제 금액 뷰
(고객의 예약 활동 통계) (충성 고객 분석용)
create view v20 as
    select y.고객번호, count(y.좌석번호) as 총예약횟수, sum(s.가격) as 결제금액
    from 상영관 s join 예약 y on y.극장번호 = s.극장번호 and y.상영관번호 = s.상영관번호
    group by y.고객번호;

11. 가격이 가장 비싼 상영관 뷰를 작성하시오
 (티켓 가격 기준 상위 상영관 목록 조회하는 뷰 작성)
create view v21 as
    select 극장번호, 상영관번호, 가격 from (select s.*, rank() over(order by s.가격 desc) as rnk from 상영관 s)
    where rnk = 1;

12. 위치별 극장 및 상영 현황 뷰
(지역(위치)별로 운영 중인 극장과 상영 영화 수 집계하는 뷰 작성)
create view v22 as
    select g.위치, count(distinct g.극장번호) as 극장수, count(*) as 영화수
    from 극장 g join 상영관 s on g.극장번호 = s.극장번호
    group by g.위치;

13. 만석 상영관 뷰를 작성하시오
 (예약 좌석 수가 전체 좌석 수와 동일한 매진 상영관 조회)
create view v23 as
    select s.* from 상영관 s where s.좌석수 = (select count(*) from 예약 y where y.극장번호 = s.극장번호 and y.상영관번호 = s.상영관번호)

14. 특정 날짜 예약 고객 상세 뷰를 작성하시오
( 날짜별 예약 고객 정보와 관람 영화 상세 조회)
create view v24 as 
    select y.날짜, k.*, s.영화제목 from 고객 k join 예약 y on k.고객번호 = y.고객번호 join 상영관 s on y.극장번호 = s.극장번호 and y.상영관번호 = s.상영관번호;

15. 예약 없는 상영관 뷰
개설되었지만 예약이 한 건도 없는 상영관 조회
create view v25 as
    select s.* from 상영관 s where not exists (select 1 from 예약 y where y.극장번호 = s.극장번호 and y.상영관번호 = s.상영관번호);


1. 전체 주문 통합 현황 뷰를 작성하시오
(주문 + 고객 + 영업사원 정보를 한눈에 통합 조회 뷰)
create view v26 as
    select o.*, c.*, s.* from salesperson s join orders o on s.name = o.salesperson join customer c on o.custname = c.name;

2. 영업사원별 총 주문 금액 및 건수 뷰를 작성하시오
(영업사원별 실적(주문 건수, 총 매출) 집계)
create view v27 as
    select o.salesperson, count(o.num) as 주문건수, sum(o.amount) as 총매출 from orders o group by o.salesperson;

3. 고객별 총 주문 금액 뷰를 작성하시오
(고객별 누적 주문 횟수와 총 구매 금액 집계 포함된 뷰)
create view v28 as
    select o.custname, count(o.num) as 주문횟수, sum(o.amount) as 구매금액 from orders o group by o.custname;

4. 도시별 주문 현황 뷰를 작성하시오
(도시(city)별 총 주문 건수와 매출 집계 포함된 뷰)
create view v29 as 
    select c.city, count(o.num) as 주문건수, sum(o.amount) as 매출집계 from orders o join customer c on o.custname = c.name group by c.city;

5. 업종별 주문 통계 뷰를 작성하시오
 (산업 유형(industrytype)별 주문 건수 및 총 매출 비교 뷰)
create view v30 as
    select c.industrytype, count(o.num) as 주문건수, sum(o.amount) as 매출집계 from orders o join customer c on o.custname = c.name group by c.industrytype;

6. 고액 주문 뷰 (amount 상위)를 작성하시오
 (주문 금액이 평균 이상인 고액 주문만 조회하는 뷰)
create view v31 as
    select o.* from orders o where o.amount >= (select avg(amount) from orders);

7. 주문 실적 없는 영업사원 뷰를 작성하시오
 (한 건도 주문을 처리하지 않은 영업사원 조회 뷰)
create view v32 as
    select s.* from salesperson s where not exists (select 1 from orders o where o.salesperson = s.name);

8. 주문 이력 없는 고객 뷰를 작성하시오
 (등록은 되어 있지만 한 번도 주문하지 않은 고객 조회 뷰)
 create view v33 as
    select c.* from customer c where not exists (select 1 from orders o where o.custname = c.name);

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

10. 영업사원별 담당 고객 목록 뷰를 작성하시오
 (각 영업사원이 주문을 처리한 고객 목록(중복 제거) 생성 뷰)
create or replace view v35 as
    select distinct o.salesperson, o.custname from orders o order by o.salesperson;

11. 최고 실적 영업사원 뷰를 작성하시오
 (총 주문 금액이 가장 높은 영업사원 조회하는 뷰)
create view v36 as 
    select salesperson from (
        select o.salesperson, rank() over(order by sum(o.amount) desc) as rnk from orders o group by o.salesperson
    ) where rnk = 1;
    
 12. 도시별 영업사원 활동 현황 뷰를 작성하시오
 (어느 도시의 고객에게 얼마나 판매했는지 영업사원 기준 집계 뷰)
create view v37 as 
    select o.salesperson, c.city, count(*) as 판매수 from orders o join customer c on o.custname = c.name
    group by o.salesperson, c.city;

13. 영업사원 급여 대비 매출 효율 뷰를 작성하시오
(영업사원 급여 대비 총 매출 비율로 효율성 측정 뷰)
create or replace view v38 as
    select distinct s.name, (sum(o.amount) over (partition by s.name) / s.salary) as 매출효율
    from salesperson s join orders o on s.name = o.salesperson

14. 업종별 담당 영업사원 현황 뷰를 작성하시오
 (산업 유형별로 어떤 영업사원이 활동하는지 파악)
create view v39 as
    select c.industrytype, o.salesperson from orders o join customer c on o.custname = c.name;
    
 15. 주문 금액 구간별 분류 뷰를 작성하시오
 (주문을 금액 구간으로 나누어 분류 및 통계 제공 뷰)
create view v40 as
    select amount_grade, count(*) as 구간별주문수
    from (
    select o.*,
    case
        when o.amount >= 800000 then 'A'
        when o.amount >= 700000 then 'B'
        when o.amount >= 500000 then 'C'
        else 'D'
    end as amount_grade
    from orders o) group by amount_grade order by amount_grade;


1. 전체 예약 통합 현황 뷰를 작성하시오
 (승객 + 여행사 + 항공편 정보를 한눈에 통합 조회 뷰)
create view v41 as
    select p.*, a.*, f.* from passenger p join booking b on p.pid = b.pid join agency a on b.aid = a.aid join flight f on f.fid = b.fid;

2. 승객별 예약 내역 뷰를 작성하시오
 (각 승객이 예약한 항공편과 여행사 정보 조회 뷰)
create view v42 as
    select b.pid, f.*, a.* from booking b join agency a on b.aid = a.aid join flight f on f.fid = b.fid;

3. 여행사별 예약 건수 및 실적 뷰를 작성하시오
 (각 여행사의 총 예약 건수와 취급 항공편 수 집계 뷰)
create view v43 as
    select aid, count(*) as 총예약건수, count(distinct fid) as 취급항공편수 from booking group by aid;

4. 항공편별 예약 승객 수 뷰를 작성하시오
 (각 항공편의 예약된 승객 수와 출발·도착지 조회 뷰)
create view v44 as
    select distinct b.fid, count(b.pid) over(partition by b.fid) as 승객수, f.src, f.dest from booking b join flight f on f.fid = b.fid

5. 출발지·도착지별 노선 통계 뷰를 작성하시오
 (노선(src → dest)별 운항 횟수와 총 예약 건수 집계 뷰)
create view v45 as
    select f.src, f.dest, count(distinct f.fid) as 운항횟수, count(b.pid) as 예약건수 from flight f join booking b on f.fid = b.fid
    group by f.src, f.dest;

6. 도시별 승객 예약 현황 뷰를 작성하시오
 (승객 거주 도시별 총 예약 건수 및 이용 현황 집계 뷰)
create view v46 as
    select p.pcity, count(b.pid) as 예약수 from passenger p join booking b on p.pid = b.pid group by p.pcity;

7. 성별 이용 통계 뷰를 작성하시오
 (성별(pgender)에 따른 예약 건수와 이용 노선 수 비교 뷰)
create view v47 as
    select p.pgender, count(b.pid) as 예약건수, count(distinct b.fid) as 노선수 from passenger p join booking b on p.pid = b.pid group by p.pgender;

8. 예약 이력 없는 승객 뷰를 작성하시오
 (한 번도 예약하지 않은 승객 조회 (비활성 승객 관리) 뷰)
create view v48 as
    select p.* from passenger p where not exists (select 1 from booking b where b.pid = p.pid);

9. 예약 실적 없는 여행사 뷰를 작성하시오
 (한 건도 예약을 처리하지 않은 여행사 조회 뷰)
create view v49 as
    select a.* from agency a where not exists (select 1 from booking b where b.aid = a.aid);

10. 승객별 이용 여행사 목록 뷰를 작성하시오
 (각 승객이 이용한 여행사 목록 (중복 제거) 뷰)
create view v50 as
    select distinct p.pname, a.aname from passenger p join booking b on p.pid = b.pid join agency a on b.aid = a.aid join flight f on f.fid = b.fid;

11. 동일 출발·도착지 왕복 노선 뷰를 작성하시오
 (왕복 운항이 가능한 노선 쌍(A→B, B→A) 조회 뷰)
create view v51 as
    select f.fid, f1.fid from flight f join flight f1 on f.src = f1.dest and f.dest = f1.src;
12. 여행사별 담당 승객 상세 뷰를 작성하시오
 (여행사별로 담당한 승객 정보와 이용 항공편 상세 조회 뷰)
create view v52 as
    select a.aname, p.*, f.* from passenger p join booking b on p.pid = b.pid join agency a on b.aid = a.aid join flight f on f.fid = b.fid;

13. 날짜별 예약 및 항공편 현황 뷰를 작성하시오
 (날짜별 총 예약 건수와 운항 항공편 수 집계 뷰)
create view v53 as
    select b.fdate, count(*) as 총예약건수, count(distinct b.fid) as 항공편수 from booking b group by b.fdate;

14. 다중 항공편 이용 승객 뷰를 작성하시오
 (2개 이상의 항공편을 예약한 승객 조회 (자주 이용 고객) 뷰)
create view v54 as
    select p.pname, count(*) as 예약횟수 from passenger p join booking b on p.pid = b.pid group by p.pid, p.pname having count(*) >= 2;

15. 승객-여행사 동일 도시 예약 뷰를 작성하시오
 (승객의 거주 도시와 여행사 위치가 같은 예약 조회 뷰)
create view v55 as
    select select b.* from passenger p join booking b on p.pid = b.pid join agency a on b.aid = a.aid join flight f on f.fid = b.fid
    where p.pcity = a.acity;


1. 직원 전체 정보 통합 뷰를 작성하시오
 (직원 정보와 소속 부서명을 함께 조회하는 뷰)
create view v56 as 
    select e.*, d.deptname from employee e join department d on e.deptno = d.deptno;

2. 직원별 프로젝트 참여 현황 뷰를 작성하시오
 (직원이 참여 중인 프로젝트명과 투입 시간 조회하는 뷰)
create view v57 as  
    select w.empno, p.proname, w.hours_worked from works w join project p on w.projno = p.projno;

3. 부서별 직원 수 및 현황 뷰를 작성하시오
 (부서별 소속 직원 수와 관리자 정보 집계 뷰)
create view v58 as
    select d.deptname, count(e.empno) as 직원수, d.manager from department d join employee e on d.deptno = e.deptno group by d.deptname, d.manager;

4. 프로젝트별 참여 직원 및 총 투입 시간 뷰를 작성하시오
 (각 프로젝트에 참여한 직원 수와 총 근무 시간 집계 뷰)
create view v59 as
    select w.projno, count(w.empno) as 직원수, sum(w.hours_worked) as 총시간 from works w group by w.projno;

5. 직원별 총 근무 시간 뷰를 작성하시오
 (직원이 전체 프로젝트에 투입한 총 시간 집계 뷰)
create view v60 as
    select w.empno, sum(w.hours_worked) as 총시간 from works w group by w.empno;

6. 부서별 프로젝트 현황 뷰를 작성하시오
 (각 부서가 담당하는 프로젝트 수와 총 투입 시간 집계 뷰)
create view v61
    select p.deptno, count(distinct p.projno) as 프로젝트수, sum(w.hours_worked) as 총투입시간
    from project p join works w on p.projno = w.projno join employee e on e.empno = w.empno group by p.deptno; 

7. 프로젝트에 참여하지 않는 직원 뷰를 작성하시오
 (어떤 프로젝트에도 투입되지 않은 직원 조회 뷰)
create view v62 as
    select e.empno, e.name, e.position, e.deptno from employee e where not exists (SELECT 1 FROM works where w.empno = e.empno);

8. 성별 프로젝트 참여 통계 뷰를 작성하시오
 (성별(sex)에 따른 프로젝트 참여 수와 평균 근무 시간 비교 뷰)
create view v63 as
    select e.sex, count(*) as 참여수, avg(w.hours_worked) as 평균근무시간 
    from employee e join works w on e.empno = w.empno group by e.sex;

9. 관리자(Manager) 직원 상세 뷰를 작성하시오
 (부서 관리자로 지정된 직원의 상세 정보 조회 뷰)
create view v64 as
    select e.* from employee e where exists (select 1 from department d where d.manager = e.empno);

10. 직책별 프로젝트 참여 현황 뷰를 작성하시오
 (직책(position)별 총 프로젝트 참여 건수와 평균 투입 시간 뷰)
create view v65 as
    select e.position, count(*) as 참여건수, avg(w.hours_worked) as 평균투입시간
    from employee e join works w on e.empno = w.empno group by e.position;

11. 다중 프로젝트 참여 직원 뷰를 작성하시오
 (2개 이상의 프로젝트에 참여 중인 직원 조회 뷰)
create view v66 as
    select e.* from employee e where e.empno in (select w.empno from works w group by w.empno having count(*) >=2);


12. 부서 내 프로젝트 참여 직원 상세 뷰를 작성하시오
 (같은 부서 소속 직원이 해당 부서 프로젝트에 참여하는 현황 뷰)
create view v67 as
    select p.deptno, w.empno from project p join works w on p.projno = w.projno join employee e on e.empno = w.empno where e.deptno == p.deptno order by p.deptno;

13. 타 부서 프로젝트 참여 직원 뷰를 작성하시오
 (자신의 소속 부서가 아닌 타 부서 프로젝트에 참여하는 직원 뷰)
create view v68 as
    select p.deptno, w.empno from project p join works w on p.projno = w.projno join employee e on e.empno = w.empno where e.deptno != p.deptno order by p.deptno;

14. 고투입 시간 직원 뷰 (평균 이상 근무)를 작성하시오
 (프로젝트 평균 투입 시간보다 많이 근무한 직원 조회 뷰)
create view v69 as
    select w.empno, w.hours_worked from works w where w.hours_worked >= (select avg(hours_worked) from works);

15. 프로젝트 미배정 부서 뷰를 작성하시오
 (담당 프로젝트가 하나도 없는 부서 조회 뷰)
create view 70 as
    select d.deptname from department d where not exists (select 1 from project p where p.deptno = d.deptno);