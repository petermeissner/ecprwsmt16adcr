## ---- include=FALSE------------------------------------------------------
mp_http_post <-
  function(
    lang = c("de","en"),
    date = format(Sys.Date(), "%Y-%m-%d"),
    loc  = "mensa_giessberg"
  )
{
  url <- "https://www.max-manager.de/daten-extern/seezeit/html/inc/ajax-php_konnektor.inc.php"
  post_results <-
    httr::POST(
      url,
      body = list(
        func = "make_spl",
        loc  = loc,
        lang = lang[1],
        date = date
      )
    )
  return(post_results)
}  

## ---- eval=FALSE---------------------------------------------------------
## mp_http_post <-
##   function(
##     lang = c("de","en"),
##     date = format(Sys.Date(), "%Y-%m-%d"),
##     loc  = "mensa_giessberg"
##   )

## ---- eval=FALSE---------------------------------------------------------
## {
##     url <- "https://www.max-manager.de/daten-extern/seezeit/html/inc/ajax-php_konnektor.inc.php"
##     post_results <-
##       httr::POST(
##         url,
##         body = list(
##           func = "make_spl",
##           loc  = loc,
##           lang = lang[1],
##           date = date
##         )
##       )
##     return(post_results)
##   }

