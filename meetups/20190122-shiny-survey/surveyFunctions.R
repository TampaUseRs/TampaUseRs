delphiDensityPlot <- function(vec, curTitle = NA, userChoice = NA){
  
  flog.trace("delphiDensityPlot called.")
  
  curMedian <- median(vec, na.rm=T)
  curCV <- CV(vec, na.rm=T) #Coefficient of variation
  
  #Plot an individual distribution
  gg <- ggplot(data_frame(var = vec), aes(var)) +
    geom_density(fill="#f0de7a")+
    theme_minimal() +
    xlab("Distribution of numeric input") + ylab("") +
    theme(axis.text.y = element_blank(),
          axis.title.x = element_text(size = rel(1.5)),
          axis.ticks = element_blank(),
          axis.line.y = element_line(color= NA),
          plot.title = element_text(size = rel(2.5)),
          plot.caption = element_text(size = rel(2)),
          strip.text = element_text(face = "bold", hjust = 0),
          panel.grid.minor = element_line(color= NA),
          panel.grid.major.y = element_line(color=NA),
          panel.grid.major.x = element_line(color="grey")) +
    labs(caption = sprintf("Median: %s\nLevel of Agreement (CoV): %1.2f", curMedian, curCV))

  if(!is.na(curTitle)){
    gg <- gg + ggtitle(curTitle) 
  }
  
  flog.trace("User choice for vline: %s", userChoice)  
  if(!is.na(userChoice)){
    gg <- gg +
      geom_vline(xintercept = parse_number(userChoice), 
                 color = "darkgrey", size = 2)
  }

  return(gg)
}

storeResponse <- function(appActive, item, response, poolHandle = pool){

  #If the user has not entered a matching/correct ID into the app, then don't store anything.
  if(!appActive$flag) return() 
  
  responseHours <- response %>% parse_number
  if(is.na(responseHours)) return()
  #TODO: Add some error checking and a warning (needs to be a number)
  # Consider printing the error message in red under the text box?

  # Update the right "cell" in the responses table:
  insertStmtTemplate <- "UPDATE responses SET %s = %s WHERE code = '%s';"
  insertStmt <- sprintf(insertStmtTemplate, item, response, appActive$userId)
  res <- dbExecute(poolHandle, insertStmt)
  
  #Add a row to the transactions table (the "what happened" log):
  transDf <- data_frame(date = Sys.time(),
                        code = appActive$userId,
                        question = item,
                        response = response)
  
  dbWriteTable(poolHandle, "responseTransactions", transDf, append = T, row.names = F)
  
  flog.trace("Posted userID: %s, item: %s, response: %s, to: userRoster",
             appActive$userId, item, response)
  
  return(res)
}

# Save the user's comment to the db.
storeComment <- function(userId, item, comment, poolHandle = pool){
  #Keep a running record:
  transDf <- data_frame(code = userId,
                        question = item,
                        comment = comment)
  
  dbWriteTable(poolHandle, "comments", transDf, append = T, row.names = F)

  flog.trace("Comment posted userID: %s, item: %s, comment: %s", userId, item, comment)
  
  # Code for development and debugging:
  # commentCount <- dbGetQuery(poolHandle, "SELECT count(id) FROM comments;") %>% unlist
  # flog.trace("After write, total number of comments: %s", commentCount)
  
  return(0)
}

# Return a db table column as a vector.
getTableCol <- function(table, col, poolHandle = pool){
  getResponseTemplate <- "SELECT %s FROM %s WHERE %s IS NOT NULL;"
  getResponseStmt <- sprintf(getResponseTemplate, col, table, col)
  vec <- dbGetQuery(poolHandle, getResponseStmt)
  
  return(vec)
}

# Pull one question's comments as a vector from the db table.
getCommentVec <- function(question, poolHandle = pool){
  getResponseTemplate <- "SELECT id, question, comment FROM comments WHERE question = '%s' AND comment IS NOT NULL;"
  getResponseStmt <- sprintf(getResponseTemplate, question)
  vec <- dbGetQuery(poolHandle, getResponseStmt) %>%
    arrange(id) %>% #SQLite specific? (rowid?)
    pull(comment)
  
  # Code for development and debugging:
  # commentCount <- dbGetQuery(poolHandle, "SELECT count(id) FROM comments;") %>% unlist

  return(vec)
}

# Get the user's row from the db table:
getUserRow <- function(table, userId, poolHandle = pool){
  getResponseTemplate <- "SELECT * FROM %s WHERE code = '%s';"
  getResponseStmt <- sprintf(getResponseTemplate, table, userId)
  vec <- dbGetQuery(poolHandle, getResponseStmt)
  
  return(vec)
}

CV <- function(x, na.rm=F){
  #' Coefficient of Variance for Delphi
  #' __Stability:__ 
  #' Dajani et al. [17] suggest that the CoV can be used to measure stability 
  #' by checking for changes between two successive rounds.
  #' __Consensus:__
  #' From English and Keran [87]:
  #' 0 < V ≤ 0.5      Good degree of consensus. No need for additional round.
  #' 0.5 < V ≤ 0.8   Less than satisfactory degree of consensus. Possible need for additional round.
  #' V > 0.8 ￼ ￼        Poor degree of consensus. Definite need for additional round.
  sd(x,na.rm = na.rm)/mean(x,na.rm = na.rm)
}

# Old Code ----------------------------------------------------------------

# storeResponse <- function(userId, item, response, config){
#   #The Google Sheets Variant/Interface

#   whichRow <- match(userId, config$exampleTable$code)
#   whichCol <- match(item, names(config$exampleTable))
#   
#   #TODO: Trap and handle the error that occurs if row or col are not matched. 
#   
#   #Convert to Excel letter format
#   anchorCode <- paste0(letters[whichCol], whichRow+1)
#   
#   gs_edit_cells(config$googleSheet, input = response, anchor = anchorCode)
#   
#   flog.trace("Posted userID: %s, item: %s, response: %s, to: %s", 
#              userId, item, response, anchorCode)
#   
#   return(200)
# }
