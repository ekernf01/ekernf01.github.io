library(ggplot2)
library(lubridate)
library(magrittr)
bge =
  rbind(
    read.csv("~/Dropbox/blog posts/ekernf01.github.io/files/bgec_electric_interval_data_Service 1_2021-01-28_to_2022-01-28.csv"),
    read.csv("~/Dropbox/blog posts/ekernf01.github.io/files/bgec_electric_interval_data_Service 1_2020-08-27_to_2021-01-28.csv")
  )
dim(bge)
head(bge)
bge$DATE %<>% lubridate::as_date()
bge$COST %<>% gsub("\\$", "", .) %>% as.numeric
ggplot(bge) + 
  geom_bar(aes(x = DATE, y = USAGE), stat = "identity") +
  ggtitle("Our insulation sucks") + 
  ylab("Usage (kWh)")
