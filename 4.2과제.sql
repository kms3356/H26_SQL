7
1.
select * from R where A = 'a2'
2.
select A,B from R
3.
select * from R join S on R.c = S.c

8
1.
select * from r inner join s on r.c = s.c
2.
select * from r left outer join s on r.c = s.c;
3.
select * from r right outer join s on r.c = s.c
4.
select * from r full outer join s on r.c = s.c
5.
select * from r cross join s;

9
1. 
select a,b from r1 union select a,b from r2 union select a,b from r3;
2.
select a,b from r1 union all select a,b from r2 union all select a,b from r3;

10
select c.custid, c.name from customer c where exists (select 1 from orders o where o.custid = c.custid);

17
1.
select distinct custid, address from cust_addr where custid = 1;
2.
select distinct custid, phone from cust_addr where custid =1;
3.
select phone from cust_addr where custid = 1 and addrid = 1;
4.
select phone from cust_addr where custid = 1 and changedate = (select max(changedate) from cust_addr where custid = 1 and changedate < to_date('2025-01-01','yyyy-mm-dd'));

18
1.
select bookid from cart where custid = 1;
2.
select b.bookid, b.bookname from book b where not exists (select 1 from cart c where c.bookid = b.bookid and c.custid = 1);
3.
select sum(b.price) from book b where exists (select 1 from cart c where c.bookid = b.bookid and c.custid = 1); 

19
1.
create table Dept (
    deptno number(2) primary key
    , dname varchar2(14)
    , loc varchar2(13)
);
2.
create table EMP (
    empno number(4) primary key
    , ename varchar2(10)
    , job varchar2(9)
    , mgr number(4)
    , hiredate date
    , sal number(7,2)
    , comm number(7,2)
    , deptno number(2) references Dept (deptno)
    constraint fk_emp foreign key (mgr) references Emp(empno)
);
5.
INSERT INTO Emp (empno,ename, job,mgr, hiredate,sal,comm,deptno ) values
(7654,‘MARTIN’, ‘SALESMAN’,7698, to_date(‘1981-09-28 00:00:00’, 'yyyy-mm-dd hh24:mm:ss'), 1250,1400,50);
6.
select ename, dname, loc from emp join dept on emp.deptno = dept.deptno;
7.
select empno, ename, dname from emp join dept on emp.deptno = dept.deptno;
8.
select ename, job, sal from emp where deptno = (select deptno from dept where loc = 'DALLAS');
9.
select ename, job from emp where deptno = (select deptno from dept where loc = 'DALLAS');
10.
select ename, sal from emp where sal > (select avg(sal) from emp);
11.
select e.ename as 직원, e1.ename as 상사 from emp e left join emp e1 on e.mgr = e1.empno;
12.
select e.ename, e.sal, d.dname from emp e join dept d on e.deptno = d.deptno join 
(select deptno, max(sal) as max_sal from emp group by deptno) m on e.deptno = m.deptno and e.sal = m.max_sal; 
13.
alter table dept add manager varchar2(10);
update dept set manager = 'JONES' where deptno = 10;

20-1
1.
select 극장이름, 위치 from 극장;
2.
select * from 극장 where 위치 = '잠실';
3.
select 이름 from 고객 where 주소 = '잠실' order by 이름;
4.
select 극장번호, 영화제목 from 상영관 where 가격 <= 8000;
5.
select 이름, 극장이름, 위치 from 고객 join 극장 on 고객.주소 = 극장.위치;

20-2
1.
select count(*) from 극장;
2.
select avg(가격) from 상영관;
3.
select count(*) from 예약 where 날짜 = to_date('2025-09-01', 'yyyy-mm-dd');

20-3
1.
select 영화제목 from 상영관 where 극장번호 = (select 극장번호 from 극장 where 극장이름 = '대한');
2.
select g.이름 from 고객 g where exists (select 1 from 예약 y join 극장 k on y.극장번호 = k.극장번호 where g.고객번호 = y.고객번호 and k.극장이름 = '대한');
3.
select sum(가격) from 상영관 s join 예약 y on s.상영관번호 = y.상영관번호 and s.극장번호 = y.극장번호 
where s.극장번호 = (select 극장번호 from 극장 where 극장이름 = '대한');

20-4
1.
select 극장번호, count(distinct 상영관번호) as 상영관수 from 상영관 group by 극장번호;
2.
select * from 상영관 s join 극장 g on s.극장번호 = g.극장번호 where g.위치 = '잠실';
3.
select avg(예약건수) as 평균관람수 from 
(select count(*) as 예약건수 from 예약 where 날짜 = to_date('2025-09-01', 'yyyy-mm-dd') group by 극장번호);
4.
select s.영화제목, count(y.고객번호) as 관람객수 from 상영관 s join 예약 y on s.극장번호 = y.극장번호 and s.상영관번호 = y.상영관번호
where 날짜 = to_date('2025-09-01','yyyy-mm-dd')
group by 영화제목 having count(y.고객번호) = 
(select max(count(고객번호)) from 예약 where 날짜 = to_date('2025-09-01','yyyy-mm-dd') group by 극장번호, 상영관번호);


20-5
1.
insert into 극장 values(5,'멈멈', '강북');
2.
update 상영관 o set 가격 = (select 가격*1.1 from 상영관 o1 where o.극장번호 = o1.극장번호 and o.상영관번호 = o1.상영관번호);

21
1.
create table Salesperson(
    name varchar2(20) primary key
    , age number
    , salary number
);
create table Order(
    num number unique
    , custname varchar2(20) references customer(name)
    , salesperson varchar2(20) references salesperson(name)
    , amount number 
    , constraint pk_order primary key (custname, salesperson)
);
create table Customer(
    name varchar2(20) primary key
    , city varchar2(20)
    , industrytype varchar2(10)
)

2.
select distinct name, salary from salesperson
3.
select name from salesperson where age < 30;
4.
select name from customer where city like '%울';
5.
select count(distinct custname) from orders;
6.
select salesperson, count(*) from orders group by salesperson;
7.
select s.name, s.age from salesperson s where exists 
(select 1 from orders o join customer c on c.name = o.custname where o.salesperson = s.name and c.city = '서울');
8.
select s.name, s.age from salesperson s join orders o on o.salesperson = s.name join customer c on o.custname = c.name
where c.city = '서울';
9.
select salesperson, count(*) from orders group by salesperson having count(*) >= 2;
10.
update salesperson set salary = 45000 where name = '김철수';

22
2.
select name from employee;
3.
select name from employee where sex = '여'
4.
select e.name from employee e join department d on d.manager = e.empno; 
5.
select e.name, e.address from employee e join department d on d.deptno = e.deptno where d.deptname = 'IT부서';
6.
select count(*) as 사원수 from employee e join department d on d.deptno = e.deptno where d.manager = (select empno from employee where name = '이영희');
7.
select w.hours_worked from works w join employee e on e.empno = w.empno order by e.deptno, e.name;
8.
select p.projno, p.projname, count(w.empno) from project p join works w on p.projno = w.projno group by p.projno, p.projname
having count(w.empno) >= 2;
9.
select e.deptno, e.name from employee e where e.deptno in (select deptno from employee group by deptno having count(*) >=3);