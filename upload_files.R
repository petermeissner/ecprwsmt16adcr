#!/usr/bin/Rscript

message("\n... starting ... \n")

#### setting things up ========================================================

library(stringr)
library(markdown)
library(RCurl)

FORCE = FALSE

#### functions and helpers ====================================================
message("\n... def helpers ... \n")


uploadToServer <- function(files, dest){
  source(normalizePath(path.expand("~/.rftpcredentials"), winslash="/", mustWork=TRUE))
  for(i in seq_along(files)){
    ftpUpload(
      files[i], 
      paste0(
        "ftp://", ftp_user, ":", ftp_password, "@", ftp_server, "/", dest[i]
      )
    )
    message(paste("  ... ", files[i], " ... uploaded"))
  }
}

upload_folder <- function(folder){
  images <- list.files(folder, full.names=TRUE)
  for ( f in images ){
    uploadToServer( f, paste0("pmeissner/", f) )
  }
  TRUE
}

#### zipping course content ===================================================

try(file.remove("course/index.html"))

dlist <- list.dirs("course")[-1]
dlist <- dlist[unlist(lapply(str_extract_all(dlist, "/"), length))==1]

for( i in dlist){
  mtime   <- max(file.mtime(list.files(i, full.names=TRUE, recursive = TRUE)))
  zipname <- paste0(i,".zip")
  ziptime <- file.mtime(zipname)
  message(zipname)
  if ( is.na(ziptime) | ziptime < mtime | FORCE==TRUE) {
    message("... zipping to server ... \n")
    zip(i, i)
    message("... uploading to server ... \n")
    uploadToServer(zipname, paste0("pmeissner/ecprwsmt16/", basename(zipname)) )
  }else{
    message("... skipping ... \n")
  }
} 


html <- 
'<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width,initial-scale=1">
		<title>title</title>
		<link rel="stylesheet" href="style.css">
		<script src="script.js"></script>
	</head>
	<body>
		###page content###
	</body>
</html>'

content <- 
paste0(
  "<a href='", 
    list.files("course", pattern = "zip"), 
  "'>",
  "[",
  file.mtime(list.files("course", pattern = "zip", full.names = TRUE)),
  "] ... ",
  list.files("course", pattern = "zip"), 
  "</a><br>\n", collapse = ""
)

html <- str_replace(html, "###page content###", content)

writeLines(html, "course/index.html")
uploadToServer("course/index.html", paste0("pmeissner/ecprwsmt16/", basename("course/index.html")) )

















