# coletar o data
extract_data <- read.csv("https://raw.githubusercontent.com/ffgama/datasets/master/games.csv", header = TRUE, sep=",")
# estrutura do dataset 
str(extract_data)

# coletar apenas as primeiras 500 instâncias
dataset_game<- extract_data[1:500,]

# criando nova coluna 
dataset_game <- data.frame(dataset_game, Global_Sales_Acc = apply(as.matrix(dataset_game$Global_Sales), 2, cumsum))
head(dataset_game)

# carga do pacote
library(dplyr)
# resumo estatístico das features
dataset_game %>% head() %>% summary() 


############# FILTRO 

# filtra um conjunto de linhas sob determinadas condições
filter(dataset_game, Publisher == "Nintendo", EU_Sales >= 5 & Year == 2006)

# outra maneira de realizar o filtro
filter(dataset_game, Publisher == "Nintendo", Year %in% c(2014:2016))


############################# SELEÇÃO DOS DADOS ############################# 
# selecionar apenas um conjunto de colunas que sejam de interesse, neste caso: Publisher, Genre e Global_Sales.
select_game <-  select(dataset_game, Publisher, Genre, Global_Sales)
head(select_game)


# fatiando o conjunto de dados extraindo as 15 primeiras linhas e retornando as colunas desejadas dentro de um intervalo
slice_game <- slice(select(dataset_game, Name:Publisher), 1:15)
slice_game

# excluindo a coluna plataforma
game_slice <- slice(select(slice_game, -(Platform)))
game_slice

# combinando filter e select. As colunas: Name, Publisher e Global_Sales são selecionadas e em seguida aplica-se um filtro para selecionar apenas o total de vendas globais acima de 15 milhões.
filter(select(dataset_game, Name, Publisher, Global_Sales), Global_Sales>=15)


# mesmo resultado da última figura
dataset_game %>%
  select(Name, Publisher, Global_Sales) %>%
  filter(Global_Sales >= 15)


# ordenando os resultados pelo valor total de vendas
dataset_game %>%
  select(Name, Publisher, Global_Sales) %>%
  filter(Global_Sales >= 15) %>%
  # crescente
  arrange(Global_Sales)


# criando colunas a partir de outras colunas
dataset_game %>%
  # colunas de interesse
  select(Name, Year, Global_Sales) %>%
  # vendas globais acima de 20 milhões
  filter(Global_Sales >= 20) %>%
  # decrescente
  arrange(desc(Global_Sales)) %>%
  # cria duas colunas a partir das colunas existentes
  mutate(Short_Year = substring(Year, 3,4), Sales_Acc = cumsum(Global_Sales))

# group_by
dataset_game %>%
  # colunas de interesse
  select(Name, Year, Publisher, Global_Sales) %>%
  # vendas globais acima de 20 milhões
  filter(Global_Sales >= 20) %>%
  # decrescente
  arrange(desc(Global_Sales)) %>%
  # cria duas colunas a partir das colunas existentes
  mutate(Sales_Acc = cumsum(Global_Sales)) %>%
  # agrupando por Fabricante
  group_by(Publisher) %>%
  # soma acumulada por Fabricante
  summarise(Tot_Acc_Publisher = sum(Global_Sales))

# carga do pacote
library(RMySQL)
# abrindo a conexão com o servidor de banco de dados 
con <- dbConnect(MySQL(), db="games", user="root", password="1234", host="localhost")  
# retornando as tabelas desse banco de dados
dbListTables(con, "games")

# manipulando os dados da tabela como um dataframe
dataset_games <- dbReadTable(con, "vgsales")
dim(dataset_games)

# leitura do arquivo e criação de uma coluna que armazena a soma acumulativa das vendas globais (Global_Sales).
dbGetQuery(con, "SELECT *, SUM(Global_Sales) OVER (ROWS UNBOUNDED PRECEDING) as Cumulative_Sales 
           FROM vgsales")

# via dplyr
dataset_games %>% mutate(Cumulative_Sales = cumsum(Global_Sales)) %>% head()


# coletar apenas as primeiras 500 instâncias
dataset_game<- extract_data[1:500,]
# criando nova coluna 
dataset_game <- data.frame(dataset_game, Global_Sales_Acc = apply(as.matrix(dataset_game$Global_Sales), 2, cumsum))
head(dataset_game)

############################################################ PART 2 ############################################################ 
library(dplyr)
# coletar o data
extract_data <- read.csv("https://raw.githubusercontent.com/ffgama/datasets/master/games.csv", header = TRUE, sep=",")
# estrutura do dataset 
str(extract_data)

# extraindo aleatoriamente passando o PERCENTUAL do tamanho da amostra
extract_data %>% sample_frac(0.5)

# garantindo a reproducibilidade da amostra
set.seed(123)
# extraindo aleatoriamente passando o VALOR EXATO do tamanho da amostra
dataset_game <- extract_data %>% sample_n(500)
# selectionando apenas as 'n' primeiras linhas
dataset_game %>% top_n(10)

# renomeando a coluna Global_Sales_Acc e  garantindo o retorno de instâncias únicas do dataset
dataset_game <- dataset_game %>%  rename(Game = Name) %>% distinct()
dataset_game %>% top_n(10)

# selecionando apenas as colunas que terminam com uma determinada string.
dataset_game %>% select(ends_with(c("Sales"))) %>% head()

# aplicando o summarise para cada coluna
dataset_game %>% select(ends_with(c("Sales"))) %>% summarise_all(funs(mean))

# contando o número de ocorrências únicas para a colujna em questão
dataset_game %>% count(Y = Year)

### combining datasets

# selecionando as primeiras 500 linhas assim como as colunas correspondentes (games x vendas)
data_game <- extract_data[1:500,c(1:6)] 
data_sales <- extract_data[501:700,c(7:11)]

# criando uma coluna id
data_game <- data.frame(id=1:nrow(data_game), data_game)
data_sales <- data.frame(id=1:nrow(data_sales), data_sales)


# 1) left join
left_join(data_game, data_sales, by="id") %>% summary()

# 2) right join
right_join(data_game, data_sales, by="id") %>% summary()

# 3) inner join
inner_join(data_game, data_sales, by="id") %>% summary()

# 4) full join
full_join(data_game, data_sales, by="id") %>% summary()

# 5) bind rows
bind_rows(data_game, data_sales) %>% summary()

# 6) bind cols
bind_cols(data_game[1:200,], data_sales) %>% summary()

