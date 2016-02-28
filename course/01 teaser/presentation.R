## ----set-options, message=FALSE, error=FALSE, include=FALSE--------------
options(width = 60)
REDO <- FALSE
library(RSelenium, warn.conflicts = FALSE, quietly=TRUE)

## ----dplyr and magrittr, warning=FALSE, message=FALSE--------------------
library(dplyr)
library(magrittr)

## ----get text worker, include=FALSE--------------------------------------
fname_temp <- "cache/base64enc_NEWS.Rdata"
if ( !file.exists(fname_temp) | REDO == TRUE) {
  url <- 
  "http://cran.r-project.org/web/packages/base64enc/NEWS"
  news <- readLines(url) 
  save(news, file=fname_temp)
}else{
  load(fname_temp)
}

## ----get text shower, eval = FALSE---------------------------------------
## news <-
##   "http://cran.r-project.org/web/packages/base64enc/NEWS"  %>%
##   readLines(url)

## ---- cache = !REDO, message=FALSE---------------------------------------
news %>% extract(1:10) %>%  cat(sep="\n")

## ----extract text--------------------------------------------------------
news  %>% 
  substring(7, 16)  %>% 
  grep("\\d{4}.\\d{1,2}.\\d{1,2}", ., value=T)

## ----extract text 2------------------------------------------------------
library(stringr)
news  %>% 
  str_extract("\\d{4}.\\d{1,2}.\\d{1,2}")

## ----get rpack_html html, include=FALSE----------------------------------
library(rvest)
fname_temp <- "cache/rpack_html_html.Rdata"
if ( !file.exists(fname_temp) | REDO == TRUE ) {
  url <- "http://cran.r-project.org/web/packages/"
  rpack_html <- paste0(readLines(url), collapse="\n")
  save(rpack_html, file = fname_temp)
}else{
  load(fname_temp)
}
rpack_html <- 
  html(rpack_html)

## ---- eval=FALSE---------------------------------------------------------
## library(rvest)
## 
## 
## rpack_html <-
##   "http://cran.r-project.org/web/packages" %>%
##   html()

## ---- cache = !REDO, message=FALSE---------------------------------------
rpack_html %>% class()

## ---- cache = !REDO, message=FALSE---------------------------------------
rpack_html %>% xml_structure(indent = 2)

## ---- cache = !REDO, message=FALSE---------------------------------------
rpack_html %>% html_text()  %>% cat()

## ---- cache = !REDO, message=FALSE---------------------------------------
rpack_html %>%  
  html_node(xpath="//p/a[contains(@href, 'views')]/..")

## ---- cache = !REDO, message=FALSE---------------------------------------
rpack_html %>% 
  html_nodes(xpath="//a") %>% 
  html_attr("href")  %>% 
  extract(1:6)

## ---- cache = !REDO, message=FALSE---------------------------------------
"http://cran.r-project.org/web/packages/multiplex/index.html"  %>% 
  html() %>% 
  html_table() %>% 
  extract2(1) %>% 
  filter(X1 %in% c("Version:", "Published:", "Author:"))

## ---- cache = !REDO, message=FALSE---------------------------------------
"https://api.github.com/users/daroczig/repos" %>% 
  readLines(warn=F) %>% 
  substring(1,300) %>% 
  str_wrap(60) %>% 
  cat()

## ---- cache = !REDO, message=FALSE---------------------------------------
library(jsonlite)  
fromJSON("https://api.github.com/users/daroczig/repos") %>% 
  select(language) %>% 
  table() %>% 
  sort(decreasing=TRUE)

## ---- cache = !REDO, message=FALSE---------------------------------------
library(rvest)
library(httr)

text    <- 
  "Quirky spud boys can jam after zapping five worthy Polysixes."

mainpage <- html("http://read-able.com") 

## ---- cache = !REDO, message=FALSE---------------------------------------
mainpage %>% 
  html_nodes(xpath="//form") %>% 
  html_attrs()

## ---- cache = !REDO, message=FALSE---------------------------------------
mainpage  %>% 
  html_nodes(
    xpath="//form[@method='post']//*[self::textarea or self::input]"
  ) 

## ---- cache = !REDO, message=FALSE---------------------------------------
response <- 
  POST(
    "http://read-able.com/check.php",
    body=list(directInput = text),
    encode="form"
  )

## ---- cache = !REDO, message=FALSE---------------------------------------
response  %>% 
  extract2("content") %>% 
  rawToChar() %>% 
  html() %>% 
  html_table() %>% 
  extract2(1)

## ---- include=FALSE------------------------------------------------------
new_day <- 
  Sys.Date()  %>% 
  grepl(list.files(pattern="spiegel")) %>% 
  any() %>% 
  !.

## ---- message=FALSE, eval=new_day----------------------------------------
library(RSelenium)
checkForServer() # make sure Selenium Server is installed
startServer() 
remDr <- remoteDriver() # defaults firefox
dings <- remDr$open(silent=T) # see: ?remoteDriver !!
remDr$navigate("https://spiegel.de")
remDr$screenshot(
  display   = F, 
  useViewer = F, 
  file      = paste0("spiegel_", Sys.Date(),".png")
)

## ---- include=FALSE,  message=FALSE, eval=new_day------------------------
library(png)
png_files   <- list.files(pattern="^spiegel_")
for ( i in seq_along(png_files))  {
  fname <- paste0("small_",png_files[i])
  writePNG(readPNG(png_files[i])[100:900,120:1050,], fname)
}

## ---- results='asis', echo=FALSE-----------------------------------------
png_files   <- list.files(pattern="^spiegel_")
cat(
  matrix(
    c(
      paste0("\\includegraphics[width=75px]{small_",png_files,"}"),
      rep("", 3 - length(png_files) %% 3)
    ),
    ncol = 3
  )  %>% 
  apply(1, paste, collapse=" ") %>% 
  paste("$$", ., "$$")
)

## ---- message=FALSE, warning=FALSE---------------------------------------
library(httpuv)
library(httr)

twitter_token <- oauth1.0_token(
  oauth_endpoints("twitter"), 
  twitter_app <- oauth_app(
    "petermeissneruser2015",
    key = "fP7WB5CcoZNLVQ2Xh8nAdFVAN",
    secret = "PQG1eEJZ65Mb8ANHz8q7yp4MqgAmiAVED90F4ZvQUSTHxiGzPT"
  )
)

## ------------------------------------------------------------------------
req <- 
  GET(
    paste0(
      "https://api.twitter.com/1.1/search/tweets.json",
      "?q=%23user2015&result_type=recent&count=100"
    ),
    config(token = twitter_token)
  )

## ---- eval=FALSE---------------------------------------------------------
## tweets <-
##   req  %>%
##   content("parsed")  %>%
##   extract2("statuses") %>%
##   lapply(`[`, "text") %>%
##   unlist(use.names=FALSE) %>%
##   subset(!grepl("^RT ", tweets)) %>%
##   extract(1:15)

## ----include=FALSE-------------------------------------------------------
tweets <- 
  req  %>% 
  content("parsed")  %>% 
  extract2("statuses") %>% 
  lapply(`[`, "text") %>% 
  unlist(use.names=FALSE) %>% 
  subset(!grepl("^RT ", .)) %>% 
  extract(1:15)

tweets <-
  tweets  %>% 
  str_replace_all("[^[:ascii:]]", "") 

## ------------------------------------------------------------------------
tweets %>% substr(1,60) %>% cat(sep="\n")

## ---- include=FALSE------------------------------------------------------
thanks <- function(){
  library(stringr)
  library(dplyr)
  library(magrittr)
  
  packages_used <- c("XML", "RCurl", "httr", "xml2", "rvest", "jsonlite", "RJSONIO", "rjson", "selectr", "urltools", "stringr", "RSelenium", "png", "httpuv", "igraph")
  load("cache/cran_package_tabdata.Rdata")
  
  thanks <- 
    package_data  %>% 
    filter(.$name %in% packages_used) %>% 
    .$Author %>% 
    str_replace_all("\\[.*?\\]|\\(.*?\\)|\r|\n|  |^ ", "") %>% 
    str_split(",|and") %>% 
    unlist %>% 
    str_replace_all("  |^ | $","") %>% 
    str_sort() 
  
  thanks %>% 
    str_c(collapse=", ") %>% 
    str_wrap(60) %>% 
    cat()
  
  invisible(thanks)
}

## ------------------------------------------------------------------------
thanks()

