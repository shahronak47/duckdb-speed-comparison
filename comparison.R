source('common.R')
source('parquet_demo.R')
source('duckdb_demo.R')
source('duckplyr_demo.R')

microbenchmark::microbenchmark(
  parquet = run_parquet_fun(con, 100),
  duckdb = run_duckdb_fun(con, 100), 
  duckplyr = run_duckplyr_fun(100),
  times = 100L
)
