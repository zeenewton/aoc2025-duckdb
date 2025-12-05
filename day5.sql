set variable input_file = case when getenv('AOC_INPUT') != '' then getenv('AOC_INPUT') else 'day5.txt' end;

create table raw as 
select content
from read_csv(getvariable('input_file'), columns = { 'content': 'VARCHAR' }, header = false)
;

create table fresh_ranges as 
select 
    split(content, '-')[1]::bigint as min_range, 
    split(content, '-')[2]::bigint as max_range
from raw
where content like '%-%'
;

create table check_values as
select content::bigint as _value
from raw
where content != '' and content not like '%-%'
;

select count(distinct _value)
from check_values
join fresh_ranges on check_values._value >= fresh_ranges.min_range and check_values._value <= fresh_ranges.max_range
;

create table fresh_ranges_row as 
select *, row_number() over (order by min_range, max_range) as rownum
from fresh_ranges
;

create table dedupe_filtered as 
with recursive deduplicated_ranges (iteration, min_range, max_range, keep_value) as (
    select 1 as iteration, min_range, max_range, true as keep_value from fresh_ranges_row
    where rownum = 1
    union
    select
    previous.iteration + 1 as iteration,
    greatest(previous.max_range + 1, current.min_range) as min_range,
    case 
        when previous.max_range > current.max_range then previous.max_range
        else current.max_range
    end as max_range,
    case
        when current.max_range > previous.max_range then true
        else false
    end as keep_value
    from deduplicated_ranges previous
    cross join fresh_ranges_row as current
    where current.rownum = previous.iteration + 1
), deduplicated_ranges_filtered as (
    select min_range, max_range
    from deduplicated_ranges
    where keep_value = true
)
select * from deduplicated_ranges_filtered;


select sum(max_range - min_range + 1)
from dedupe_filtered;

