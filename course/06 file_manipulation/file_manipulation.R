## ---- include=FALSE------------------------------------------------------
options(width = 40)

## ---- include=FALSE------------------------------------------------------
file.remove("testfile.txt")

## ------------------------------------------------------------------------
fname <- "testfile.txt"

if( !file.exists(fname)  ) {
  writeLines( as.character(Sys.time()), fname )
}

file.mtime(fname)
readLines(fname)

## ------------------------------------------------------------------------

for( i in 1:3 ){
  atime <- substr(as.character(Sys.time()),12,20)
  mtime <- substr(as.character(file.mtime(fname)),12,20)
  write(
    paste0(
      " append : ", atime, "   mtime : ", mtime, 
      collapse = ""
    ), 
    fname, 
    append = TRUE
  )
  Sys.sleep(1)
}

## ------------------------------------------------------------------------
file.mtime(fname)
readLines(fname)

## ------------------------------------------------------------------------
url      <- "http://www.r-datacollection.com/materials/http/abunchofasciis/index.html"
destfile <- basename(url)
download.file(url = url, destfile = destfile)

## ------------------------------------------------------------------------
destfile
file.exists(destfile)
readLines(destfile, warn=FALSE)

## ------------------------------------------------------------------------
for ( i in 1:10) {
  content <- paste(sample(letters,10),collapse = "")
  fname   <- 
    paste(
      "f_", 
      Sys.time(), " ", 
      stringr::str_pad(i, 3, "left", 0),  
      ".test",
      collapse = "", sep=""
    )
  writeLines(content, fname)
}

## ------------------------------------------------------------------------
list.files(pattern = "\\d.test$")

## ------------------------------------------------------------------------
filelist <- list.files(pattern = ".txt$|html$|test$")
zip(zipfile = "archive.zip", files = filelist)
file.remove(filelist[file.exists(filelist)])
list.files()

