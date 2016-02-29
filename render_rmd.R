#!/usr/bin/env Rscript

# necessary package
library(stringr)

# extracting argument 
file     <- commandArgs()[grep("--args", commandArgs())+1]

# worker-function
render_rmd <- function(file, try=FALSE){
	if( file.info(file)$isdir ){
		lapply(
			paste0(file,"/", list.files(file, pattern=".Rmd$", recursive=TRUE),sep=""),
			render_rmd, try=try
		)
	}else{
		file_pdf <- str_replace(file, ".Rmd", ".pdf")
		file_r   <- str_replace(file, ".Rmd", ".R")
		if( try==TRUE ){
		  try(rmarkdown::render(file, "all", encoding="UTF-8") )
		  try(		file.copy(file_pdf, basename(file_pdf))      )
		  try(		knitr::purl(input=file, output=file_r)       )
		}else{
		  rmarkdown::render(file, "all", encoding="UTF-8") 
		  		file.copy(file_pdf, basename(file_pdf))      
		  		knitr::purl(input=file, output=file_r)       
		}
	}
}

# doing-duty-to-do
if( length(file) == 0 ){
		render_rmd(".", try=FALSE)
}else{
	render_rmd(file)
}


