## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ------------------------------------------------------------------------
readLines("text1.txt")
readLines("text2.txt")

## ------------------------------------------------------------------------
readLines("text1.txt", encoding = "UTF-8")
readLines("text2.txt", encoding = "latin1")

## ------------------------------------------------------------------------
text1 <- readLines("text1.txt")
Encoding(text1) <- "UTF-8"
text1

text2 <- readLines("text2.txt")
Encoding(text2) <- "latin1"
text2

## ------------------------------------------------------------------------
text1 <- readLines("text1.txt")
text1 <- iconv(text1, "UTF-8", "UTF-8")
text1

text2 <- readLines("text2.txt")
text2 <- iconv(text2, "latin1", "UTF-8")
text2

## ------------------------------------------------------------------------
library(stringi)

text1 <- readLines("text1.txt")
stri_enc_detect(text1)
stri_enc_detect2(text1)

text2 <- readLines("text2.txt")
stri_enc_detect(text2)
stri_enc_detect2(text2)

## ------------------------------------------------------------------------
name <- "\u0055\u0064\u006f"
name

## ------------------------------------------------------------------------
readLines("17814-0.txt", encoding = "UTF-8")[1:10]

## ------------------------------------------------------------------------
library(stringr)
text <- readLines("pg345.txt")

sum(str_count(text, "[bB]lood"))
sum(str_count(text, "\\b[bB]lood\\b"))

grep("\\b[bB]lood\\b", text)

hist(grep("\\b[bB]lood\\b", text),n=100000, main="Blood in Dracula", xlab="line number")
box()

hist(grep("\\b[bB]lood\\b|\\b[fF]ear\\b", text),n=100000, main="Blood and Fear in Dracula", xlab="line number")
box()


## ------------------------------------------------------------------------
txt <- readLines("pg11.txt")
txt[1:10]

grep("^Title", txt, value = TRUE)
textfiles <- c("17814-0.txt", "pg11.txt", "pg1661.txt", "pg174.txt", "pg2600.txt", "pg345.txt")
TXT <- list()
for( i in seq_along(textfiles) ){
  TXT[[i]] <- readLines(textfiles[i])
}

grep("^Title", TXT[[1]], value = TRUE)[1]

get_gutenberg_title <- function(fname){
  txt <- readLines(fname)
  tmp <- grep("^Title", txt, value = TRUE)[1]  
  str_replace(tmp, "^Title: ", "")
}

get_gutenberg_author <- function(fname){
  txt <- readLines(fname)
  tmp <- grep("by", txt, value = TRUE)[1]
  str_replace(tmp, "^.*by ","")
}

get_gutenberg_posting_date <- function(fname){
  txt <- readLines(fname)
  tmp <- grep("posting date|release date", txt, value = TRUE, ignore.case = TRUE)[1]
  str_replace_all(tmp, "^.*: | \\[.*$","")
}

lapply(textfiles, get_gutenberg_title)
lapply(textfiles, get_gutenberg_author)
lapply(textfiles, get_gutenberg_posting_date)

## ------------------------------------------------------------------------
txt <- readLines("2012.txt", warn = FALSE)[-c(1:52)]
txt <- paste0(txt, collapse="") 

txt <-
  str_split(txt, "\\)") %>% 
  unlist()

txt <- 
  txt %>% 
  str_replace_all("\t|  \f"," ") %>% 
  str_trim() %>% 
  str_replace_all("  ","") 

name <- 
  txt %>% 
  str_extract("^.*\\.") %>% 
  str_replace("\\.","")

reviews <- 
  txt %>% 
  str_extract("\\d") %>% 
  as.numeric()

institution <- 
  txt %>% 
  str_extract("\\..*\\(") %>% 
  str_replace_all("\\.|\\(","") %>% 
  str_trim()

