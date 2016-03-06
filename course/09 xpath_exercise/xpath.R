## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ------------------------------------------------------------------------
library(magrittr)
library(xml2)
ls(package:xml2)

if( !file.exists("myxml.xml") ){
  url <- "http://www.r-datacollection.com/materials/ch-4-xpath/potus/potus.xml"
  download.file(url, "myxml.xml")
}

xml <- read_xml("myxml.xml")

## ---- eval=FALSE---------------------------------------------------------
## browseURL(url)

## ------------------------------------------------------------------------
xml_length(xml)

## ------------------------------------------------------------------------
cat(xml_text(xml))

## ------------------------------------------------------------------------
xml_structure(xml)

## ------------------------------------------------------------------------
xml_find_all(xml, xpath = "//religion")

## ------------------------------------------------------------------------
religion <- xml_find_all(xml, "religion")
religion

## ------------------------------------------------------------------------
religion %>% 
  xml_text() %>% 
  table() %>% 
  sort(TRUE) %>% 
  as.data.frame()

## ------------------------------------------------------------------------
xml %>% 
  xml_find_one(xpath="//president[1]")

## ------------------------------------------------------------------------
xml %>% 
  xml_find_all(xpath="//president[position()>40]")

## ------------------------------------------------------------------------
xml %>% 
  xml_find_all(xpath="//president[contains(./name, 'Pierce') or contains(./name, 'Garfield') or contains(./name, 'Taylor')]")

## ------------------------------------------------------------------------
xml %>% 
  xml_find_all("occupation") %>% 
  xml_text() %>% 
  table() %>% 
  sort(TRUE) %>% 
  as.data.frame()

## ------------------------------------------------------------------------
tagnames <- 
  xml %>% 
  xml_find_all(xpath="/*/*/*") %>% 
  xml_name() %>% 
  unique()

df <- data.frame(NA)
for( tag in tagnames ){
    tmp <- 
      xml %>% 
      xml_find_all(paste0("//",tag)) %>%
      xml_text()
  df <- data.frame(df, tmp)
}
df <- df[, -1]
names(df) <- tagnames

df


