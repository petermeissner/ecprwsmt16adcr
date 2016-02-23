## ---- tidy=FALSE, tidy.opts=list(blank=FALSE, width.cutoff=41)-----------
# packages from CRAN
p_needed     <- c( 
  "RCurl", "XML", "xml2", "httpuv", "stringr", 
  "jsonlite", "httr", "rvest", "devtools", 
  "ggmap", "wikipediatrend", "d3Network", 
  "RSelenium", "sp"
  )

packages     <- rownames(installed.packages())
p_to_install <- p_needed[ !(p_needed %in% packages ) ]
if ( length(p_to_install) > 0 ) {
  install.packages( 
    p_to_install, 
    repos="https://cran.rstudio.com/" 
  )
}

## ---- tidy=FALSE, tidy.opts=list(blank=FALSE, width.cutoff=41)-----------
# packages from GitHub
p_to_install <- !("twitteR" %in% packages )
if ( p_to_install > 0 ){ 
  devtools::install_github("geoffjentry/twitteR")
}

## ---- eval=FALSE---------------------------------------------------------
## ` ` `{r, ...}
##       dings <- 1+1
##       dings
## ` ` `

