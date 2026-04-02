2장
19
1.
select * from flight where dest = '제주';
2.
select * from flight where src = '김포' and dest = '제주';
3.
select fid from booking where pid = '100' and fdate > to_date('2025-01-01','YYYY-MM-DD');
4.
select p.pname from passenger p where exists (select 1 from booking b where p.pid = b.pid);
5.
select p.pname from passenger p where not exists (select 1 from booking b where p.pid = b.pid);
6.
select a.aname from agency a where a.acity = (select pcity from passenger where pid = '100');
7.
select * from flight where fdate between to_date('2025-01-01','yyyy-mm-dd') and to_date('2025-01-30','yyyy-mm-dd')
and time >= '16:00';
8.
select a.aname from agency a 
where not exists (select 1 from booking b where a.aid = b.aid and b.pid = '100');
9.
select distinct p.pid, p.pname, p.pgender, p.pcity from passenger p where p.pgender = '남'
and exists (select 1 from booking b join agency a on b.aid = a.aid where p.pid = b.pid and a.aname = '마당여행사');

20
3.
select name from employee
4.
select name from employee where sex = '여';
5.
select e.name, e.address from employee e where exists (select 1 from department d where d.manager = e.empno);
6.
select name, address from employee where deptno = (select deptno from department where deptname = 'IT부서');
7.
select name from employee where deptno = (select deptno from project where projname = '미래');

3장
1
1.
select bookname from book where bookid = '1';
2.
select bookname from book where price >= 20000;
3.
select c.name, sum(o.saleprice) as 총구매액 from orders o join customer c on o.custid = c.custid where c.name = '박지성'
group by c.name;
4.
select c.name, count(*) from orders o join customer c on o.custid = c.custid where c.name = '박지성' group by c.name;
5.
select c.name, count(distinct b.publisher) as 출판사수 from orders o join customer c on o.custid = c.custid join book b on b.bookid = o.bookid
where c.name = '박지성' group by c.name;
6.
select c.name, b.price, (b.price - o.saleprice) as 가격차 from orders o join customer c on o.custid = c.custid join book b on b.bookid = o.bookid
where c.name = '박지성';
7.
select b.bookname from book b where b.bookid not in 
(select o.bookid from orders o where o.custid = (select custid c from customer c where c.name = '박지성'));
-- not exists 버전
select b.bookname from book b where not exists (select 1 from orders o 
join customer c on o.custid = c.custid where o.bookid = b.bookid and c.name = '박지성');

2
1.
select count(*) from book;
2.
select count(distinct publisher) from book;
3.
select name, address from customer;
4.
select orderid from orders 
where orderdate between to_date('2025-07-04','yyyy-mm-dd') and to_date('2025-07-07','yyyy-mm-dd');
5.
select orderid from orders 
where orderdate not between to_date('2025-07-04','yyyy-mm-dd') and to_date('2025-07-07','yyyy-mm-dd');
6.
select name, address from customer where name like '김%';
7.
select name, address from customer where name like '김%아';
8.
select name from customer where custid not in (select custid from orders);
9.
select sum(saleprice) as 총액, avg(saleprice) as 평균금액 from orders;
10.
select name, avg(saleprice) from customer join orders on customer.custid = orders.custid group by name;
11.
select c.name, b.bookname from customer c join orders o on o.custid = c.custid join book b on b.bookid = o.bookid order by c.name;
12.
select o.orderid, b.bookname, (b.price - o.saleprice) as 차이액 from orders o join book b on o.bookid = b.bookid where (b.price - o.saleprice) = 
(select max(b2.price - o2.saleprice) from orders o2 join book b2 on o2.bookid = b2.bookid);
13.
select c.name from customer c join orders o on o.custid = c.custid group by c.name 
having avg(o.saleprice) > (select avg(saleprice) from orders);

3
1.
select distinct c.name from customer c join orders o on o.custid = c.custid join book b on o.bookid = b.bookid where c.name != '박지성' and exists 
(select 1 from book b2 join orders o2 on o2.bookid = b2.bookid join customer c2 on c2.custid = o2.custid 
where c2.name = '박지성' and b2.publisher = b.publisher);
2.
select c.name from customer c where exists 
(select 1 from orders o join book b on o.bookid = b.bookid where o.custid = c.custid having count(distinct b.publisher) >= 2);
3.
select b.bookid, b.bookname from book b where b.bookid in (select o.bookid from orders o group by o.bookid
having count(distinct o.custid) >= (select count(*)*0.3 from customer));

select b.bookid, b.bookname from book b where exists (select 1 from orders o where b.bookid = o.bookid
having count(distinct o.custid) >= (select count(*)*0.3 from customer));

4
select custid from orders where bookid = '1'
minus
select distinct custid from orders where bookid = '2' or bookid = '3';
-- 다른 버전
select distinct o.custid from orders o where o.bookid = '1' and 
not exists (select 1 from orders o2 where o2.custid = o.custid and (o2.bookid = '2' or o2.bookid = '3'));

5
1.
insert into book values ('스포츠 세계', '대한미디어', '10000'); -- bookid 필요
2.
delete from book where publisher = '삼성당';
3.
delete from book where publisher = '이상미디어'; -- orders 에서 참조하고있고 외래키 on delete 가 기본값(restrict) 이기때문에 삭제안됨
4.
update book set publisher = '대한출판사' where publisher = '대한미디어';
5.
create table Bookcompany (
    name varchar2(20) primary key,
    address varchar2(20),
    begin date
);
6.
alter table bookcompany add webaddress varchar2(30);
7.
insert into bookcompany values('한빛아카데미', '서울시 마포구', '1993-01-01', 'http:\\hanbit.co.kr');