run_duckplyr_fun <- function(n) {
  new_data <- generate_random_data(n)
  #new_data <- data.frame(col1 = c("FS","AB", "AQ"), col2 = c(6, 8, 5))
  master_file <- read_parquet('output.parquet')
  append_data <- duckplyr::anti_join(new_data, master_file, by = c("col1", "col2"))
  
  append_data <- pip_fun(append_data)
  new_data <- duckplyr::bind_rows(master_file, append_data)
  temp_file <- tempfile(fileext = ".parquet")
  arrow::write_parquet(new_data, temp_file)
  file.rename(temp_file, "output.parquet")
  cat('\nWriting ', nrow(append_data),  'rows to DB :\n')
    
  message('Completed writing data to DB')
}

run_duckplyr_fun(10)
