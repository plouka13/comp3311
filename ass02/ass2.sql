 -- COMP3311 20T3 Assignment 2
-- z5207453, Peter Louka, October-November 2020
-- Q1: students who've studied many courses
create or replace view Q1(unswid,name)
as
select p.unswid, p.name
from people p join course_enrolments ce 
on (p.id = ce.student)
group by p.unswid, p.name
having count(*) > 65;

-- Q2: numbers of students, staff and both
create or replace view Q2(nstudents,nstaff,nboth)
as
select * from (
   select count(students.id) 
   as nstudents from students
   ) as stu,
   (
      select count(staff.id) 
      as nstaff from staff
   ) as stf,
   (
      select count(inter.id) as nboth 
      from (
         (select id from students) 
         intersect 
         (select id from staff)
      ) as inter
      ) as bth;


-- Q3: prolific Course Convenor(s)
create or replace view Q3_helper(name, n)
as 
select p.name as name, count(cs.staff) as n 
from people p join course_staff cs 
on (p.id = cs.staff) 
where cs.role = 1870 
group by name 
order by n desc;

create or replace view Q3(name,ncourses)
as
select name, n as ncourses 
from q3_helper 
where n = (
   select max(n) 
   from q3_helper
);



-- Q4: Comp Sci students in 05s2 and 17s1
create or replace view Q4a(id,name)
as
select p.unswid as id, p.name
from people p join program_enrolments pe 
on (p.id = pe.student)
where pe.term = 138 and pe.program = 554;

create or replace view Q4b(id,name)
as
select p.unswid as id, p.name
from people p join program_enrolments pe
on (p.id = pe.student)
where pe.term = 214 and pe.program = 6788;



-- Q5: most "committee"d faculty
-- View of all faculties
create or replace view q5_helper1(id, faculty, name)
as
select id, facultyof(id), name 
from orgunits 
where utype = 1;

-- View of all committees
create or replace view q5_helper2(id, faculty, name)
as
select id, facultyof(id), name 
from orgunits 
where utype = 9 
and facultyof(id) is not null;

-- View of count of committees in each faculty
create or replace view q5_helper3(n, name)
as
select count(h2.faculty) as n, h1.name
from q5_helper2 h2 join q5_helper1 h1
on (h2.faculty = h1.id)
group by h2.faculty, h1.name;

-- Answer
create or replace view Q5(name)
as
select name from
q5_helper3
where n = (
   select max(n)
   from q5_helper3
);

-- Q6: nameOf function

create or replace function
   Q6(id integer) returns text
as $$
   select p.name
   from people p
   where $1 = p.id
   or $1 = p.unswid;
$$ language sql;

-- Q7: offerings of a subject

create or replace function
   nameFromID(id integer) returns text
as $$
   select p.name
   from people p
   where $1 = p.id
   or $1 = p.unswid;
$$ language sql;

create or replace function
   subjectName(id integer) returns text
as $$
   select s.name
   from subjects s
   where $1 = s.id;
$$ language sql;

create or replace function
   termName(id integer) returns text
as $$
   select t.name
   from terms t
   where $1 = t.id;
$$ language sql;

create or replace function
   Q7(subject text)
     returns table (subject text, term text, convenor text)
as $$
   select subjectName(c.subject) as subject, termName(c.term) as term, nameFromID(cs.staff) as convenor
   from courses c join course_staff cs
   on (cs.course = c.id)
   where $1 = subjectName(c.subject);
$$ language sql;

-- Q8: transcript
/*
create or replace function
   Q8(zid integer) returns setof TranscriptRecord
as $$
...
$$ language plpgsql;

-- Q9: members of academic object group

create or replace function
   Q9(gid integer) returns setof AcObjRecord
as $$
...
$$ language plpgsql;

-- Q10: follow-on courses

create or replace function
   Q10(code text) returns setof text
as $$
...
$$ language plpgsql;

*/