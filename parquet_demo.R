run_parquet_fun <- function(con, n) {
  new_data <- generate_random_data(n)
  #new_data <- data.frame(col1 = c("FS","AB", "AQ"), col2 = c(6, 8, 5))
  
  duckdb::duckdb_register(con, "new_data", new_data, overwrite = TRUE)
  #check_if_exists(con)
  append_data <- dbGetQuery(con, "
  SELECT nd.*
  FROM new_data nd
  LEFT JOIN read_parquet('output.parquet') mf
  ON nd.col1 = mf.col1 AND nd.col2 = mf.col2
  WHERE mf.col1 IS NULL AND mf.col2 IS NULL
")
  
  
  append_data <- pip_fun(append_data)
  # Register in memory
  duckdb::duckdb_register(con, "append_data", append_data, overwrite = TRUE)
  cat('\nWriting ', nrow(append_data),  'rows to DB :\n')
  
  
  dbExecute(con, paste0("
  COPY (SELECT * FROM read_parquet('output.parquet')
        UNION ALL
        SELECT nd.* FROM new_data nd
        LEFT JOIN read_parquet('output.parquet') mf
        ON nd.col1 = mf.col1 AND nd.col2 = mf.col2
        WHERE mf.col1 IS NULL AND mf.col2 IS NULL) 
  TO 'output.parquet' (FORMAT PARQUET)
"))
  
  message('Completed writing data to DB')
}

#run_parquet_fun(con, 100)
#read_parquet('output.parquet')
#dbDisconnect(con, shutdown = TRUE)
