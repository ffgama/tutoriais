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