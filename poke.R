library(rtweet)
library(gmailr)
library(tidyverse)

handle <- "turbovax"
phone <- Sys.getenv("PHONE")

tweets <- 
  rtweet::get_timeline(
    handle
  ) 

exclude_boroughs <- 
  c("Bronx", "Manhattan", "Queens", "Staten Island", "S\\.I\\.") %>% 
  str_c(".* only", sep = " ") %>% 
  str_c(collapse = "|")

appts <- 
  tweets %>% 
  filter(
    str_detect(text, "^\\[") &
      !str_detect(text, exclude_boroughs)
  ) %>% 
  select(text, created_at) %>% 
  separate(
    text,
    into = c("location", "times", "url"),
    sep = "\\n\\n"
  ) %>% 
  transmute(
    date = str_remove_all(times, "\\–.*"),
    n_appts = 
      location %>% 
      str_extract("[0-9]+ appts") %>% 
      str_remove("appts") %>% 
      str_squish() %>% 
      as.integer(),
    location = location %>% str_remove(":.*"),
    url
  ) %>% 
  mutate_all(str_squish)






