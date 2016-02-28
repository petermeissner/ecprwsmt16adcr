## ----set-options, message=FALSE, error=FALSE, include=FALSE--------------
options(width = 60)
REDO <- FALSE
library(RSelenium, warn.conflicts = FALSE, quietly=TRUE)

## ----isis, include=FALSE, fig.path="fig/", cache=TRUE--------------------
library(wikipediatrend)
wp_set_cache_file( file = "isis.csv" )
titles <- wp_linked_pages("Islamic_State_of_Iraq_and_the_Levant", "en")
titles <- titles[titles$lang %in% c("en", "de", "ar"),]
titles <- 
  rbind(
    titles, 
    data.frame(
      page="Islamic_State_of_Iraq_and_the_Levant", 
      lang="en", 
      title="Islamic_State_of_Iraq_and_the_Levant"
    )
  )
page_views <- 
  wp_trend(
    page = titles$page, 
    lang = titles$lang,
    from = "2014-08-01"
  )

library(ggplot2)

for(i in unique(page_views$lang) ){
  iffer <- page_views$lang==i
  page_views[iffer, ]$count <- scale(page_views[iffer, ]$count)
}

ggplot(page_views, aes(x=date, y=count, group=title, color=lang)) + 
  geom_line(size=1.2, alpha=0.5) + 
  ylab("standardized count\n(by lang: m=0, var=1)") +
  theme_bw() + 
  scale_colour_brewer(palette="Set1") + 
  guides(colour = guide_legend(override.aes = list(alpha = 1)))


