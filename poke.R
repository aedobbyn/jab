library(rtweet)
library(twilio)
library(tidyverse)

handle <- "turbovax"

tweets <- 
  rtweet::get_timeline(
    handle
  ) 

exclude_boroughs <- 
  c("Bronx", "Manhattan", "Queens", "Staten Island", "S\\.I\\.") %>% 
  str_c(".* only", sep = " ") %>% 
  str_c(collapse = "|")

tweets %>% 
  filter(
    str_detect(text, "^\\[") &
      !str_detect(text, exclude_boroughs)
  ) %>% 
  select(text, created_at) %>% 
  separate(
    text,
    into = c("location", "times", "site"),
    sep = "\\n\\n"
  ) %>% 
  mutate(
    n_appts = 
      location %>% 
      str_extract("[0-9]+ appts") %>% 
      str_remove("appts") %>% 
      str_squish() %>% 
      as.integer(),
    location = location %>% str_remove(":.*")
  ) %>% 
  mutate_all(str_squish)


