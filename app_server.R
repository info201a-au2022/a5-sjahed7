# ----- Carbon Emissions Produced Globally -----
# author: Sabrina Jahed
# date: 2022-11-28
# ------
library(tidyverse)
library(shiny)
library(plotly)
library(scales)

source("app_ui.R")

server <- function(input, output) {
  output$highestCountryEm <- renderText(highest_country_em)
  output$highestEver <- renderText(highest_ever)
  output$highestEverName <- renderText(names(highest_ever))
  output$cumulCo2RankChn <- renderText(cumul_co2_rank_chn)
  output$cumulCapRankChn <- renderText(cumul_cap_rank_chn)

  # creating the data visualization plot
  output$visual <- renderPlotly({
    unit <- input$radioUnit
    if (is.null(input$checkCountry)) {
      g <- ggplot(data.frame()) +
        geom_point() +
        xlim(min_year, max_year)
      if (unit == "Cumulative CO2 Per Capita") {
        g <- g + scale_y_continuous(
          limits = c(min_cap, max_cap),
          labels = comma
        )
      } else {
        g <- g + scale_y_continuous(
          limits = c(min_co2, max_co2),
          labels = comma
        )
      }
    } else {
      plot_df <- visual_df %>%
        filter(cumul_or_cap == unit) %>%
        filter(Country %in% input$checkCountry)

      g <- ggplot(
        data = plot_df,
        mapping = aes(
          x = year, y = co2_val,
          group = Country,
          color = Country,
          text = paste0(
            "Country: ", Country,
            "\nYear: ", year,
            "\n", unit, ": ", co2_val
          )
        )
      ) +
        geom_line() +
        scale_y_continuous(labels = comma)
    }

    g <- g +
      labs(title = "Cumulative Carbon Emissions Over Time") +
      xlab("Year") + ylab(unit)

    return(ggplotly(g, tooltip = "text"))
  })
}
