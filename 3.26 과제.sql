16-3-1
select 극장번호 from 상영관 where 가격 >= 9000;
1. 상영관테이블에서 2. 극장번호 속성 가져오고 3. 가격이 9000원 이상인 튜플만 남김

16-3-2
SELECT * FROM 극장, 상영관 WHERE 극장.극장번호 = 상영관.극장번호;
1. 극장, 상영관테이블 전부 가져와서 2. 극장번호끼리 매칭시킴

16-3-3
select 극장이름 from 극장 where 극장번호 in (select 극장번호 from 상영관 where 가격 >= 10000);
1. 극장테이블에서 2. 극장이름 속성 가져오고 극장.극장번호가 상영관 테이블에서 가져온 만원 이상인 극장번호리스트 안에 있는지 확인 

16-3-4
select * from 고객 left outer join 예약 on 고객.고객번호 = 예약.고객번호 and 예약.날짜 > to_date('2024-01-01', 'YYYY-MM-DD');
1. 고객과 예약 left outer join 2. 고객번호 끼리 매칭시키고 3. 예약테이블의 날짜 확인

16-3-5
select c.이름 from 고객 c join 예약 r on c.고객번호 = r.고객번호
  2  join 극장 t on r.극장번호 = t.극장번호
  3  where t.위치 = '강남'
  4  group by c.이름
  5  having count(distinct t.극장번호) = (select count(*) from 극장 where 위치 = '강남');
  1. 고객과 예약 조인, 다시 극장과 조인 2. 위치가 강남인 극장만 남김 3. 고객이름으로 그룹화한 후 4. 이름별 극장번호의 갯수를 세서 5. 강남의 전체 극장 수와 비교

16-4-1
select 극장이름, 위치 from 극장;
1. 극장에서 이름, 위치 가져옴

16-4-2
select 영화제목 from 상영관 where 가격 <= 10000;
1. 상영관에서 영화제목 가져와서 2. 가격 10000원 이하인 것만 남김

16-4-3
select 이름, 주소 from 고객;
1. 고객에서 이름, 주소 가져옴

16-4-4
select 영화제목 from 상영관 where 극장번호 in (select 극장번호 from 극장 where 위치 = '강남');
1. 상영관에서 영화제목 가져와서 2. 상영관의 극장번호가 3. 위치가 강남인 극장번호 리스트에 있는지 확인

17-1
select 학번 from 수강 where 과목코드 = 'CS101' and 성적 = 'A';
1. 수강테이블에서 학번 가져오고 2. 과목코드가 'CS101'인지, 3. 성적이 A인지 확인 후 추출

17-2
select 이름, 전공 from 학생 where 학번 in (select 학번 from 수강 where 과목코드 = 'CS101');
1. 학생에서 이름과 전공 가져오고 학생의 학번을 2. 수강테이블의 과목코드가 'cs101'인 학번리스트에 있는지 확인
17-3
select 이름 from 학생 where 학번 not in (select 학번 from 수강 where 과목코드 = 'CS101');
1. 학생에서 이름가져오고 2. 학번을 과목코드가 'cs101'인 수강테이블의 학번 리스트 안에 없는지 확인

17-4
select h.이름 from 학생 h join 수강 s on h.학번 = s.학번 join 과목 g on s.과목코드 = g.과목코드
  2  group by h.이름
  3  having count(distinct s.과목코드) = (select count(*) from 과목);
1. 학생과 수강, 과목 조인 2. 학생의 이름으로 그룹화 한후 3. 이름별 수강테이블의 과목코드 수와 4. 전체 과목수와 비교해서 같으면 추출
17-4-2
select s.이름 from 학생 s where not exists (select 과목코드 from 과목 minus select 과목코드 from 수강 e where e.학번 = s.학번)
1. 전체 과목코드 집합에서 학생별로 수강한 과목코드 리스트를 빼고 2. 그게 공집합이라면 모든 과목을 수강한거니까 이름 추출

18-1
select name from salesperson;
1. salesperson 테이블에서 2. name가져옴

18-2
select salesperson from orders where custname = '홍길동';
1. orders 테이블에서 salesperson 가져오고 2. custname이 홍길동인 것만 남김

18-3
select name from salesperson
  2  intersect
  3  select salesperson from orders;
1. salesperson 전체 이름과 2. orders테이블에 있는 이름과 교집합

18-4
select name from salesperson
  2  minus
  3  select salesperson from orders;
1. salesperson 전체 이름과 2. orders 테이블에 있는 이름과 차집합

18-5
select age from salesperson where name in (select salesperson from orders where custname = '홍길동');
1. salesperson의 age를 가져옴 2. 그 이름이 orders테이블에서 custname이 홍길동인 salesperson 리스트에 있는지 확인

18-6
select c.city from customer c join orders o on c.name = o.custname join salesperson s on o.salesperson = s.name
  2  where s.age = 25;
1. customer, orders, salesperson 조인 2. customer에서 시티 가져옴 3. salesperson의 age가 25인지 확인 

18-7
select s.name as 판매원, o.custname as 고객 from salesperson s left outer join orders o on s.name = o.salesperson;
1. salesperson과 orders를 left outer join 2. 판매원, 고객 가져옴