-- COMP3311 20T3 Final Exam
-- Q4: list of long and short songs by each group

-- ... helper views and/or functions (if any) go here ...

create or replace view q4_long (id, nlong)
as
select g.id, count(g.id)
from groups g
join
albums a
on (g.id = a.made_by)
join
songs s
on (a.id = s.on_album)
where length > 360
group by g.id;

create or replace view q4_short (id, nshort)
as
select g.id, count(g.id)
from groups g
join
albums a
on (g.id = a.made_by)
join
songs s
on (a.id = s.on_album)
where length < 180
group by g.id;

create or replace view q4_helper (id, nshort, nlong)
as
select distinct on (s.id) s.id, nshort, nlong
from
q4_short s
full outer join
q4_long l
on (l.id = s.id)
union
select distinct on (l.id) l.id, nshort, nlong
from
q4_short s
full outer join
q4_long l
on (l.id = s.id);

create or replace view q4_helper1 ("group", nshort, nlong)
as
select g.name as "group", 
case
    when nshort is null then 0
    else nshort
end nshort,
case
    when nlong is null then 0
    else nlong
end nlong
from q4_helper h
right outer join 
groups g
on (g.id = h.id);

drop function if exists q4();
drop type if exists SongCounts;
create type SongCounts as ( "group" text, nshort integer, nlong integer );

create or replace function
	q4() returns setof SongCounts
as $$
declare
    res SongCounts;
	results SongCounts;
begin
    for res in
        select * from q4_helper1
    loop
        results.group := res.group;
		results.nshort := res.nshort;
		results.nlong := res.nlong;
        return next results;
    end loop;
end;
$$ language plpgsql;