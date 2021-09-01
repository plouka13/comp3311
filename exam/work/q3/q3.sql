-- COMP3311 20T3 Final Exam
-- Q3:  performer(s) who play many instruments

-- ... helper views (if any) go here ...

create or replace view instrument_count (n)
as
select count(*) as n from 
(select distinct
case 
    when instrument ~* 'guitar' then 'guitar' 
    else instrument 
end instrument
from playson
where instrument != 'vocals') as a;


create or replace view q3_helper0 (id, performer, instrument)
as
select distinct per.id, per.name,
case
    when plays.instrument ~* 'guitar' then 'guitar'
    else plays.instrument
end instrument
from 
performers per
join 
playson plays
on (per.id = plays.performer)
where plays.instrument != 'vocals';

create or replace view q3(performer,ninstruments)
as
select performer, ninstruments from
(select id, performer, count(*) as ninstruments 
from q3_helper0
group by id, performer 
order by ninstruments desc) as a
where a.ninstruments > (select n from instrument_count) / 2;
