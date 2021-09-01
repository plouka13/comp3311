-- COMP3311 20T3 Final Exam
-- Q5: find genres that groups worked in

-- ... helper views and/or functions go here ...

create or replace view q5_helper ("group", genres)
as
select g.name as "group", genre
from
groups g
join
albums a
on (a.made_by = g.id);

drop function if exists q5();
drop type if exists GroupGenres;

create type GroupGenres as ("group" text, genres text);

create or replace function
    q5() returns setof GroupGenres
as $$
declare
    res record;
    results GroupGenres;
    current text;
begin
    for group in
        select "group" into current
        from q5_helper
    loop
        select genres
        from q5_helper
        where "group" = current

        results.group := curr;
        results.genres := res.genres;
        return next results;
    end loop;
end;
$$ language plpgsql;
