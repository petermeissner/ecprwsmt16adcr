## ---- eval=FALSE---------------------------------------------------------
## url <- "http://ajps.org/list-of-reviewers/"
## browseURL(url)

## ---- message=FALSE------------------------------------------------------
# packages needed
require(rvest)
require(stringr)

## ---- cache=TRUE---------------------------------------------------------
# url with list of reviews
url <- "http://ajps.org/list-of-reviewers/"

# get page
content <- read_html(url)

# get anker (<a href=...>) nodes via xpath
ankers  <- html_nodes(content, xpath = "//a")

# get value of ankers' href attribute
hrefs   <- html_attr(ankers, "href", 
                     default="NO HREF IN HERE")

## ---- cache=TRUE---------------------------------------------------------
# filter links: should entail ... 
# 'review', four-digit number, 'pdf'
pdf <- hrefs[ str_detect(hrefs, "review.*\\d{4}.*pdf") ]
pdf

## ------------------------------------------------------------------------
# names for PDFs on disk
basename(pdf)
dirname(dirname(dirname(pdf)))
str_extract(pdf, "\\d{4}.pdf")

pdf_names <- str_extract(pdf, "\\d{4}.pdf")

## ---- eval=F-------------------------------------------------------------
## # download pdfs
## for(i in seq_along(pdf) ) {
##   download.file(pdf[i], pdf_names[i], mode="wb")
## }

## ------------------------------------------------------------------------
# WINDOWS: xpdf: http://www.foolabs.com/xpdf/download.html 
#   add install path to path variable / see: http://www.computerhope.com/issues/ch000549.htm
# Linux: sudo apt-get install poppler-utils
pdftotext <- function(fname){
  fname_txt <- str_replace(fname, ".pdf", ".txt")
  system2(command = "pdftotext", args = fname)
  return(fname_txt)
}

## ---- eval=FALSE---------------------------------------------------------
## # transform PDFs to text
## pdftotext(pdf_names[1])
## pdftotext(pdf_names[2])
## pdftotext(pdf_names[3])
## pdftotext(pdf_names[4])

## ---- warning=FALSE------------------------------------------------------
# laod text of PDF
text1 <- readLines("2013.txt", warn=FALSE)

## ------------------------------------------------------------------------
substring(text1, 1, 60)[6:14]

## ------------------------------------------------------------------------
text1_tmp <- 
  text1 %>% 
  str_replace_all("[!\f]"," ") %>%   # drop form feed
  str_replace_all("\\]"," ") %>%     # drop ]
  str_replace_all("\\(|\\)", "") %>% # drop ( )
  str_replace(" ,", ",") %>%         # correct space
  str_replace_all("  ", " ") %>%     # correct space
  str_trim()                         # correct space

text1_tmp <- 
  text1_tmp[text1_tmp != ""] # drop empty lines

text1_tmp <- 
  text1_tmp[-c(1:5 )]        # drop non data

## ------------------------------------------------------------------------
text1_tmp[1:10]

## ------------------------------------------------------------------------
length(grep("Konstanz", text1_tmp))
length(grep("Harvard", text1_tmp))
length(grep("Berlin", text1_tmp))
length(grep("Bamberg", text1_tmp))
length(grep("UCLA", text1_tmp))

## ------------------------------------------------------------------------
names <- 
  text1_tmp %>% 
  str_extract("^.*?,") %>% 
  str_replace_all("  |,", " ") %>% 
  str_trim( )
sample(names, 10)

## ------------------------------------------------------------------------
institution <-
  text1_tmp %>% 
  str_extract(",.*\\d") %>% 
  str_replace_all("^ ,|^,|\\d$","") %>% 
  str_trim()
sample(institution, 7)

## ------------------------------------------------------------------------
reviews <-      
  text1_tmp %>% 
  str_extract("\\d+") %>% 
  as.numeric 
table(reviews)

## ------------------------------------------------------------------------
data.frame(n=reviews, names, institution)[reviews > 3, ]

## ------------------------------------------------------------------------
revdat <- data.frame(
  reviews, 
  names, 
  institution, 
  stringsAsFactors = FALSE
)
save(revdat, file = "revdat.Rdata")

## ---- message=FALSE------------------------------------------------------
require(ggmap)
# geocoding takes a while -> save results
# 2500 requests allowed per day
if ( !file.exists("scenario1_inst_geocoded_pos.rdata")){
  pos <- geocode(institution)
  geocodeQueryCheck() 
  save(pos, file="scenario1_inst_geocoded_pos.rdata")
} else {
  load("scenario1_inst_geocoded_pos.rdata")
}

## ------------------------------------------------------------------------
mapWorld <- borders("world")
map <-   
  ggplot() + 
  mapWorld + 
  geom_point(aes(x=pos$lon, y=pos$lat) ,
             color="#F54B1A90", size=3 ,
             na.rm=T) + 
  theme_bw() + 
  coord_map(xlim=c(-180, 180), ylim=c(-60,70))

## ------------------------------------------------------------------------
map # ajps 2013 reviewers worldwide

