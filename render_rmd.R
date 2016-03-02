#!/usr/bin/env Rscript

# necessary package
library(stringr)

# extracting argument 
file     <- commandArgs()[grep("--args", commandArgs())+1]

# worker-function
render_rmd <- function(file, try=FALSE){
	if( length(file) == 0 ) return("nothing to do")
	if( length(file)  > 1 ){
		lapply(file,	render_rmd, try=try	)
	}else{
		file_r   <- str_replace(file, ".Rmd", ".R")
		if( try==TRUE ){
		  try(rmarkdown::render(file, "all", encoding="UTF-8") )
		  try(		knitr::purl(input=file, output=file_r)       )
		}else{
		  rmarkdown::render(file, "all", encoding="UTF-8") 
  		knitr::purl(input=file, output=file_r)       
		}
	}
}

# doing-duty-to-do
if( length(file) == 0 ){
    rmd <- list.files("course", pattern = ".Rmd$", recursive = TRUE, full.names = TRUE)
    pdf <- str_replace(rmd, "Rmd$", "pdf")
    rmd_mtime <- file.info(rmd)$mtime
    pdf_mtime <- file.info(pdf)$mtime
    iffer <- is.na(rmd_mtime > pdf_mtime) | rmd_mtime > pdf_mtime
		render_rmd(rmd[iffer], try=FALSE)
}else{
	render_rmd(file)
}


