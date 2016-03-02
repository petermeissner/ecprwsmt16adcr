## ------------------------------------------------------------------------
library(stringr)
grepl("^a.*d$", "abc\nefgd")
str_detect("abc\nefgd", "^a.*d$")
str_detect("abc\nefgd", regex("a.*d",  dotall=TRUE))

