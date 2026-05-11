1. bookid를 입력받아 해당 도서의 bookname, publisher, price를 출력하는 프로시저를 작성하시오. 
create or replace procedure A(
    b_bookid in number)
is
b_bookname book.bookname%type;
b_publisher book.publisher%type;
b_price number;
BEGIN
select bookname, publisher, price into b_bookname, b_publisher, b_price from book where bookid = b_bookid;
dbms_output.put_line('도서명 : ' || b_bookname || ', 출판사 : ' || b_publisher || ', 가격 : ' || b_price);
EXCEPTION
    when NO_DATA_FOUND then
        dbms_output.put_line('해당 도서가 존재하지 않습니다.');
end A;
/
2. 새로운 고객 정보(custid, name, address, phone)를 입력받아 Customer 테이블에 삽입하는 프로시저를 작성하시오. 
create or replace procedure A(
    c_custid in number,
    c_name in customer.name%type,
    c_address in customer.address%type,
    c_phone in customer.phone%type)
IS
BEGIN
insert into customer values(c_custid, c_name, c_address, c_phone);
commit;
dbms_output.put_line('고객정보 삽입 완료!');
EXCEPTION
    when DUP_VAL_ON_INDEX THEN
        dbms_output.put_line('이미 존재하는 고객번호입니다.');
    when others THEN
        rollback;
        dbms_output.put_line('오류발생:' || SQLERRM);
end A;
/
3. bookid와 새로운 price를 입력받아 해당 도서의 가격을 수정하는 프로시저를 작성하시오. 
create or replace procedure A(
    b_bookid in number,
    new_price in number)
IS
e_no_book_found exception;
BEGIN
update book set price = new_price where bookid = b_bookid;
if sql%notfound then
    raise e_no_book_found;
end if;
commit;
dbms_output.put_line('도서 가격 수정 완료');
EXCEPTION
    when e_no_book_found THEN
        dbms_output.put_line('존재하지 않는 번호. 도서번호를 다시 확인해주세요.');
    when others THEN
        rollback;
        dbms_output.put_line('오류발생:' || SQLERRM);
end A;
/
4. custid를 입력받아 해당 고객의 주문 내역을 Orders 테이블에서 모두 삭제한 후, Customer 테이블에서도 해당 고객을 삭제하는 프로시저를 작성하시오. 
create or replace procedure A(
    c_custid in number)
IS
BEGIN
delete from orders where custid = c_custid;
delete from customer where custid = c_custid;

if sql%notfound then
    raise_application_error(-20002, '삭제할 고객이 존재하지 않습니다.');
end if;
commit;
dbms_output.put_line('고객정보 삭제 완료');
end A;
/
5. orderid를 입력받아 해당 주문의 고객 이름, 도서명, 주문금액, 주문날짜를 출력하는 프로시저를 작성하시오.
create or replace procedure A(
    o_orderid in number)
IS
    c_custname customer.name%type;
    b_bookname book.bookname%type;
    o_saleprice orders.saleprice%type;
    o_orderdate orders.orderdate%type;
BEGIN
select c.name, b.bookname, o.saleprice, o.orderdate 
into c_custname, b_bookname, o_saleprice, o_orderdate
from customer c join orders o on c.custid = o.custid join book b on o.bookid = b.bookid
where o.orderid = o_orderid;

commit;
dbms_output.put_line(c_custname || b_bookname || o_saleprice || o_orderdate);

EXCEPTION
    when NO_DATA_FOUND then
        dbms_output.put_line('해당 도서가 존재하지 않습니다.');
end A;
/
[ 조건 조회 (문제 6~10) ]
6. 출판사 이름을 입력받아 해당 출판사의 도서 목록(bookid, bookname, price)을 모두 출력하는 프로시저를 작성하시오. 
create or replace procedure A(
    p_publisher IN book.publisher%TYPE)
IS
    b_bookid number;
    b_bookname book.bookname%type;
    b_price book.price%type;
    cursor inCursor is SELECT bookid, bookname, price 
        FROM book 
        WHERE publisher = p_publisher
BEGIN
open inCursor;
loop
    fetch inCursor into b_bookid, b_bookname, b_price;
    exit when  inCursor%notfound;

    dbms_output.put_line(b_bookid || b_bookname || b_price);
end loop;
end A;
/
7. custid를 입력받아 해당 고객의 전체 주문 내역(도서명, 주문금액, 주문날짜)을 주문날짜
오름차순으로 출력하는 프로시저를 작성하시오. 
create or replace procedure A(
    c_custid in number)
IS
    b_bookname book.bookname%type;
    o_saleprice number;
    o_orderdate date;
    cursor inCursor is select b.bookname, o.saleprice, o.orderdate 
    from book b join orders o on b.bookid = o.bookid where o.custid = c_custid;
BEGIN
open inCursor;
loop
    fetch inCursor into b_bookname, o_saleprice, o_orderdate;
    exit when  inCursor%notfound;

    dbms_output.put_line(b_bookname || o_saleprice || o_orderdate);
end loop;
end A;
/
8. 시작 날짜와 종료 날짜를 입력받아 해당 기간 내 주문된 모든 주문 정보(고객명, 도서명, 주문금액, 주문날짜)를 출력하는 프로시저를 작성하시오. 
create or replace procedure A(
    s_date date,
    e_date date)
IS
    c_name customer.name%type;
    b_bookname book.bookname%type;
    o_saleprice number;
    o_orderdate date;
    cursor inCursor is select c.name, b.bookname, o.saleprice, o.orderdate 
    from book b join orders o on b.bookid = o.bookid join customer c on o.custid = c.custid
    where o.orderdate between s_date and e_date;
BEGIN
open inCursor;
loop
    fetch inCursor into c_name, b_bookname, o_saleprice, o_orderdate;
    exit when inCursor%notfound;

    dbms_output.put_line(c_name || b_bookname || o_saleprice || o_orderdate);
end loop;
end A;
/
9. 도서 이름을 입력받아 해당 도서를 주문한 고객의 이름과 주문금액을 출력하는 프로시저를 작성하시오. 
create or replace procedure A(
    b_bookname in book.bookname%type)
IS
    c_name customer.name%type;
    o_saleprice number;
BEGIN
    select c.name, o.saleprice
    into c_name, o_saleprice
    from customer c join orders o on c.custid = o.custid join book b on b.bookid = o.bookid
    where b.bookname = b_bookname;
    dbms_output.put_line(c_name || o_saleprice);
end A;
/
10. 특정 주문금액 이상의 주문을 한 고객의 custid, name, 주문 건수를 출력하는 프로시저를 작성하시오.
create or replace procedure A(base in number)
IS
    c_custid number;
    c_name customer.name%type;
    o_count number;
    cursor inCursor is select c.custid, c.name, count(*)
    from customer c join orders o on o.custid = c.custid
    group by c.custid, c.name having sum(o.saleprice) >= base;
BEGIN
open inCursor;
loop
    fetch inCursor into c_custid, c_name, o_count;
    exit when inCursor%notfound;

    dbms_output.put_line(c_custid || c_name || o_count);
end loop;
end A;
/
11. custid를 입력받아 해당 고객의 총 주문금액 합계를 OUT 매개변수로 반환하고 화면에도 출력하는 프로시저를 작성하시오. 
create or replace procedure A(
    p_custid in number,
    sum_price out number
    )
IS
    c_custid number;
BEGIN
    select sum(o.saleprice)
    into sum_price
    from customer c join orders o on o.custid = c.custid
    where c.custid = p_custid;

    dbms_output.put_line(sum_price);
end A;
/
12. 출판사 이름을 입력받아 해당 출판사 도서들의 평균 주문금액, 최고 주문금액, 최저 주문금액을 출력하는 프로시저를 작성하시오.
create or replace procedure A(
    p_publisher in book.publisher%type
    )
IS
    avg_price number;
    max_price number;
    min_price number;
BEGIN
    select round(avg(o.saleprice), 2), max(o.saleprice), min(o.saleprice)
    into avg_price, max_price, min_price
    from book b join orders o on b.bookid = o.bookid
    where b.publisher = p_publisher;

    dbms_output.put_line('평균 : ' || avg_price || '최고 : ' || max_price || '최저 : ' || min_price);
end A;
/
13. 전체 도서 중 주문 횟수가 가장 많은 도서의 이름과 주문 횟수를 OUT 매개변수로 반환하는 프로시저를 작성하시오.
create or replace procedure A(
    p_bookname out book.bookname%type,
    p_bookcount out number
    )
IS
BEGIN
    select bookname, 주문횟수
    into p_bookname, p_bookcount
    from (
        select b.bookid, b.bookname, count(*) as 주문횟수, row_number() over(order by count(*) desc) as rnk
        from book b join orders o on b.bookid = o.bookid
        group by b.bookid, b.bookname
    )
    where rnk=1;
end A;
/
14. 주문 삽입 시 입력한 saleprice가 해당 도서의 price보다 크면 오류 메시지를 출력하고
삽입을 중단하며, 정상이면 Orders 테이블에 삽입하는 프로시저를 작성하시오. 
create or replace procedure A(
    p_orderid in number,
    p_custid in number,
    p_bookid in number,
    p_saleprice in number,
    p_orderdate in date
    )
IS
    saleprice_error EXCEPTION;
    v_price number;
BEGIN
    select price into v_price from book where bookid = p_bookid;
    if p_saleprice > v_price then
        raise saleprice_error;
    end if;
    insert into orders values(p_orderid, p_custid, p_bookid, p_saleprice, p_orderdate);
    commit;
EXCEPTION
    when saleprice_error then
        dbms_output.PUT_LINE('오류 : saleprice를 ' || v_price || '보다 작게 입력하세요.');
    when others then
        rollback;
        dbms_output.PUT_LINE('오류 : ' || SQLERRM);
        
end A;
/
15. custid를 입력받아 해당 고객의 총 주문금액이 30000원 이상이면 'VIP 고객', 10000원
이상이면 '일반 고객', 그 미만이면 '신규 고객'으로 등급을 분류하여 출력하는 프로시저를 작성하시오.
create or replace procedure A(
    p_custid in number
    )
IS
    v_mem varchar2(50);
    v_count number;
BEGIN
    select count(*) into v_count
    from customer c
    where c.custid = p_custid;

    if v_count = 0 then
        DBMS_OUTPUT.PUT_LINE('오류 : 존재하지 않는 고객번호입니다.');
        RETURN;
    end if;
    select case
            when sum(o.saleprice) >= 30000 then 'VIP 고객' 
            when sum(o.saleprice) >= 10000 then '일반 고객'
            else '신규 고객'
        end as membership
        into v_mem
    from customer c left outer join orders o on c.custid = o.custid
    where c.custid = p_custid;
    dbms_output.put_line('고객등급 : ' || v_mem);
EXCEPTION
    when NO_DATA_FOUND then
        dbms_output.PUT_LINE('오류 : 고객번호 다시 확인.');
    when others then
        dbms_output.PUT_LINE('오류 : ' || SQLERRM);
        
end A;
/

1. 특정 극장번호를 입력받아 해당 극장의 이름과 위치를 출력하는 프로시저를 작성하시오. 
create or replace procedure A(
    p_theaterid in number
    )
IS
    v_name varchar2(100);
    v_loc varchar2(200);
BEGIN
    select theater_name, location
    into v_name, v_loc
    from theater where theater_id = p_theaterid;
    dbms_output.put_line(v_name || v_loc);
EXCEPTION
    when NO_DATA_FOUND then
        dbms_output.PUT_LINE('오류 : 극장번호 다시 확인.');
    when others then
        dbms_output.PUT_LINE('오류 : ' || SQLERRM);
        
end A;
/
2. 새로운 극장 정보(극장번호, 극장이름, 위치)를 입력받아 극장 테이블에 삽입하는 프로시저를 작성하시오. 
create or replace procedure A(
    p_tid in number,
    p_tname in varchar2,
    p_tloc in varchar2
    )
IS
BEGIN
    insert into theater values(p_tid, p_tname, p_tloc);
    commit;
    dbms_output.put_line('극장정보 삽입 성공');
EXCEPTION
    when DUP_VAL_ON_INDEX then
        dbms_output.PUT_LINE('오류 : 극장번호 다시 확인.');
    when others then
        dbms_output.PUT_LINE('오류 : ' || SQLERRM);
        
end A;
/
3. 극장번호와 새로운 위치를 입력받아 해당 극장의 위치를 수정하는 프로시저를 작성하시오. 
create or replace procedure A(
    p_tid in number,
    p_tloc in varchar2
    )
IS
BEGIN
    update theater set location = p_tloc where theater_id = p_tid;
    commit;
    dbms_output.put_line('극장정보 수정 성공');
EXCEPTION
    when others then
        dbms_output.PUT_LINE('오류 : ' || SQLERRM);
        
end A;
/
4. 극장번호를 입력받아 해당 극장과 그 극장의 모든 상영관 정보를 삭제하는 프로시저를 작성하시오. 
create or replace procedure A(
    p_tid in number
    )
IS
BEGIN
    delete from theater where p_tid = theater_id;
    commit;
    dbms_output.put_line('극장정보 삭제 성공');
EXCEPTION
    when others then
        rollback;
        dbms_output.PUT_LINE('오류 : ' || SQLERRM);
        
end A;
/
5. 상영관번호와 극장번호를 입력받아 해당 상영관의 영화제목, 가격, 좌석수를 출력하는 프로시저를 작성하시오.
create or replace procedure A(
    p_tid in number,
    p_sid in number
    )
IS
    v_row screen%rowtype;
BEGIN
    select * into v_row from screen where theater_id = p_tid and screen_id = p_sid;
    dbms_output.PUT_LINE(v_row.movie_title || v_row.price || v_row.seat_count);
EXCEPTION
    when others then
        dbms_output.PUT_LINE('오류 : ' || SQLERRM);
        
end A;
/
6. 특정 가격 이하의 상영관 목록을 모두 출력하는 프로시저를 작성하시오. 
create or replace procedure A(
    p_price in number,
    )
IS
    cursor aCursor is select * from screen where price <= p_price;
BEGIN
    for r in aCursor
    loop
        dbms_output.PUT_LINE(r.theater_id || r.screen_id || r.movie_title || r.price);
    end loop;
EXCEPTION
    when others then
        dbms_output.PUT_LINE('오류 : ' || SQLERRM);
        
end A;
/
7. 특정 날짜를 입력받아 그날 예약된 모든 예약 정보(극장번호, 상영관번호, 고객번호, 좌석번호)를 출력하는 프로시저를 작성하시오. 
create or replace procedure A(
    p_date in varchar2
    )
IS
    v_found boolean := false;
    cursor aCursor is select * from reservation where reservation_date = to_date(p_date, 'yyyy-mm-dd');
BEGIN
    for r in aCursor
    loop
        v_found := true;
        dbms_output.PUT_LINE(r.theater_id || r.screen_id || r.customer_id || r.seat_number);
    end loop;
    if not v_found then
        dbms_output.PUT_LINE('해당날짜에 예약이 없습니다.');
    end if;
EXCEPTION
    when others then
        dbms_output.PUT_LINE('오류 : ' || SQLERRM);
        
end A;
/
8. 고객번호를 입력받아 해당 고객의 전체 예약 내역(극장이름, 영화제목, 날짜, 좌석번호)을 출력하는 프로시저를 작성하시오. 
create or replace procedure A(
    p_cid in number
    )
IS
    v_found boolean := false;
    cursor aCursor is 
    select t.theater_name, s.movie_title, r.reservation_date, r.seat_number 
    from reservation r join theater t on r.theater_id = t.theater_id
    join screen s on s.theater_id = r.theater_id and s.screen_id = r.screen_id
    where customer_id = p_cid;
BEGIN
    for r in aCursor
    loop
        v_found := true;
        dbms_output.PUT_LINE(r.theater_name || r.movie_title || r.reservation_date || r.seat_number );
    end loop;
    if not v_found then
        dbms_output.PUT_LINE('해당고객은 예약이 없습니다.');
    end if;
EXCEPTION
    when others then
        dbms_output.PUT_LINE('오류 : ' || SQLERRM);
        
end A;
/
9. 영화제목을 입력받아 해당 영화를 상영 중인 극장 이름과 위치를 출력하는 프로시저를 작성하시오. 
create or replace procedure A(
    p_title in varchar2
    )
IS
    r theater%rowtype;
BEGIN
    select t.* into r from theater t join screen s on t.theater_id = s.theater_id
    where s.movie_title = p_title;
    dbms_output.PUT_LINE(r.theater_name || r.location);
EXCEPTION
    when others then
        dbms_output.PUT_LINE('오류 : ' || SQLERRM);
        
end A;
/
10. 특정 극장번호를 입력받아 해당 극장의 상영관별 총 예약 건수를 출력하는 프로시저를 작성하시오.
create or replace procedure A(
    p_tid in number
    )
IS
    cursor aCursor is select screen_id, count(*) as count from reservation 
    where theater_id = p_tid group by screen_id;
BEGIN
    for r in aCursor
    loop
        dbms_output.put_line(r.screen_id || ' : ' || r.count);
    end loop;
EXCEPTION
    when others then
        dbms_output.PUT_LINE('오류 : ' || SQLERRM);
        
end A;
/
11. 극장 번호를 입력받아 해당 극장 전체 상영관의 평균 좌석수를 OUT 매개변수로 반환하는 프로시저를 작성하시오. 
create or replace procedure A(
    p_tid in number,
    v_seat out number
    )
IS
BEGIN
    select avg(seat_count) into v_seat from screen where theater_id = p_tid;
EXCEPTION
    when others then
        dbms_output.PUT_LINE('오류 : ' || SQLERRM);
        
end A;
/
12. 상영관 번호와 극장 번호를 입력받아 해당 상영관의 좌석 예약률(예약건수 / 좌석수 ×100)을 계산하여 출력하는 프로시저를 작성하시오. 
create or replace procedure A(
    p_sid in number,
    p_tid in number
    )
IS
    res_ratio number;
BEGIN
    select (count(r.customer_id) / s.seat_count * 100) into res_ratio 
    from screen s join reservation r on s.theater_id = r.theater_id and s.screen_id = r.screen_id
    where s.theater_id = p_tid and s.screen_id = p_sid
    group by s.seat_count;
    dbms_output.put_line(res_ratio);
EXCEPTION
    when others then
        dbms_output.PUT_LINE('오류 : ' || SQLERRM);
        
end A;
/
13. 특정 고객 번호를 입력받아 해당 고객이 지출한 총 예약 금액(예약 건수 × 가격)을 OUT 매개변수로 반환하는 프로시저를 작성하시오.
CREATE OR REPLACE PROCEDURE PROC_GET_TOTAL_SPENT (
    p_cid         IN  NUMBER,
    p_total_spent OUT NUMBER
)
IS
BEGIN
    SELECT NVL(SUM(s.price), 0)
    INTO p_total_spent
    FROM reservation r
    JOIN screen s ON r.theater_id = s.theater_id 
                 AND r.screen_id = s.screen_id
    WHERE r.customer_id = p_cid;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);
        p_total_spent := 0;
END PROC_GET_TOTAL_SPENT;
/
14. 예약 삽입 시 해당 상영관의 좌석 수보다 예약 건수가 많으면 오류 메시지를 출력하고 삽입을 중단하는 프로시저를 작성하시오. 
CREATE OR REPLACE PROCEDURE PROC_RESERVE_SEAT(
    p_tid     IN NUMBER,
    p_sid     IN NUMBER,
    p_cid     IN NUMBER,
    p_seat_no IN NUMBER,
    p_date    IN DATE
)
IS
    v_max_seats    NUMBER;
    v_current_res  NUMBER;
BEGIN
    SELECT seat_count INTO v_max_seats
    FROM SCREEN
    WHERE theater_id = p_tid AND screen_id = p_sid;

    SELECT COUNT(*) INTO v_current_res
    FROM RESERVATION
    WHERE theater_id = p_tid AND screen_id = p_sid;

    IF v_current_res >= v_max_seats THEN
        DBMS_OUTPUT.PUT_LINE('오류 : 해당 상영관의 좌석이 매진되어 더 이상 예약할 수 없습니다.');
    ELSE
        INSERT INTO RESERVATION (theater_id, screen_id, customer_id, seat_number, reservation_date)
        VALUES (p_tid, p_sid, p_cid, p_seat_no, p_date);
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('예약이 성공적으로 완료되었습니다.');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('오류 : 존재하지 않는 상영관 정보입니다.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('오류 : ' || SQLERRM);
END;
/
15. 특정 극장번호와 날짜를 입력받아, 그날 예약이 없는 상영관 목록을 출력하는 프로시저를 작성하시오.
CREATE OR REPLACE PROCEDURE PROC_GET_EMPTY_SCREENS(
    p_tid      IN NUMBER,
    p_date_str IN VARCHAR2
)
IS
    v_target_date DATE;
    v_found       BOOLEAN := FALSE;
    
    CURSOR c_empty IS
        SELECT screen_id, movie_title
        FROM screen
        WHERE theater_id = p_tid
        AND screen_id NOT IN (
            SELECT DISTINCT screen_id
            FROM reservation
            WHERE theater_id = p_tid
            AND reservation_date = TO_DATE(p_date_str, 'YYYY-MM-DD')
        );
BEGIN
    v_target_date := TO_DATE(p_date_str, 'YYYY-MM-DD');
    
    DBMS_OUTPUT.PUT_LINE('=== ' || p_date_str || ' 예약 없는 상영관 목록 ===');

    FOR r IN c_empty LOOP
        v_found := TRUE;
        DBMS_OUTPUT.PUT_LINE('상영관: ' || r.screen_id || '번 | 상영영화: ' || r.movie_title);
    END LOOP;
    IF NOT v_found THEN
        DBMS_OUTPUT.PUT_LINE('결과: 해당 날짜에는 모든 상영관에 예약 내역이 있습니다.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);
END;
/