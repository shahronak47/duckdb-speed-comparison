# duckdb-speed-comparison

Repository to compare speed for using duckdb entirely with duckdb and parquet. Also comparing it with `duckplyr` operations. This is created to test speed for a very specific use case that I have.

## Use Case :

The use case that I have is that there is a master file used for caching results. A random function exists which is used to generate random data. We generate random data and check if the data is present in the master file. Those rows that exist in master file are excluded and for the remaining ones another function is applied to them and the data is written to master file again.

## Details :

The three versions that we are comparing here are :

-   Storing master file in duckdb called as `master_file` table.
-   Storing master file in parquet format called as `output.parquet`
-   Use `duckplyr` functions instead of SQL to update data

### File details :

**common.R** - This file contains functions that is common across both the versions. It has a connection object created to interact with duckdb (`con`), a function to generate random data (`generate_random_data`), another function that returns the rows that already exists in the table (`check_if_exists`) and finally a function that we apply to the remaining rows of data (`pip_fun`).

**duckdb_demo.R** - This file has a function `run_duckdb_fun` which saves master file in duckdb.

**parquet_demo.R** - This file has a function `run_parquet_fun` which saves master file in a parquet format.

**duckplyr_demo.R** - This file has a function `run_duckplyr_fun` which saves master file in a parquet format and use `duckplyr` for query operations.

**comparison.R** - This file brings all the functions in one place and does the speed comparison between two versions.

## Comparison result :

```         
Unit: milliseconds
     expr     min       lq     mean   median       uq      max neval
  parquet 14.6805 18.07985 38.56132 21.19045 23.92260 368.2266   100
   duckdb  9.8771 13.12040 35.18727 14.55240 17.52330 338.6026   100
 duckplyr 14.9388 21.43150 59.34178 26.39650 36.74165 638.6901   100
```

Speed-wise definitely duckdb fares well however, if you compare file size `demo.duckdb` takes up more space than `output.parquet` file.
