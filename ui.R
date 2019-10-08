library(shiny)
library(shinydashboard)
library(shinyjs)

#rsconnect::deployApp("/home/andr31/R/github/Stat_Calc")

dashboardPage(
  dashboardHeader(title = "Statistical Sampling"),
  dashboardSidebar(
    numericInput("pop", "Population Size", value=10000),   
    sliderInput("bad", "% Expected Proportion (Prior)",
                min = 0, max = 50, value = 10, step = 5
    ),
    sliderInput("confidence", "% Level of Confidence",
                min = 90, max = 99, value = 90, step = 1
    ),
    sliderInput("margin", "% Margin of Error",
                min = 1, max = 5, value = 2, step = 1
    )
  ),
  dashboardBody(
    column(12,"*Calculator for Discrete Variables"),
              fluidRow(
                column(8,h3(HTML("<b>Required Sample Size:</b>"),textOutput("text")))
              ),
              fluidRow(
                box(
                  width = 12, status = "info", solidHeader = TRUE,
                  title = "Proportion",
                  plotOutput("propPlot", width = "100%", height = 500)
                )
                ),
              fluidRow(
                box(
                  width = 6, status = "info",
                  title = "Confidence",
                  plotOutput("confPlot")
                ),
                box(
                  width = 6, status = "info",
                  title = "Precision",
                  plotOutput("margPlot")
                )
                
              )
      
  )
)



