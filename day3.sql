set variable input_file = case when getenv('AOC_INPUT') != '' then getenv('AOC_INPUT') else 'day3.txt' end;

create table unnested as 
select pos, length(pos) as row_len, row_number() over () as _row
from read_csv(getvariable('input_file'), columns = { 'pos': 'VARCHAR' }, header = false)
;

create table splitted as 
select unnest(split(pos, '')) as jolt_digit, _row, row_len
from unnested
;

create table ordered as 
select *, row_number() over (partition by _row) as _col
from splitted
;

create table combinations as 
select concat(o1.jolt_digit, o2.jolt_digit)::int as joltage, o1._row
from ordered o1
join ordered o2 on o2._row = o1._row and o2._col > o1._col
;

create table max_joltages as
select _row, max(joltage) as max_joltage
from combinations
group by 1
;

select sum(max_joltage) as joltage, 'part 1 - 2-digit max joltage' as description
from max_joltages;

with recursive solve (pos, position, acc, remaining_pos) using key (pos) as (
    select
        pos as pos,
        0 as position,
        ''::varchar as acc,
        pos as remaining_pos
    from unnested
    union
    select pos, position, acc, remaining_pos from (
        select
            pos as pos,
            previous.position + 1 as position,                
            string_split(previous.remaining_pos, '') as splitted,
            list_max(splitted[:(previous.position - 12)]) as digit,
            list_indexof(splitted, digit) as digit_position,
            previous.acc || digit as acc,
            previous.remaining_pos[digit_position+1:] as remaining_pos
        from solve previous
    )
    where position <= 12
)
select sum(acc::bigint), 'part 2 - 12-digit max joltage' as description from solve