#!/usr/bin/env Rscript

# necessary package
library(stringr)

# extracting argument 
file     <- commandArgs()[grep("--args", commandArgs())+1]

# worker-function
render_rmd <- function(file){
	if( file.info(file)$isdir ){
		lapply(
			paste0(file,"/", list.files(file, pattern=".Rmd$", recursive=TRUE),sep=""),
			render_rmd
		)
	}else{
		file_pdf <- str_replace(file, ".Rmd", ".pdf")
		file_r   <- str_replace(file, ".Rmd", ".R")
		rmarkdown::render(file, "all", encoding="UTF-8")
		file.copy(file_pdf, basename(file_pdf))
		knitr::purl(input=file, output=file_r)
	}
}

# doing-duty-to-do
if( length(file) == 0 ){
	stop("no file or folder supplied")
}else{
	render_rmd(file)
}


