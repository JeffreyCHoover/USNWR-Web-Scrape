url_pull <- function(stem)
{
  usnwr <- read_html(stem) %>%
    html_nodes("#search-application-results-view .block-tighter a") %>%
    html_attr("href") %>%
    as.character()
  
  return(usnwr)
}

each_school <- function(lst) 
{
  lst2 <- as.list(NULL)
  for(i in 1:20)
  {
    lst2[[i]] <- map(lst[[i]], scrape_data)
  }
  print("done")
  return(lst2)
}

scrape_data <- function(url)
{
  all_data <- matrix(NA, ncol = 3, nrow = 178)
  data <- read_html(paste0(url, sep = "#", "applying"))
  
  
  # fix this block... not pulling all categoies and data correctly
  tables <- data %>%
    html_nodes(".block-flush.flex-row span") %>%
    html_text() %>%
    as.character() %>%
    str_trim() %>%
    as.data.frame() %>%
    rename(datapull = colnames(.)[1]) %>%
    filter(row_number() %% 2 != 0)
  
  tables$datapull <- droplevels(tables$datapull)
  
  i <- 1
  while(i < 356)
  {
    all_data[(i + 1)/2, 1] <- as.character(tables$datapull[i])
    all_data[i - (i - 1)/2, 2] <- as.character(tables$datapull[i+1])
    all_data[(i + 1)/2, 3] <- str_sub(url, 51, -20)
    i <- i + 2
  }
  
  all_data <- as.data.frame(all_data) %>%
    rename(category = V1, 
           score = V2,
           school = V3)
  
  return(as.list(all_data))
}