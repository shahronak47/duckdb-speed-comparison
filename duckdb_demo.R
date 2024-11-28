run_duckdb_fun <- function(con, n) {
  new_data <- generate_random_data(n)
  #new_data <- data.frame(col1 = c("FS","AB", "AQ"), col2 = c(6, 8, 5))
  
  duckdb::duckdb_register(con, "new_data", new_data, overwrite = TRUE)
  #check_if_exists(con)
  append_data <- dbGetQuery(con, "
  SELECT nd.*
  FROM new_data nd
  LEFT JOIN master_file mf
  ON nd.col1 = mf.col1 AND nd.col2 = mf.col2
  WHERE mf.col1 IS NULL AND mf.col2 IS NULL
")
  
  
  append_data <- pip_fun(append_data)
  # Register in memory
  duckdb::duckdb_register(con, "append_data", append_data, overwrite = TRUE)
  cat('\nWriting ', nrow(append_data),  'rows to DB :\n')
  
  out <- dbExecute(con, "
  CREATE OR REPLACE TABLE master_file AS
  SELECT * FROM (
    SELECT * FROM master_file
    UNION ALL
    SELECT ad.* FROM append_data ad
    LEFT JOIN master_file mf
    ON ad.col1 = mf.col1 AND ad.col2 = mf.col2
    WHERE mf.col1 IS NULL AND mf.col2 IS NULL
  )
")
  
  message('Completed writing data to DB')
}

#run_duckdb_fun(con, 100)

#dbGetQuery(con, "select * from master_file")
#dbWriteTable(con, "master_file", data, overwrite = TRUE)
#dbDisconnect(con, shutdown = TRUE)
