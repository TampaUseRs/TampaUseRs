library(Lahman)
library(RPostgreSQL)

LahmanBatters <- Batting

con <- dbConnect(PostgreSQL(),
                 host = "postgres",
                 port = 5432,
                 user = "docker",
                 password = "docker",
                 dbname = "docker"
               )

dbWriteTable(con, "Batting", LahmanBatters)
