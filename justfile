test arg:
    AOC_INPUT=day{{arg}}-test.txt duckdb < day{{arg}}.sql

day arg:
    duckdb < day{{arg}}.sql
