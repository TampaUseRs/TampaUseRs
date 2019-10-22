library(tidyverse)
library(RPostgreSQL)


con <- dbConnect(PostgreSQL(),
                 host = "postgres",
                 port = 5432,
                 user = "docker",
                 password = "docker",
                 dbname = "docker"
               )
#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg=""){
  list(msg = paste0("The message is: '", msg, "'"))
}

#* Get Batting data
#* @get /batting
function() {
  dbGetQuery(con, 'SELECT * FROM "Batting"')
}
