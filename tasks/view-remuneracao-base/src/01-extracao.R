library(tidyverse)
library(here)
library(glue)

source(here("tasks/view-remuneracao-base/src/00-usar-db.R"), encoding = "utf-8")

# QUERY 1 ========================================================================

query_file <- here("tasks/view-remuneracao-base/src/01-extracao.sql")

# query no BD
con <- file(query_file, "r")
qry <- paste0(readLines(con), collapse = "\n")
close(con)

result <- get_query(qry, conectar = TRUE)

saveRDS(result, here(glue("tasks/view-remuneracao-base/outputs/extracao-{today()}.rds")))