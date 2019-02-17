#  movendo dados de um CSV para um SQLite
setwd("sakila_data/")

library(readr)

# buscar todos os arquivos csv do diretório
full_dataset <- lapply(list.files(pattern="*.csv"), read_csv)

library(RSQLite)

# driver de conexão
drv <- dbDriver("SQLite")

con <- dbConnect(drv, dbname = "r_database_films.db")

# nomes dos arquivos
table_names <- c(gsub("[.]csv", "", dir(pattern = "*.csv")))

# para cada linha do dataset faça a inserção no banco
for (row in seq_along(full_dataset)){
  dbWriteTable(con, table_names[row], full_dataset[[row]], row.names = FALSE) 
}