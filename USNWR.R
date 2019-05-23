library(rvest)
library(tidyverse)
library(here)
source(here("USNWR functions.R"))

stem <- "https://www.usnews.com/education/online-education/education/rankings?_page="

webpages <- as.list(NULL)

for(i in 1:15)
{
  webpages[[i]] <- paste0(stem, i, sep = "")
}

urls <- map(webpages, url_pull)

saveRDS(urls, file = paste0(here(), sep = "/", "USNWR url list.RDS"))

data <- map(urls, each_school)
  
data2 <- as.data.frame(NULL)

for(i in 1:15)
{
  for(j in 1:20)
  {
    data2 <- data2 %>%
      bind_rows(data[[i]][[j]][[1]])
  }
}

data2 <- data2 %>%
  distinct() %>%
  select(school, category, score) %>%
  filter(!is.na(category))

saveRDS(data2, file = paste0(here("USNWR School data.RDS")))

write_csv(data2, path = paste0(here("USNWR School Data.csv")))
