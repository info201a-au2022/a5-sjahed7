library(shiny)

source("analysis.R")

intro_page <- fluidPage(
  headerPanel("Introduction"),
  p(strong("By: Sabrina Jahed")),
  p("For this project, I have decided to analyze the cumulative carbon
    emissions, the populations, the annual carbon emissions, and the years of
    their respective countries to get a better understanding of who is
    producing the most carbon and ultimately be able to address the issue of
    climate change with it."),
  p("I found the rates of carbon emissions per capita
    by taking the cumulative rate and dividing it by the population. I
    looked at cumulative carbon sums to know who the biggest mass-producers
    are. The annual carbon emissions is measured in million tonnes, and
    it excludes land-use change (meaning it does not account for emissions
    in traded goods). The year refers to the year of observation, whether it
    be for annual or cumulative calculations. The cumulative carbon data also
    excludes land-use change, and it is also measured in million tonnes."),
  h3("Value 1: Country with Highest Cumulative Carbon Emissions"),
  HTML(paste0(
    "The country with the highest current cumulative CO2 emissions is The ",
    textOutput("highestCountryEm", inline = TRUE), "."
  )),
  p(),
  h3("Value 2: The Year and Country of Highest Annual Carbon Emission"),
  HTML(paste0(
    "The year and country with the highest annual carbon emission at",
    " any point in time is in ",
    textOutput("highestEver", inline = TRUE),
    " in ",
    textOutput("highestEverName", inline = TRUE), "."
  )),
  p(),
  h3("Value 3: China's Cumulative vs. Cumulative Per Capita Rank"),
  HTML(paste0(
    "Knowing that the highest ever annual CO2 emission is from",
    " China, in terms of cumulative CO2, China is ranked ",
    textOutput("cumulCo2RankChn", inline = TRUE), "nd.",
    " This is in contrast to the cumulative CO2 per capita rank in",
    " China which is ranked ",
    textOutput("cumulCapRankChn", inline = TRUE), "st."
  )),
  h3(strong("Takeaways")),
  p("From this data visualization, we can see that China is the highest
    carbon-producing country; However, it is raked 91st in cumulative CO2
    rates per capita. This means that, for instance, Americans individually are
    producing more carbon emissions than China. We also know that China has
    a much higher population (over four-times as many people as America). Both
    of which contribute to the disparity in rank for China. This data helps
    us closer examine correlations between high-emitting countries and their
    economies, production rates, factories, etc. that contribute to carbon
    emissions.")
)

# visualization page
visual_page <- fluidPage(
  headerPanel("Visualization"),
  p("Here is an interactive data visualization. These are the top five
    carbon-producing countries and the amount of carbon emitted in each
    year. It also reveals the carbon-emission sum per capita of
    each country."),
  sidebarLayout(
    sidebarPanel(
      # widgets
      h3("Select Countries and Carbon Emission Type"),
      checkboxGroupInput("checkCountry",
        label = h4("Country"),
        choices = ctry_choices, selected = ctry_choices
      ),
      radioButtons("radioUnit",
        label = h4("CO2 Unit Type"),
        choices = unit_choices, selected = unit_choices[1]
      )
    ),
    # data visualization plot and captions
    mainPanel(
      plotlyOutput("visual"),
      p("Figure 01: Line graph that reveals the cumulative carbon emission
        of the top CO2 producing countries. Toggle to see it's cumulative
        carbon emissions per capita. Carbon emissions are measured in
        million tonnes."),
      p("This data visualization reveals that China has the highest cumulative
        production of carbon emission. It also reveals that all the other
        displayed countries produce a higher amount of carbon emissions per
        individual person.")
    )
  )
)

# main title and titles of tabs
ui <- navbarPage(
  "Carbon Emissions Produced Globally",
  tabPanel("Introduction", intro_page),
  tabPanel("Visualization", visual_page)
)
