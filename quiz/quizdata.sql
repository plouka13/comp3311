create table S (x integer, y integer);
create table T (z integer);

create or replace function checkXlarger() returns trigger
as $$
declare
    minX integer; maxZ integer;
begin
    select min(x) into minX from S;
    select max(z) into maxZ from T;
    if (maxZ >= minX) then
       raise exception 'All S.x must be greater than all T.z';
    end if;
    return new; 
end;
$$ language plpgsql;