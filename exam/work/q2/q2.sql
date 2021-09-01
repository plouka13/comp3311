-- COMP3311 20T3 Final Exam
-- Q2: group(s) with no albums

-- ... helper views (if any) go here ...

create or replace view q2("group")
as
select g.name as "group"
from albums a 
right outer join 
groups g 
on (g.id = a.made_by)
where a.id is null;

