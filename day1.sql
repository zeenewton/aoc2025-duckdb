create table parsed as 
from read_csv('day1.txt', columns={'pos': 'VARCHAR'}, header=false)
select substring(pos, 1,1) as direction,
substring(pos,2)::int as distance,
row_number() over () as _row
;

create table running as
select direction, distance, 50 + sum(case when direction = 'L' then -distance else distance end) over (order by _row) as current_position,
_row
from parsed
;

create table with_lag as
select current_position, lag(current_position) over (order by _row) as previous_position, _row, distance
from running
;

select 
    sum(case 
        when _row = 1 and distance > 50 then distance // 100 + 1
        when current_position // 100 != previous_position // 100 and previous_position % 100 != 0 then distance // 100 + 1
        when current_position // 100 != previous_position // 100 and previous_position % 100 = 0 then distance // 100
        when current_position % 100 = 0 then 1
        else 0
    end)

from with_lag;
