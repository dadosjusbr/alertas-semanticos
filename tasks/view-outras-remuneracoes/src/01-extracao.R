library(tidyverse)
library(here)
library(glue)

source(here("setup/00-usar-db.R"), encoding = "utf-8")

# QUERY 1 ========================================================================

query_file <- here("tasks/view-outras-remuneracoes/src/01-extracao.sql")


#' Read SQL query from file
#'
#' This function reads an SQL query from a specified file and returns it as a single string.
#'
#' @param query_file The path to the SQL query file.
#' @return A string containing the SQL query.
#' @examples
#' query <- read_sql_query("path/to/query.sql")
read_sql_query <- function(query_file) {
  con <- file(query_file, "r")
  qry <- paste0(readLines(con), collapse = "\n")
  close(con)
  qry
}

qry <- read_sql_query(query_file)

remuneracao_base <- get_query(qry, conectar = TRUE)
remuneracao_base <- remuneracao_base %>% mutate(ano_mes = ym(sprintf("%d/%02d", ano, mes)))

orgaos <- get_query("select id as id_orgao, entidade, jurisdicao,
                    case when coletando::text = 'null' then 'coleta automática'
                    when coletando->0->>'collecting' = 'true' then 'coleta manual'
                    when coletando->0->>'collecting' = 'false' then 'órgão não monitorado' end as status_coleta
                    from orgaos")

orgaos <- orgaos %>%
  transmute(
    id_orgao = id_orgao,
    status_coleta = status_coleta,
    grupo = case_when(
      entidade == "Tribunal" & jurisdicao == "Estadual" ~ "Justiça Estadual",
      entidade == "Tribunal" & jurisdicao == "Eleitoral" ~ "Justiça Eleitoral",
      entidade == "Tribunal" & jurisdicao == "Trabalho" ~ "Justiça do Trabalho",
      entidade == "Tribunal" & jurisdicao == "Militar" ~ "Justiça Militar",
      entidade == "Tribunal" & jurisdicao == "Federal" ~ "Justiça Federal",
      entidade == "Tribunal" & jurisdicao == "Superior" ~ "Justiça Superior",
      entidade == "Ministério" & jurisdicao == "Ministério" ~ "Ministérios Públicos",
      entidade == "Conselho" & jurisdicao == "Conselho" ~ "Conselhos de Justiça"
    )
  )

orgaos <- orgaos %>%
  mutate(
    lbl_orgao = toupper(id_orgao),
    lbl_orgao = case_when(
      grupo == "Justiça Estadual" ~ gsub("^(TJ)(.+)$", "\\1-\\2", lbl_orgao),
      grupo == "Justiça Eleitoral" ~ gsub("^(TRE)(.+)$", "\\1-\\2", lbl_orgao),
      grupo == "Justiça do Trabalho" ~ gsub("^(TRT)(.+)$", "\\1-\\2", lbl_orgao),
      grupo == "Justiça Militar" ~ gsub("^(TJM)(.+)$", "\\1-\\2", lbl_orgao),
      grupo == "Justiça Federal" ~ gsub("^(TRF)(.+)$", "\\1-\\2", lbl_orgao),
      grupo == "Justiça Superior" ~ lbl_orgao,
      grupo == "Conselhos de Justiça" ~ lbl_orgao,
      id_orgao %in% c("mpm", "mpf", "mpt") ~ lbl_orgao,
      grupo == "Ministérios Públicos" ~ gsub("^(MP)(.+)$", "\\1-\\2", lbl_orgao),
    )
  )

periodo <- seq.Date(dmy("01-01-2018"), dmy("01-12-2025"), by = "month")

orgaos <- crossing(orgaos, ano_mes = periodo)
orgaos <- orgaos %>% mutate(mes = month(ano_mes), ano = year(ano_mes))

remuneracao_base <- left_join(orgaos, remuneracao_base)

CAMINHO_OUTPUT <- here("tasks/view-outras-remuneracoes/outputs", today())
if (!dir.exists(CAMINHO_OUTPUT)) dir.create(CAMINHO_OUTPUT)

CAMINHO_OUTPUT_FILE <- sprintf("%s/extracao.rds", CAMINHO_OUTPUT)

saveRDS(remuneracao_base, CAMINHO_OUTPUT_FILE)
