## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ----packages------------------------------------------------------------
library(magrittr)
library(stringr)

## ----cleaning up---------------------------------------------------------
if( grepl("file_manipulation_exercise",basename(getwd())) ){
  list.files(pattern = "txt$")  %>% 
    file.remove()
  
  list.files(pattern = "^\\d.*\\d$") %>% 
    file.remove()
  
  file.remove("mylogfile")
}


## ------------------------------------------------------------------------
for(i in 1:10){
  Sys.sleep(1)
  
  Sys.time() %>% 
    as.character() %>% 
    str_replace_all(":", "_") %>% 
    writeLines( "blah", .)
}

list.files(pattern = "^\\d")

## ------------------------------------------------------------------------
  write_punny_file <- function(name="not_a_clever_name.txt"){
    timediff <-
      as.numeric(Sys.time()) -
    as.numeric(file.info(name)$mtime)
    
    if( !file.exists(name) | timediff > 20 | is.na(timediff > 20) ){
      writeLines("content", name)
      return(TRUE)
    }else{
      return(FALSE)
    }
  }

write_punny_file()
list.files(pattern = "^not_")

Sys.time()
file.info("not_a_clever_name.txt")$mtime

## ------------------------------------------------------------------------
for( i in 1:10){
  write(
    as.character(Sys.time()), 
    "mylogfile", append = TRUE)  
  Sys.sleep(0.3)
}

readLines("mylogfile")

## ---- eval=FALSE---------------------------------------------------------
##   for( i in 1:3){
##     for( j in 1:3){
##       cat("- i=", i, "j=", j, "\n")
##     }
##   }

## ------------------------------------------------------------------------
var1 <- letters[1:3]
var2 <- LETTERS[7:9]
df  <- data.frame(var1, var2)

  for( i in seq_along(var1)){
    for( j in seq_along(var2)){
      txt   <- paste("var1 =", df$var1[i], "\nvar2 =", df$var2[j])
      fname <- paste0(df$var1[i], "_", df$var2[j], ".txt")
      writeLines(txt, fname)
    }
  }

list.files(pattern = "txt$")

readLines("a_G.txt")
readLines("c_I.txt")

## ------------------------------------------------------------------------
df_expanded <- expand.grid(df)
df_expanded

df_expanded$fnames <-
  df_expanded %>% 
  apply(1, paste0, collapse="_") %>% 
  paste0(".txt")

for( i in seq_along(df_expanded[,1]) ){
  with(
    df_expanded,
    writeLines(
      paste(".var1 =", var1[i], "\n.var2 =", var2[i]),
      fnames[i],
    )
  )
}

list.files(pattern = "txt$")

readLines("a_G.txt")
readLines("c_I.txt")

## ------------------------------------------------------------------------
list.files()

## ------------------------------------------------------------------------
list.files(pattern = "^\\d")

list.files(pattern = "txt$")

list.files(pattern = "manipulation")

list.files(pattern = "manipulation", full.names = TRUE, recursive = TRUE)

## ------------------------------------------------------------------------
fnames <- list.files(full.names = TRUE, recursive = TRUE)

info   <- file.info(fnames)
mtime  <- info$mtime

newest <- fnames[order(mtime, decreasing = TRUE)]

texts  <- lapply(newest, readLines, warn=FALSE)

