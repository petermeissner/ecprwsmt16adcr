## ---- message=FALSE------------------------------------------------------
# packages
library(httr)
library(dplyr)
library(magrittr)
# credentials
cred_file <- "ecpr_wsmt_2016.credentials"
tmp       <- readLines(cred_file)
tmp

## ------------------------------------------------------------------------
key = stringr::str_replace(
  grep("twitter_api_key=", tmp, value = T), 
  "twitter_api_key=", "")

secret = stringr::str_replace(
  grep("twitter_api_secret=", tmp, value = T), 
  "twitter_api_secret=", "")

token = stringr::str_replace(
  grep("twitter_access_token=", tmp, value = T), 
  "twitter_access_token=", "")

token_secret = stringr::str_replace(
  grep("twitter_access_token_secret=", tmp, value = T), 
  "twitter_access_token_secret=", "")

## ---- cache=TRUE---------------------------------------------------------
twitter_token <-
  Token1.0$new(
    endpoint      = NULL,
    params        = list(as_header = TRUE),
    app           = oauth_app( "twitter", key, secret ),
    credentials   = list(
      oauth_token        = token,
      oauth_token_secret = token_secret
    )
  )

## ---- cache=TRUE---------------------------------------------------------
req <-
  GET(
    paste0(
      "https://api.twitter.com/1.1/search/tweets.json",
      "?q=%23wsmt16&result_type=recent&count=100"
    ),
    config(token = twitter_token)
  )

## ------------------------------------------------------------------------
tweets <-
  req %>%
  content("parsed") %>%
  extract2("statuses") %>%
  lapply(`[`, "text") %>%
  unlist(use.names=FALSE)

## ------------------------------------------------------------------------
tweets %>% grep("^RT ",. ,invert=TRUE, value=TRUE)

