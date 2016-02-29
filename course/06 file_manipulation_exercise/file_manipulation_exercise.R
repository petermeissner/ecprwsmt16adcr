## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ------------------------------------------------------------------------
  write_punny_file <- function(name="no_a_clever_name.txt"){
    writeLines("content", name)
  }

## ---- eval=FALSE---------------------------------------------------------
##   for( i in 1:3){
##     for( j in 1:3){
##       cat("- i=", i, "j=", j, "\n")
##     }
##   }

