-- COMP3311 20T3 Final Exam
-- Q1: longest album(s)

-- ... helper views (if any) go here ...

-- view to get total of all albums
create or replace view q1_helper1 (album_id, total)
as
select on_album as album_id, sum(length) as total
from songs
group by on_album
order by total desc;

-- view to get largest totals of all albums
create or replace view q1_top (album_id, total)
as
select * from q1_helper1 
where total = (
    select max(total) 
    from q1_helper1
);

-- view to get correct output
create or replace view q1 ("group",album,year)
as
select g.name as "group", a.title as album, a.year as year
from albums a
join groups g
on (g.id = a.made_by)
join q1_top
on (q1_top.album_id = a.id);

