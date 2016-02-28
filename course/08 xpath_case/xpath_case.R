## ---- message=FALSE------------------------------------------------------
require(rvest)
require(stringr)

## ---- eval=1:2-----------------------------------------------------------
url <- 
"https://en.wikipedia.org/wiki/List_of_political_scientists"

browseURL(url)

## ------------------------------------------------------------------------
html   <- read_html(url)
ankers <- html_nodes(html, xpath="//a")
length(ankers)

## ------------------------------------------------------------------------
ankers[100:102]

## ------------------------------------------------------------------------
xml_path(ankers[100:102])

## ------------------------------------------------------------------------
ankers <- html_nodes(html, xpath="//ul/li/a[1]")
links  <- html_attr(ankers, "href")
# according to SelectorGagdget should be around
length(links) 

## ------------------------------------------------------------------------
links_iffer <- # subsetting links by position
  seq_along(links) >= 
    seq_along(links)[str_detect(links, "Abramowitz")]  & 
  seq_along(links) <=
    seq_along(links)[str_detect(links, "John_Zaller")] & 
  str_detect(links, "/wiki/")

links_index <- seq_along(links)[links_iffer]
links <- links[links_iffer]

length(links)

## ------------------------------------------------------------------------
names <- html_attr(ankers, "title")[links_index]
names <- str_replace(names, " \\(.*\\)", "")
# maybe needed - Windows e.g. depends on your locale: 
# Sys.getlocale()
# stringi::stri_enc_detect(paste(names, collapse = ""))
# names <- iconv(names, "utf8", "latin1")

## ------------------------------------------------------------------------
# loop preparation
baseurl <- "https://en.wikipedia.org"
HTML    <- list()
Fname   <- str_c("downloads/", basename(links), ".html")
dir.create("downloads", FALSE)
URL     <- str_c(baseurl, links)

## ------------------------------------------------------------------------
# loop
for ( i in seq_along(links) ){
  # url
  url <- URL[i]
  # fname
  fname <- Fname[i]
  # download
  if ( !file.exists(fname) ){
    download.file(url, fname)
    Sys.sleep(0.8)
  } 
  # read in files
  HTML[[i]] <- read_html(fname)
}

## ------------------------------------------------------------------------
# loop preparation
connections <- data.frame(from=NULL, to=NULL)

# loop
for ( i in seq_along(HTML))  {
  pslinks          <- html_attr(
                        html_nodes(HTML[[i]], xpath="//a"), 
                      "href")
  links_in_pslinks <- seq_along(links)[links %in% pslinks]
  links_in_pslinks <- links_in_pslinks[links_in_pslinks!=i]
  connections      <- rbind(
                connections, 
                data.frame(
                  from=rep(i, length(links_in_pslinks)), 
                  to=links_in_pslinks
                  ) 
                      )  
}

## ------------------------------------------------------------------------
# results
names(connections) <- 
  c("from", "to")
head(connections)

## ------------------------------------------------------------------------
# make symmetrical 
connections <- 
  rbind(
    connections, 
    data.frame(
      from=connections$to,
      to=connections$from
    )
 )

## ------------------------------------------------------------------------
require(d3Network)
d3SimpleNetwork( connections, 
                 width = 1000, 
                 height = 900, 
                 file="connections.html")
# browseURL("connections.html")

## ---- tidy=TRUE----------------------------------------------------------
d3ForceNetwork(Links = connections, Nodes = data.frame(name=names),
               Source = "from", Target = "to", 
               opacity = 0.9, zoom=T,  width=1000, height=900, 
               file="connections2.html")
# browseURL("connections2.html")

