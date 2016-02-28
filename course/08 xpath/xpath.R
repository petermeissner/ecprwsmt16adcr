## ---- message=FALSE------------------------------------------------------
require(rvest)
require(stringr)

## ------------------------------------------------------------------------
url <- 
"http://pmeissner.com/downloads/fortunes.html"
fname <- basename(url)

if(!file.exists(fname)){
  download.file(url, fname)
}

html <- read_html(fname)

## ------------------------------------------------------------------------
xml2::html_structure(html)

## ------------------------------------------------------------------------
x="/html/body/div[2]/h1"
html_nodes(html, xpath=x)

## ------------------------------------------------------------------------
html_nodes(html, xpath="//h1")

## ------------------------------------------------------------------------
html_nodes(html, xpath="//a/@href")

## ------------------------------------------------------------------------
html_nodes(html, xpath="//p/i/text()")

## ------------------------------------------------------------------------
html_nodes(html, xpath="//div[1]/p/i")

## ------------------------------------------------------------------------
html_nodes(html, xpath="//div")
html_nodes(html, xpath="//div[1]")
html_nodes(html, xpath="//div[1]/p/i/text()")

## ------------------------------------------------------------------------
html_nodes(html, xpath="//div[@date='October/2011']")
html_nodes(html, xpath="//div[contains(@date, 'October/2011')]")
html_nodes(html, xpath="//div[contains(.//a/@href, 'https')]")

## ------------------------------------------------------------------------
html_nodes(html, xpath="//a[contains(@href, 'https')]")
html_nodes(html, xpath="//a[contains(., 'homepage')]")

## ------------------------------------------------------------------------
html_nodes(html, xpath="//a")
html_nodes(html, xpath="//a/..")

## ------------------------------------------------------------------------
html_nodes(html, xpath="//*")

## ------------------------------------------------------------------------
html_nodes(html, xpath="//*/text()")

## ------------------------------------------------------------------------
html_nodes(html, xpath="//i | //b")

## ------------------------------------------------------------------------
html_nodes(html, xpath="//a/..")
html_nodes(html, xpath="//a/parent::*")
html_nodes(html, xpath="//a/parent::p")

## ------------------------------------------------------------------------
html_nodes(html, xpath="//p/i")
html_nodes(html, xpath="//p/child::*")
html_nodes(html, xpath="//p/child::i")

## ------------------------------------------------------------------------
html_nodes(html, xpath="//b/ancestor::*")
html_nodes(html, xpath="//b/ancestor::*/text()")

## ------------------------------------------------------------------------
html_nodes(html, xpath="//p/descendant::*")
html_nodes(html, xpath="//p/descendant::*/text()")

## ------------------------------------------------------------------------
html_nodes(html, xpath="//b/..")
html_nodes(html, xpath="//b/following-sibling::*")

## ------------------------------------------------------------------------
html_nodes(html, "p")
html_nodes(html, "b, i")

## ------------------------------------------------------------------------
html_nodes(html, ".pink")

## ------------------------------------------------------------------------
html_nodes(html, css = "#R_Inventor")
html_nodes(html, css = "[id='R_Inventor']")

## ------------------------------------------------------------------------
html_nodes(html, css = "[lang]")
html_nodes(html, css = "[href]")

## ------------------------------------------------------------------------
html_nodes(html, css = "[id=R_Inventor]") # equal
html_nodes(html, css = "[id^=R]")         # starts 
html_nodes(html, css = "[id$=r]")         # ends
html_nodes(html, css = "[id*=ven]")       # conatains

## ------------------------------------------------------------------------
html_nodes(html, css = "i")
html_nodes(html, css = "a i")

## ------------------------------------------------------------------------
html_nodes(html, css = "p > i")
html_nodes(html, css = "a > i")

## ------------------------------------------------------------------------
html_nodes(html, css = "p:first-of-type")

## ------------------------------------------------------------------------
html_nodes(html, css = "a:nth-child(1)")
html_nodes(html, css = "a:nth-child(2)")

## ------------------------------------------------------------------------
html_nodes(html, css = "a:nth-last-child(1)")
html_nodes(html, css = "a:nth-last-child(2)")

## ------------------------------------------------------------------------
html_nodes(html, css = "p:nth-of-type(1)")

