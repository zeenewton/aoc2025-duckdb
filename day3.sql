set variable input_file = case when getenv('AOC_INPUT') != '' then getenv('AOC_INPUT') else 'day3.txt' end;

create table unnested as 
select pos, row_number() over () as _row
from read_csv(getvariable('input_file'), columns = { 'pos': 'VARCHAR' }, header = false)
;

create table splitted as 
select unnest(split(pos, '')) as jolt_digit, _row
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



create table p2_combinations as 
select concat(
    o1.jolt_digit, 
    o2.jolt_digit, 
    o3.jolt_digit,
    o4.jolt_digit,
    o5.jolt_digit,
    o6.jolt_digit,
    o7.jolt_digit,
    o8.jolt_digit,
    o9.jolt_digit,
    o10.jolt_digit,
    o11.jolt_digit,
    o12.jolt_digit
)::bigint as joltage, o1._row
from ordered o1
join ordered o2 on o2._row = o1._row and o2._col > o1._col
join ordered o3 on o3._row = o2._row and o3._col > o2._col
join ordered o4 on o4._row = o3._row and o4._col > o3._col
join ordered o5 on o5._row = o4._row and o5._col > o4._col
join ordered o6 on o6._row = o5._row and o6._col > o5._col
join ordered o7 on o7._row = o6._row and o7._col > o6._col
join ordered o8 on o8._row = o7._row and o8._col > o7._col
join ordered o9 on o9._row = o8._row and o9._col > o8._col
join ordered o10 on o10._row = o9._row and o10._col > o9._col
join ordered o11 on o11._row = o10._row and o11._col > o10._col
join ordered o12 on o12._row = o11._row and o12._col > o11._col
;

create table p2_max_joltages as
select _row, max(joltage) as max_joltage
from p2_combinations
group by 1
;


select sum(max_joltage) as joltage, 'part 2 - 12-digit max joltage' as description
from p2_max_joltages;
