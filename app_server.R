---
  title: "Carbon Emission Effects Globally"
author: "Sabrina Jahed"
date: '2022-11-28'
output: html_document
---
library(tidyverse)
  
get_data <- function(num_records = -1) {
  fname <- "../../data/owid-co2-data.csv"
  df <- read.csv(fname, nrows = num_records)
  return(df)
}

carbon_emissions <- get_data()

# find countries with highest emissions  
# in the most recent year (2021 for dataset)
highest_em <- carbon_emissions %>% 
  select(country, year, iso_code, cumulative_co2) %>% 
  filter(year == max(year)) %>% 
  group_by(iso_code) %>% 
  filter(cumulative_co2 == max(cumulative_co2, na.rm = TRUE)) %>% 
  arrange(desc(cumulative_co2))
