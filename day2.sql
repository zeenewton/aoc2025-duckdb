create table unnested as 
select unnest(split(content, ',')) as id_range
from read_text('day2.txt')
;


create table ranges as
select unnest(generate_series(split(id_range, '-')[1]::bigint, split(id_range, '-')[2]::bigint, 1)) as range_val
from unnested
;

select 
    sum(range_val)
from ranges 
where length(range_val::varchar) % 2 = 0 
and substring(range_val::varchar, 1, (length(range_val::varchar)/2)::bigint) =substring(range_val::varchar, (length(range_val::varchar)/2)::bigint + 1)
;

.mode table
;
create table sub_matches as
from ranges 
select 
    range_val, 
    case
        when substring(range_val::varchar, 1, (length(range_val::varchar)/2)::bigint) =substring(range_val::varchar, (length(range_val::varchar)/2)::bigint + 1) then range_val
        when length(range_val::varchar) > 1 and range_val::varchar = concat(repeat(substring(range_val::varchar,1,1), length(range_val::varchar))) then range_val
        when length(range_val::varchar) > 3 and range_val::varchar = concat(repeat(substring(range_val::varchar,1,2), length(range_val::varchar)//2)) then range_val
        when length(range_val::varchar) > 4 and range_val::varchar = concat(repeat(substring(range_val::varchar,1,3), length(range_val::varchar)//3)) then range_val
        when length(range_val::varchar) > 5 and range_val::varchar = concat(repeat(substring(range_val::varchar,1,4), length(range_val::varchar)//4)) then range_val
        when length(range_val::varchar) > 6 and range_val::varchar = concat(repeat(substring(range_val::varchar,1,5), length(range_val::varchar)//5)) then range_val
        when length(range_val::varchar) > 7 and range_val::varchar = concat(repeat(substring(range_val::varchar,1,6), length(range_val::varchar)//5)) then range_val
        when length(range_val::varchar) > 8 and range_val::varchar = concat(repeat(substring(range_val::varchar,1,7), length(range_val::varchar)//5)) then range_val
        when length(range_val::varchar) > 9 and range_val::varchar = concat(repeat(substring(range_val::varchar,1,8), length(range_val::varchar)//5)) then range_val
        when length(range_val::varchar) > 10 and range_val::varchar = concat(repeat(substring(range_val::varchar,1,9), length(range_val::varchar)//5)) then range_val
        else 0
    end as p_val
;

select sum(p_val)
from sub_matches
where p_val > 0