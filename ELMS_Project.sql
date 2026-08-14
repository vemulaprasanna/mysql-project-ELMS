
#  ------------------ Database  Creation -----------
create database ELMS;
use ELMS;

# -------------- Tables Creation -------------------------
#1: departments
create table departments(dept_id int primary key, dept_name varchar(20));
desc departments;

#2: employees
create table employees(emp_id int primary key,dept_id int, foreign key(dept_id) references departments(dept_id), emp_name varchar(20),phone int, email varchar(20));
desc employees;

#3: managers
create table managers(mng_id int primary key,mng_name varchar(20));
desc managers;

#4: leave_types
create table leave_types(leave_type_id int primary key,leave_type_name varchar(20));
desc leave_types;

#5: leave_requests
create table leave_requests(leave_id int primary key, emp_id int, foreign key(emp_id) references employees(emp_id), mng_id int, foreign key(mng_id) references managers(mng_id), leave_type_id int, foreign key(leave_type_id) references leave_types(leave_type_id), start_date date, end_date date, total_days int, status varchar(20), reason varchar(20));
desc leave_requests;


#------------------- DATA INSERTION ------------------
#1: departments
INSERT INTO Departments VALUES
(1,'HR'), (2,'IT'), (3,'Finance'), (4,'Sales'), (5,'Administration');

select * from departments;

#2: employees
INSERT INTO Employees VALUES
(101,1,'Aarav','9876500001','aarav@mail.com'),
(102,2,'Bhavya','9876500002','bhavya@mail.com'),
(103,3,'Charan','9876500003','charan@mail.com'),
(104,4,'Divya','9876500004','divya@mail.com'),
(105,5,'Esha','9876500005','esha@mail.com'),
(106,2,'Farhan','9876500006','farhan@mail.com'),
(107,1,'Gopi','9876500007','gopi@mail.com'),
(108,3,'Hari','9876500008','hari@mail.com'),
(109,4,'Isha','9876500009','isha@mail.com'),
(110,5,'John','9876500010','john@mail.com');

select * from employees;

#3: managers
INSERT INTO Managers VALUES
(1,'Ramesh'),(2,'Priya'), (3,'Kiran'), (4,'Sneha'), (5,'Arun');

select * from managers;

#4: leave_types
INSERT INTO Leave_Types VALUES
(1,'Casual Leave'),
(2,'Sick Leave'),
(3,'Earned Leave'),
(4,'Maternity Leave'),
(5,'Unpaid Leave');

select * from leave_types;

#5: leave_requests
INSERT INTO Leave_Requests VALUES
(1001,101,1,1,'2026-07-01','2026-07-03',3,'Approved','Personal work'),
(1002,102,2,2,'2026-07-02','2026-07-04',3,'Pending','Fever'),
(1003,103,3,3,'2026-07-05','2026-07-06',2,'Approved','Vacation'),
(1004,104,4,1,'2026-07-07','2026-07-08',2,'Rejected','Family function'),
(1005,105,5,5,'2026-07-10','2026-07-12',3,'Approved','Personal'),
(1006,106,2,2,'2026-07-11','2026-07-11',1,'Pending','Medical'),
(1007,107,1,1,'2026-07-13','2026-07-15',3,'Approved','Travel'),
(1008,108,3,3,'2026-07-16','2026-07-20',5,'Approved','Vacation'),
(1009,109,4,2,'2026-07-18','2026-07-19',2,'Rejected','Sick'),
(1010,110,5,1,'2026-07-21','2026-07-22',2,'Pending','Personal');

select * from leave_requests;

             ### ---------------- SQL Questions ---------------------- ###
select * from departments;    #(dept_id,dept_name)
select * from employees;      #(emp_id,dept_id,emp_name,phone,email)
select * from managers;       #(mng_id,mng_name)
select * from leave_types;    #(leave_type_id,leave_type_name)
select * from leave_requests; #(leave_id,emp_id,mng_id,leave_type_id,start_date,end_date,total_days,status,reason)


#1. List all leave requests.
select * from leave_requests;

#2. Display leave request with employee name.
select lr.emp_id,e.emp_name from leave_requests lr join employees e on e.emp_id=lr.emp_id;

#3. Show approved leave requests.
select * from leave_requests where status='approved';

#4. Show pending leave requests.
select * from leave_requests where status='pending';

#5. Employees currently on leave.
select distinct e.emp_id, e.emp_name from employees e join leave_requests lr on e.emp_id = lr.emp_id 
where lr.status = 'Approved' and curdate() between lr.start_date and lr.end_date;

#6. Count leave requests department-wise.
select d.dept_id, d.dept_name,count(lr.leave_id) as total_requests from departments d join employees e on d.dept_id = e.dept_id 
join leave_requests lr on e.emp_id = lr.emp_id group by d.dept_id,d.dept_name;

#7. Count leave requests by status.
select status, count(*) as total_count from leave_requests group by status;

#8. Average leave days by department.
select d.dept_id, avg(lr.total_days) as Avg_Leave_Days from departments d join employees e on d.dept_id = e.dept_id 
join leave_requests lr on e.emp_id = lr.emp_id group by dept_id;

#9. Employee with maximum leave days.
select e.emp_id, e.emp_name, sum(lr.total_days) as Total_Leave_Days from employees e join leave_requests lr on e.emp_id = lr.emp_id 
group by e.emp_id, e.emp_name order by Total_Leave_Days desc limit 1;

#10. Department with maximum leave requests.
select d.dept_id, count(lr.leave_id) as Request_Count from departments d join employees e on d.dept_id = e.dept_id 
join leave_requests lr on e.emp_id = lr.emp_id group by dept_id order by Request_Count desc limit 1;

#11. Employees with more than 2 leave requests.
select e.emp_id, e.emp_name, count(lr.leave_id) as Total_Requests from employees e join leave_requests lr 
ON e.emp_id = lr.emp_id group by e.emp_id, e.emp_name having count(lr.leave_id) > 2;

#12. Employees who never applied for leave.
select e.* from employees e left join leave_requests lr on e.emp_id = lr.emp_id where lr.leave_id is null;

#13. Latest 5 leave requests.
select * from leave_requests order by start_date desc limit 5;

#14. Leave requests in last 30 days.
select * from leave_requests where start_date >= curdate() - INTERVAL 30 day;

#15. Display employee names in uppercase and lowercase.
select emp_name, upper(emp_name) as Upper_Name, lower(emp_name) as Lower_Name from employees;

#16. Show first 3 characters of employee names.
select emp_name, left(emp_name, 3) as Short_Name from employees;

#17. Calculate leave duration.
select leave_id, start_date, end_date, total_days from leave_requests;

#18. Generate Leave Reference (EL-1001).
select leave_id, concat('EL-', leave_id) as Leave_Reference from leave_requests;

#19. Leave types used more than 5 times.
select lt.leave_type_id, lt.leave_type_name, count(lr.leave_id) as Times_Used from leave_types lt 
join leave_requests lr on lt.leave_type_id = lr.leave_type_id group by lt.leave_type_id, lt.leave_type_name having count(lr.leave_id) > 5;

#20. Manager-wise approved leave count.
select m.mng_id,m.mng_name, count(lr.leave_id) as Approved_Count from managers m
join leave_requests lr on m.mng_id=lr.mng_id where lr.status = 'Approved' group by m.mng_id,m.mng_name;

#21. Employees whose leave exceeds department average.
select e.emp_name, e.dept_id, count(lr.leave_id) as emp_leave_count from employees e join leave_requests lr on e.emp_id = lr.emp_id group by e.emp_id, e.emp_name, e.dept_id 
having count(lr.leave_id) > (select avg(emp_leave_count) from ( select e2.emp_id,count(lr2.leave_id) as emp_leave_count from employees e2 
join leave_requests lr2 on e2.emp_id = lr2.emp_id where e2.dept_id = e.dept_id group by e2.emp_id) as dept_avg);

#22. Show monthly leave statistics.
select year(start_date) as year, month(start_date) as month, count(8) as leave_requests,
sum(total_days) as total_leave_days from leave_requests group by year(start_date), month(start_date) order by year,month;

#23. Longest leave taken.
select *,e.emp_name from leave_requests lr join employees e on lr.emp_id=e.emp_id order by lr.total_days desc limit 1;

#24. Remaining leave balance.
select e.emp_id, e.emp_name, 20 - coalesce(sum(case when lr.status = 'Approved' then lr.total_days else 0 END), 0) 
as Remaining_Balance from employees e left join leave_requests lr on e.emp_id = lr.emp_id group by e.emp_id, e.emp_name;

#25. Open leave requests.
select * from leave_requests where status = 'Pending';

#26. Rejected leave requests.
select * from leave_requests where status = 'Rejected';

#27. Create a view for approved leaves.
create view approved_leaves as select lr.leave_id, e.emp_name, lr.start_date, lr.end_date,lr.total_days,lr.status, lr.reason 
from leave_requests lr join employees e on lr.emp_id = e.emp_id where lr.status = 'Approved';
select * from approved_leaves;

#28. Create a view for pending leaves.
create view pending_leaves as select lr.leave_id, e.emp_name, lr.start_date, lr.end_date,lr.total_days,lr.status, lr.reason 
from leave_requests lr join employees e on lr.emp_id = e.emp_id where lr.status = 'Pending';
select * from pending_leaves;

#29. Transaction to approve leave request.
start transaction;
select * from leave_requests where leave_id = 101 and status='pending';
update leave_requests set status = 'Approved' where leave_id = 101 and status='pending';
commit;

#30. Transaction to cancel leave request and restore balance.
start transaction;
update leave_requests set status = 'cancelled' where leave_id = 101 and status='approved';
commit;

#31. create a sp to display all leave requests handled by a particular manager.
select * from leave_requests where mng_id = par_mng_req;
#To check
call get_requests_by_manager(1);

#32. create a sp to calculate total no.of leave days taken by an employee.
select e.emp_name, coalesce(sum(lr.total_days),0) as total_leave_days from employees e left join leave_requests lr on e.emp_id = lr.emp_id
where e.emp_id = p_emp_id group by e.emp_id;
#To check
call get_total_leave_days(101);

#33. create trigger on leave_requests status changes, store the leave_id,emp_id,old_status, new_status in a leave_history table.
create table leave_history (leave_id int, emp_id int, old_status varchar(20), new_status varchar(20));
select * from leave_history;
select * from leave_requests;
# To check
update leave_requests set status = 'approval' where leave_id = 1002;

#34. create a trigger on leave_requests whenever a leave req is inserted, automatically store the leave_id,emp_id,leave_type_id in leave_request_log table.
create table leave_request_log (leave_id int,emp_id int,leave_type_id int);
# To check
insert into leave_requests(leave_id, emp_id, mng_id, leave_type_id,start_date, end_date, total_days, status, reason)
values(1011, 101, 2, 1,'2026-08-20', '2026-08-22', 3, 'Pending', 'Personal work');
select * from leave_request_log;
select * from leave_requests;
