set variable input_file = case when getenv('AOC_INPUT') != '' then getenv('AOC_INPUT') else 'day1.txt' end;

create table parsed as
from
    read_csv(
        getvariable('input_file'),
        columns = { 'pos': 'VARCHAR' },
        header = false
    )
select
    substring(pos, 1, 1) as direction,
    substring(pos, 2) :: int as distance,
    row_number() over () as _row;

create table running as
select
    direction,
    distance,
    (50 + sum(case when direction = 'L' then -distance else distance end) 
        over (order by _row)) % 100 as current_position,
    _row
from
    parsed;

create table with_lag AS
select 
    current_position, 
    coalesce(lag(current_position) over (order by _row), 50) as previous_position,
    direction,
    distance,
    _row
from running
;

select 
    count(*) as password,
    'Part 1 - Password (zeros after rotations)' as description
from with_lag
where current_position = 0
;

create table all_clicks AS
select 
    _row,
    direction,
    previous_position as start_pos,
    current_position as end_pos,
    distance,
    unnest(generate_series(1, distance)) as click_num
from with_lag
;

create table click_positions AS
select 
    _row,
    click_num,
    case 
        when direction = 'L' then
            ((start_pos - click_num) % 100 + 100) % 100
        else
            (start_pos + click_num) % 100
    end as position
from all_clicks
;

select 
    count(*) as password,
    'Part 2 - Password (zeros during clicks)' as description
from click_positions
where position = 0
;
