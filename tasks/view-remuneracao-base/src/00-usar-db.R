# ==============================================================================
# FUNÇÕES PARA LEITURA DE DADOS NO BANCO DE DADOS DO DADOSJUSBR ================
# ==============================================================================

#' @title Funçao para conectar no banco de dados correto
#' @description essa função faz a conexão com o banco de dados
#' @param dbname nome do banco que será acessado
#' @param port porta
#' @param user nome do usuário que acessa o banco
#' @param password senha do usuário para entrar no banco
#' @param host nome do servidor que hospeda o banco
#' @details hint: {keiring} é um pacote para criptografar localmente dados sensíveis. Substitua o que está em keyring::key_get() pela forma de autenticação de sua preferência.
#'
use_postgres <- function(
  dbname = keyring::key_get("dadosjusbr_dbname"),
  port = 5432,
  user = keyring::key_get("dadosjusbr_dbuser"),
  password = keyring::key_get("dadosjusbr_dbsecret"),
  host = keyring::key_get("dadosjusbr_dbhost")
) {

  message("Conectando ao banco de dados Postrgres - DadosJusBr")

  # faz a coneoxão com o banco
  con <<- DBI::dbConnect(
    RPostgres::Postgres(),
    dbname = dbname,
    port = port,
    user = user,
    password = password,
    host = host
  )

  return(con)
  message("Conectado! Objeto {con} incluído no workspace.")
}

#' @title Função para chamar tabelas no banco postgres
#' @param qry comando mysql, exemplo "select * from coletas;"
#' @param conectar marque TRUE para conectar ao banco de dados antes de fazer a query.
#' @param quiet ao rodar a função uma mensagem aparece no console, quiet=TRUE desabilita essa mensagem.
get_query <- function(qry, conectar = FALSE, quiet = FALSE) {

  # se quiser reiniciar a comunicação basta indicar `conectar = TRUE`
  if (conectar) use_postgres()

  # Se não quiser ver essa mensagem printada no console defina `quiet = TRUE`
  dbname <- DBI::dbGetInfo(con)$dbname
  if (!quiet) message(sprintf("dbname: %s\n %s", dbname, qry))

  # envia a query para o banco de dados e retorna uma tibble
  df <- DBI::dbGetQuery(con, qry) |> tibble::as_tibble()
  return(df)
}

# listando as tabelas do banco
query_table_names <- "select table_name from information_schema.tables where table_type = 'BASE TABLE' and table_schema = 'public';"

show_tables_dadosjusbr <- get_query(query_table_names, conectar = TRUE, quiet = TRUE)

# outputs gerados são informados no consule quando rodamos o script com `source()`:
message("- rode `use_postgres()` para se conectar ao banco de dados")
message("- rode `get_query('select * from remuneracoes limit 5;')` para executar um exemplo de query")
message("- rode `show_tables_dadosjusbr` para ver o nome das tabelas do DadosJusBr")