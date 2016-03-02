## ------------------------------------------------------------------------
rawToBits(as.raw(62:66)) # as bits
as.raw(62:66) # bytes as hexa-decimal
as.numeric(as.raw(62:66)) # as numbers
rawToChar(as.raw(62:66)) # bytes as chararcters

## ------------------------------------------------------------------------
text           <- rawToChar(as.raw(228))
Encoding(text) <- "UTF-8" 
text
Encoding(text) <- "latin1" 
text

## ------------------------------------------------------------------------
text <- "ä"
charToRaw(text)
Encoding(text) <- "latin1"
text

## ------------------------------------------------------------------------
Sys.getlocale()

# if yor locale is something other than UTF-8, 
# switch 'latin1' and 'UTF-8' and you shall be good to go

## ------------------------------------------------------------------------
text <- "Små grodorna, små grodorna är lustiga att se."
Encoding(text) <- "UTF-8"
text

## ------------------------------------------------------------------------
text <- "Små grodorna, små grodorna är lustiga att se."
Encoding(text) <- "latin1"
text

## ------------------------------------------------------------------------
text <- "Små grodorna, små grodorna är lustiga att se."
text <- iconv(text, "UTF-8", "latin1")
Encoding(text)
text

## ------------------------------------------------------------------------
text <- "Små grodorna, små grodorna är lustiga att se."
text <- iconv(text, "UTF-8", "latin1")
writeLines(text, "text_latin1.txt", useBytes = TRUE)
text <- readLines("text_latin1.txt")
Encoding(text)
text
Encoding(text) <- "latin1"
text

