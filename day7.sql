set variable input_file = case when getenv('AOC_INPUT') != '' then getenv('AOC_INPUT') else 'day7.txt' end;

create table unnested as 
select unnest(split(content, ',')) as id_range
from read_text(getvariable('input_file'))
;