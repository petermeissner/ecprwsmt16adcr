load("revdat.Rdata")

inst_names <- unique(revdat$institution)


library(httr)
library(rvest)

url1  <- "http://www.geonames.org/search.html?q="
url2  <- "&username=petermeissner"
query1 <- URLencode("University of Konstanz")
query2 <- URLencode("Konstanz")
res1 <- read_html(paste0(url1, query1, url2))
res2 <- read_html(paste0(url1, query2, url2))






## gen boundary data fro Germany

url   <- 
  "http://biogeo.ucdavis.edu/data/gadm2/R/DEU_adm1.RData"
fname <- basename(url)
if ( !file.exists(fname) ){
  download.file(url, fname, mode="wb")
}
load(fname)


## produce map for Germany

map2 <- 
  ggplot(data=gadm, aes(x=long, y=lat)) +
  geom_polygon(data = gadm, aes(group=group)) + 
  geom_path(color="white",  aes(group=group)) + 
  geom_point(data = pos, 
             aes(x = lon, y = lat), 
             colour = "#F54B1A70", size=5, na.rm=T) +
  coord_map(xlim=c(5, 16), ylim=c(47,55.5)) +
  theme_bw()




map2 # ajps 2013 reviewers in Germany




# use search functionality here
# http://onlinelibrary.wiley.com/advanced/search/results?start=1
# to capture data on publications of authors in AJPS
s



