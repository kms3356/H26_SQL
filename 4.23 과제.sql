문제 1.
모든 판매원의 이름, 나이, 급여를 보여주는 뷰 v_salesperson_info를 작성하시오. 
create view v_salesperson_info as
    select * from salesperson;

문제 2.
급여가 10,000원 이상인 판매원의 이름과 급여를 보여주는 읽기 전용 뷰 v_high_salary_sp를 작성하시오. 
create view v_high_salary_sp as
    select name, age from salesperson where salary >= 10000 with read only;

문제 3.
나이가 30세 미만인 판매원의 이름, 나이, 급여를 보여주는 뷰 v_young_salesperson을 작성하시오. 
create view v_young_salesperson as
    select * from salesperson where age < 30;

문제 4.
'LA'에 거주하는 고객의 이름, 도시, 직업을 보여주는
읽기 전용 뷰 v_la_customer를 작성하시오. 
create view v_la_customer as
    select * from customer where city = 'LA' with read only;

문제 5.
직업이 '개발자'인 고객의 이름, 도시, 직업을 보여주는 뷰 v_developer_customer를 작성하시오. 단, 조건을 벗어나는 데이터는 입력할 수 없도록 설정하시오. 
create view v_developer_customer as
    select * from customer where industrytype = '개발자' with check option;

문제 6.
주문 금액이 15,000원 이상인 주문의 주문번호, 고객이름, 담당판매원, 주문금액을 보여주는 읽기 전용 뷰 v_high_amount_order를 작성하시오.
create view v_high_amount_order as
    select * from order where amount >= 15000 with read only;

문제 7.
급여가 8,000원 이상 12,000원 이하인 판매원의
이름, 나이, 급여를 보여주는 뷰 v_mid_salary_sp를 작성하시오. 단, 조건을 벗어나는 데이터는 입력할 수 없도록 설정하시오. 
create view v_mid_salary_sp as
    select * from salesperson where salary between 8000 and 12000 with check option;

문제 8.
담당 판매원이 'Tom'인 주문의 주문번호, 고객이름, 담당판매원, 주문금액을 보여주는 뷰 v_tom_order를 작성하시오. 
create view v_tom_order as
    select * from order where salesperson = 'Tom';

문제 9.
이름이 'S'로 시작하는 판매원의 이름, 나이, 급여를 보여주는 읽기 전용 뷰 v_s_salesperson을 작성하시오. 
create view v_s_salesperson as
    select * from salesperson where name like 'S%' with read only;

문제 10.
주문 금액이 5,000원 이상 10,000원 이하인 주문의 주문번호, 고객이름, 담당판매원, 주문금액을 보여주는 뷰 v_mid_amount_order를 작성하시오. 단, 조건을 벗어나는 데이터는 입력할 수 없도록 설정하시오.
# 조건 벗어나는 데이터 입력불가 : with check option
create view v_mid_amount_order as
    select * from order where amount between 5000 and 10000 with check option;

복합뷰
문제 1.
판매원별 총 주문금액과 주문 횟수를 보여주는 뷰 v_sp_order_summary를 작성하시오.
(출력 컬럼 : 판매원이름, 총주문금액, 주문횟수)
create view v_sp_order_summary as
    select s.name, sum(o.amount) as 총주문금액, count(o.num) as 주문횟수 from salesperson s join orders o on s.name = o.salesperson group by s.name;

문제 2.
고객별 총 주문금액과 주문 횟수를 보여주는 뷰 v_cust_order_summary를 작성하시오.
(출력 컬럼 : 고객이름, 도시, 총주문금액, 주문횟수)
create or replace view v_cust_order_summary as
    select distinct c.name, c.city, sum(o.amount) over (partition by c.name) as 총주문금액, count(o.num) over (partition by c.name)as 주문횟수
    from customer c join orders o on c.name = o.custname;

문제 3.
판매원의 평균 급여보다 높은 급여를 받는 판매원의 이름, 나이, 급여를 보여주는 뷰 v_above_avg_salary를 작성하시오. 
create view v_above_avg_salary as
    select s.name, s.age, s.salary from salesperson s
    where s.salary > (select avg(salary) from salesperson);

문제 4.
한 번도 주문을 받지 못한 판매원의 이름, 나이, 급여를 보여주는 뷰 v_no_order_sp를 작성하시오. 
create view v_no_order_sp as
    select * from salesperson s where not exists (select 1 from orders o where s.name = o.salesperson);


문제 5. 'LA'에 거주하는 고객으로부터 주문을 받은 판매원의
이름, 나이, 급여를 보여주는 뷰 v_la_order_sp를 작성하시오. 
create view v_la_order_sp as
    select * from salesperson s join orders o on s.name = o.salesperson join customer c on o.custname = c.name
    where c.city = 'LA';

문제 6. 판매원별 평균 주문금액을 계산하여 전체 평균 주문금액보다 높은 판매원의 이름과 평균주문금액을 보여주는 뷰 v_above_avg_order_sp를 작성하시오. 
create view v_above_avg_order_sp as
    select o.salesperson, avg(o.amount) as 평균주문금액 from orders o
    group by o.salesperson
    having 평균주문금액 > (select avg(amount) from orders);

문제 7.
한 번도 주문하지 않은 고객의 이름, 도시, 직업을 보여주는 뷰 v_no_order_cust를 작성하시오. 
create view v_no_order_cust as
    select * from customer c where not exists (select 1 from orders o where c.name = o.custname);

문제 8.
2건 이상 주문을 받은 판매원의 이름과 주문 횟수, 총 주문금액을 보여주는 뷰 v_frequent_sp를 작성하시오. 
create view v_frequent_sp as
    select salesperson, count(num) as 주문횟수, sum(amount) as 총주문금액 from orders group by salesperson having count(num) > 1;

문제 9.
고객의 도시별 총 주문금액과 주문 건수를 보여주는 뷰 v_city_order_stats를 작성하시오.
(출력 컬럼 : 도시, 총주문금액, 주문건수)
create view v_city_order_stats as
    select c.name, c.city, sum(o.amount) as 총주문금액, count(o.num) as 주문건수 from customer c join orders o on c.name = o.custname
    group by c.name, c.city

문제 10.
판매원별 최고 주문금액, 최저 주문금액, 평균 주문금액과 자신의 급여 대비 총 주문금액 비율을 보여주는 뷰 v_sp_order_stats를 작성하시오.
(출력 컬럼 : 판매원이름, 급여, 최고주문금액, 최저주문금액, 평균주문금액, 급여대비주문비율)
create view v_sp_order_stats as
    select s.name, s.salary, max(o.amount) as 최고주문금액, min(o.amount) as 최저주문금액, avg(o.amount) as 평균주문금액, (sum(o.amount) / s.salary) as 급여대비주문비율
    from salesperson s join orders o on s.name = o.salesperson
    group by s.name, s.salary;

문제 11.
직업별 총 주문금액과 평균 주문금액을 보여주는
뷰 v_industry_order_stats를 작성하시오.
(출력 컬럼 : 직업, 총주문금액, 평균주문금액)
create view v_industry_order_stats as
    select c.industrytype, sum(o.amount), avg(o.amount) from customer c join orders o on c.name = o.custname group by c.industrytype;

문제 12.
판매원 중 자신의 급여보다 총 주문금액이 더 높은 판매원의
이름, 급여, 총주문금액을 보여주는 뷰 v_sp_order_over_salary를 작성하시오. 
create view v_sp_order_over_salary as
    select s.name, s.salary, sum(o.amount) as 총주문금액 from salesperson s join orders o on s.name = o.salesperson
    group by s.name, s.salary
    having s.salary > sum(o.amount);

문제 13.
각 판매원이 주문을 받은 고객의 수(서로 다른 고객만)와
총 주문금액을 보여주는 뷰 v_sp_cust_count를 작성하시오.
(출력 컬럼 : 판매원이름, 담당고객수, 총주문금액)
create view v_sp_cust_count as
    select s.name, count(distinct o.custname) as 담당고객수, sum(o.amount) as 총주문금액
    from salesperson s join orders o on s.name = o.salesperson
    group by s.name;

문제 14.
주문 금액이 가장 높은 주문을 한 고객의
이름, 도시, 직업, 주문금액을 보여주는 뷰 v_max_order_cust를 작성하시오. 
create view v_max_order_cust as
    select c.*, o.amount as 주문금액 from customer c join orders o on c.name = o.custname
    where o.amount = (select max(amount) from orders);

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


문제 1.
모든 극장의 극장번호, 극장이름, 위치를 보여주는 뷰 v_theater_info를 작성하시오. 
create view v_theater_info as
    select * from 극장;

문제 2.
위치가 '강남'인 극장의 극장번호, 극장이름을 보여주는 읽기 전용 뷰 v_gangnam_theater를작성하시오. 
# 읽기전용뷰 : with read only
create view v_gangnam_theater as
    select 극장번호, 극장이름 from 극장 where 위치 = '강남' with read only;

문제 3.
가격이 10,000원 이상인 상영관의 극장번호, 상영관번호, 영화제목, 가격을 보여주는 읽기 전용 뷰 v_high_price_screen을 작성하시오. 
create view v_high_price_screen as
    select g.극장번호, s.상영관번호, s.영화제목, s.가격 from 극장 g join 상영관 s on g.극장번호 = s.극장번호 where s.가격 >= 10000 with read only;

문제 4.
좌석수가 100석 이상인 상영관의 극장번호, 상영관번호, 영화제목, 좌석수를 보여주는 뷰 v_large_screen을 작성하시오. 
create view v_large_screen as
    select * from 상영관 s where s.좌석수 >= 100;

문제 5.
주소가 '강남'인 고객의 고객번호, 이름, 주소를 보여주는 읽기 전용 뷰 v_gangnam_customer를 작성하시오.
create view v_gangnam_customer as
    select * from 고객 k where k.주소 = '강남' with read only;

문제 6.
2025년 9월 1일에 예약된 내역의 극장번호, 상영관번호, 고객번호, 좌석번호, 날짜를 보여주는뷰 v_reservation_20250901을 작성하시오. 
create view v_reservation_20250901 as
    select * from 예약 y where y.날짜 = to_date('2025-09-01', 'yyyy-mm-dd');

문제 7.
가격이 7,500원 이상 10,000원 이하인 상영관의 극장번호, 상영관번호, 영화제목, 가격을 보여주는 뷰 v_mid_price_screen을 작성하시오. 단, 조건을 벗어나는 데이터는 입력할 수 없도록 설정하시오. 
create view v_mid_price_screen as
    select * from 상영관 s where s.가격 between 7500 and 10000 with check option;

문제 8.
좌석번호가 20번 이하인 예약 내역의 극장번호, 상영관번호, 고객번호, 좌석번호를 보여주는뷰 v_front_seat_reservation을 작성하시오. 
create view v_front_seat_reservation as
    select * from 예약 y where y.좌석번호 <= 20;

문제 9.
영화제목에 '영화'가 포함된 상영관의 극장번호, 상영관번호, 영화제목, 가격, 좌석수를 보여주는 읽기 전용 뷰 v_movie_screen을 작성하시오. 
create view v_movie_screen as
    select * from 상영관 s where s.영화제목 like '%영화%' with read only;

문제 10.
주소가 '잠실'인 고객의 고객번호, 이름, 주소를 보여주는 뷰 v_jamsil_customer를 작성하시오. 단, 조건을 벗어나는 데이터는 입력할 수 없도록 설정하시오.
create view v_jamsil_customer as
    select * from 고객 g where g.주소 = '잠실' with check option;

극장 복합 뷰 문제
문제 1.
극장별 상영관 수와 평균 가격을 보여주는 뷰 v_theater_screen_stats를 작성하시오.
(출력 컬럼 : 극장이름, 위치, 상영관수, 평균가격)
create view v_theater_screen_stats as
    select g.극장이름, g.위치, count(s.상영관번호) as 상영관수, avg(s.가격) as 평균가격
    from 극장 g join 상영관 s on g.극장번호 = s.극장번호
    group by g.극장이름, g.위치;

문제 2.
각 극장의 상영관 중 가격이 가장 비싼 영화제목과 가격을 보여주는
뷰 v_theater_max_price를 작성하시오.
(출력 컬럼 : 극장이름, 영화제목, 가격)
create view v_theater_max_price as
    select g.극장이름, s.영화제목, s.가격 from 극장 g join 상영관 s on g.극장번호 = s.극장번호
    where s.가격 = (select max(s1.가격) from 상영관 s1 where s.극장번호 = s1.극장번호);

문제 3.
고객별 총 예약 횟수를 보여주는 뷰 v_customer_reservation_count를 작성하시오.
(출력 컬럼 : 고객이름, 주소, 총예약횟수)
create view v_customer_reservateion_count as
    select k.이름, k.주소, count(*) as 총예약횟수
    from 고객 k join 예약 y on k.고객번호 = y.고객번호
    group by k.이름, k.주소;

문제 4.
한 번도 예약하지 않은 고객의 고객번호, 이름, 주소를 보여주는 뷰 v_no_reservation_customer를 작성하시오. 
create view v_no_reservation_customer as
    select * from 고객 k where not exists (select 1 from 예약 y where k.고객번호 = y.고객번호);

문제 5.
예약이 한 번도 없는 상영관의 극장번호, 상영관번호, 영화제목, 가격을 보여주는뷰 v_no_reservation_screen을 작성하시오. 
create view v_no_reservation_screen as
    select * from 상영관 s where not exists (select 1 from 예약 y where s.극장번호 = y.극장번호 and s.상영관번호 = y.상영관번호);

문제 6.
극장별 총 예약 건수와 총 예약 좌석수를 보여주는 뷰 v_theater_reservation_stats를 작성하시오.
(출력 컬럼 : 극장이름, 총예약건수, 총예약좌석수)
create view v_theater_reservation_stats as
    select g.극장이름, count(*) as 총예약건수, count(y.좌석번호) as 총예약좌석수
    from 극장 g join 예약 y on g.극장번호 = y.극장번호
    group by g.극장이름;

문제 7.
'강남'에 사는 고객이 예약한 내역의 고객이름, 극장번호, 상영관번호, 좌석번호, 날짜를 보여주는 뷰 v_gangnam_customer_reservation을 작성하시오. 
create view v_gangnam_customer_reservation as
    select k.이름, y.극장번호,y.상영관번호, y.좌석번호, y.날짜 from 고객 k join 예약 y on k.고객번호 = y.고객번호
    where k.주소 = '강남';

문제 8.
상영관별 예약 건수와 전체 좌석수 대비 예약된 좌석의 비율을 보여주는 뷰 v_screen_reservation_rate를 작성하시오.
(출력 컬럼 : 극장번호, 상영관번호, 영화제목, 좌석수, 예약건수, 예약률) 단, 예약률은 소수점 2자리까지 표시한다. 
create view v_screen_reservation_rate as 
    select s.*, count(*) over (partition by s.극장번호, s.상영관번호)as 예약건수, round(count(*) over(partition by s.극장번호, s.상영관번호)/ s.좌석수, 2) as 예약률
    from 상영관 s join 예약 y on s.극장번호 = y.극장번호 and s.상영관번호 = y.상영관번호;

문제 9.
2건 이상 예약한 고객의 이름, 주소, 예약횟수를 보여주는 뷰 v_frequent_customer를 작성하시오. 
create or replace view v_frequent_customer as
    select k.이름, k.주소, count(*) as 예약횟수 from 고객 k join 예약 y on k.고객번호 = y.고객번호
    group by k.이름, k.주소
    having count(*) >= 2;

문제 10.
영화제목별 총 예약 건수와 총 예약 금액을 보여주는 뷰 v_movie_reservation_stats를 작성하시오.
(출력 컬럼 : 영화제목, 총예약건수, 총예약금액)
create view v_movie_reservation_stats as
    select s.영화제목, count(*) as 총예약건수, sum(s.가격) as 총예약금액
    from 상영관 s join 예약 y on s.극장번호 = y.극장번호 and s.상영관번호 = y.상영관번호
    group by s.영화제목;

문제 11.
극장 위치별 평균 영화 가격과 총 상영관 수를 보여주는 뷰 v_location_screen_stats를 작성하시오.
(출력 컬럼 : 위치, 평균가격, 총상영관수)
create view v_location_screen_stats as
    select g.위치, avg(s.가격) as 평균가격, count(s.상영관번호) as 총상영관수 from 극장 g join 상영관 s on g.극장번호 = s.극장번호
    group by g.위치;

문제 12.
각 고객이 가장 최근에 예약한 날짜와 예약한 극장번호, 상영관번호를 보여주는 뷰 v_customer_last_reservation을 작성하시오.
(출력 컬럼 : 고객이름, 극장번호, 상영관번호, 최근예약날짜)
create view v_customer_last_reservation as
    select k.이름, y.극장번호, y.상영관번호, y.날짜 from 고객 k join 예약 y on k.고객번호 = y.고객번호
    where y.날짜 = (select max(y2.날짜) from 예약 y2 where y.고객번호 = y2.고객번호)

문제 13.
전체 평균 가격보다 비싼 상영관의 극장이름, 상영관번호, 영화제목, 가격을 보여주는 뷰 v_above_avg_price_screen을 작성하시오. 
create view v_above_avg_price_screen as
    select g.극장이름, s.상영관번호, s.영화제목, s.가격 from 극장 g join 상영관 s on g.극장번호 = s.극장번호
    where s.가격 > (select avg(가격) from 상영관);

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
    