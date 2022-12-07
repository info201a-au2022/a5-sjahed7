get_data <- function(num_records = -1) {
  fname <- "data/owid-co2-data.csv"
  df <- read.csv(fname, nrows = num_records)
  return(df)
}

carbon_emissions <- get_data()

# countries with highest cumulative emissions in the most recent year
highest_em <- carbon_emissions %>%
  select(year, country, iso_code, cumulative_co2, population) %>%
  filter(year == max(year)) %>%
  group_by(iso_code) %>%
  filter(cumulative_co2 == max(cumulative_co2, na.rm = TRUE)) %>%
  arrange(desc(cumulative_co2))

# ----- val 1 -----
# country with the highest cumulative co2 emissions
highest_country_em <- highest_em %>%
  filter(iso_code != "") %>%
  head(1) %>%
  pull(country)

# ----- val 2 -----
# the year and country of highest carbon emission at any point in time
highest_ever <- carbon_emissions %>%
  select(co2, iso_code, year) %>%
  filter(iso_code != "") %>%
  filter(co2 == max(co2, na.rm = TRUE)) %>%
  pull(year, iso_code)

# ----- val 3 -----
# knowing that highest_ever is china
# cumulative co2 rank for china
cumul_co2_rank_chn <- highest_em %>%
  filter(iso_code != "") %>%
  ungroup() %>%
  mutate(ranking = rank(desc(cumulative_co2))) %>%
  filter(iso_code == "CHN") %>%
  pull(ranking)

# cumulative co2 per capita rank for china
cumul_cap_rank_chn <- highest_em %>%
  filter(iso_code != "") %>%
  ungroup() %>%
  mutate(cumul_co2_percap = cumulative_co2 / population) %>%
  mutate(ranking = rank(desc(cumul_co2_percap))) %>%
  filter(iso_code == "CHN") %>%
  pull(ranking)

# since china's population is so high they're ranked lower per capita but
# they're emitting much more co2

# ----- Visualization -----
visual_countries <- highest_em %>%
  filter(iso_code != "") %>%
  head(5) %>%
  pull(iso_code)

# visualization dataframe
visual_df <- carbon_emissions %>%
  select(year, country, iso_code, cumulative_co2, population) %>%
  filter(iso_code %in% visual_countries) %>%
  filter(!is.na(cumulative_co2)) %>%
  filter(!is.na(population)) %>%
  mutate(`Cumulative CO2 Per Capita` = cumulative_co2 / population) %>%
  rename(
    `Cumulative CO2` = cumulative_co2,
    `Country` = country
  ) %>%
  select(-population) %>%
  pivot_longer(
    cols = starts_with("Cumulative"),
    names_to = "cumul_or_cap",
    values_to = "co2_val"
  )

# picking countries to display
ctry_choices <- visual_df %>%
  pull(Country) %>%
  unique()

# default empty chart when user deselects all countries
min_year <- visual_df %>%
  pull(year) %>%
  min(na.rm = TRUE)
max_year <- visual_df %>%
  pull(year) %>%
  max(na.rm = TRUE)
min_co2 <- visual_df %>%
  filter(cumul_or_cap == "Cumulative CO2") %>%
  pull(co2_val) %>%
  min(na.rm = TRUE)
max_co2 <- visual_df %>%
  filter(cumul_or_cap == "Cumulative CO2") %>%
  pull(co2_val) %>%
  max(na.rm = TRUE)
min_cap <- visual_df %>%
  filter(cumul_or_cap == "Cumulative CO2 Per Capita") %>%
  pull(co2_val) %>%
  min(na.rm = TRUE)
max_cap <- visual_df %>%
  filter(cumul_or_cap == "Cumulative CO2 Per Capita") %>%
  pull(co2_val) %>%
  max(na.rm = TRUE)

unit_choices <- visual_df %>%
  pull(cumul_or_cap) %>%
  unique()
