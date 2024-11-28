library(duckdb)
library(arrow)

con <- dbConnect(duckdb::duckdb(), dbdir = "demo.duckdb")

check_if_exists <- function(con) {
  result <- dbGetQuery(con, "
      SELECT nd.*
      FROM new_data nd
      JOIN master_file mf
      ON nd.col1 = mf.col1
      AND nd.col2 = mf.col2
      ")
  return(result)
}

generate_random_data <- function(n) {
  df <- tibble::tibble(col1 = paste0(sample(LETTERS, n, replace = TRUE), sample(LETTERS, n, replace = TRUE)),
                       col2 = sample(10, n, replace = TRUE))
  return(df)
}

pip_fun <- function(df) {
  df$col2 <- df$col2 * 10
  df
}
