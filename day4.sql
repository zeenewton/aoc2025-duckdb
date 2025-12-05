set variable input_file = case when getenv('AOC_INPUT') != '' then getenv('AOC_INPUT') else 'day4.txt' end;

create table raw as 
select content
from read_text(getvariable('input_file'))
;
with matrix as (
    select list_transform(str_split_regex(content, '\n'), lambda x: split(x, '')) as _matrix
    from raw
), y as (
    select unnest(generate_series(1, length(_matrix))) as _y
    from matrix
), x as (
    select unnest(generate_series(1, length(_matrix[1]))) as _x
    from matrix
), sums as (
select 
    list_sum(
        [
            case when _x > 1 and _matrix[_x-1][_y] = '@' then 1 else 0 end,
            case when _x > 1 and _y > 1 and _matrix[_x-1][_y-1] = '@' then 1 else 0 end,
            case when _x > 1 and _y < length(_matrix) and _matrix[_x-1][_y+1] = '@' then 1 else 0 end,

            case when _y > 1 and _matrix[_x][_y-1] = '@' then 1 else 0 end,
            case when _y < length(_matrix) and _matrix[_x][_y+1] = '@' then 1 else 0 end,
            
            case when _x < length(_matrix[1]) and _matrix[_x+1][_y] = '@' then 1 else 0 end,
            case when _x < length(_matrix[1]) and _y > 1 and _matrix[_x+1][_y-1] = '@' then 1 else 0 end,
            case when _x < length(_matrix[1]) and _y < length(_matrix) and _matrix[_x+1][_y+1] = '@' then 1 else 0 end
        ]
    ) as _sum

from x
join y on 1=1
join matrix on 1=1
where _matrix[_x][_y] = '@'
)
select count(_sum)
from sums
where _sum < 4
;

