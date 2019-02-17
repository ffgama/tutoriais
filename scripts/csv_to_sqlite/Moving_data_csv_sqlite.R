# library(RMySQL)
# #
# # ls("package:RMySQL")
# #
# con <- dbConnect(MySQL(), user = "root", password = "1234", dbname = "sakila", host = "localhost")
# 
# # listar todas as tabelas
# dbListTables(con)
# 
# dbListFields(conn = con, name = "actor")
# dbListFields(conn = con, name = "film_actor")
# dbListFields(conn = con, name = "film")
# dbListFields(conn = con, name = "language")
# #
# rs = dbSendQuery(con, "select * from film")
# 
# data = fetch(rs, n=-1)
# data
# 
# write.csv(data, file = "film.csv", row.names = FALSE)


#  movendo dados de um CSV para um SQLite
setwd("sakila_data/")

library(dplyr)
library(readr)

full_dataset <- lapply(list.files(pattern="*.csv"), read_csv)

library(RSQLite)

drv <- dbDriver("SQLite")

con <- dbConnect(drv, dbname = "r_database_films.db")

table_names <- c("actor", "film", "film_actor", "language")

for (row in seq_along(full_dataset)){
  dbWriteTable(con, table_names[row], full_dataset[[row]], row.names = FALSE) 
}

# fiz a gravação
# dentro do DB SQLite posso inserir essas instruções para testar.

#SELECT * FROM film_actor;
#SELECT * FROM film f JOIN film_actor fa on f.film_id = fa.film_id;   