library(shiny)
library(shinydashboard)


dashboardPage(
  dashboardHeader(title = "Statistical Sampling"),
  dashboardSidebar(
    numericInput("pop", "Population Size", value=10000),    
    sliderInput("confidence", "% Level of Confidence",
                min = 90, max = 99, value = 90, step = 1
    ),
    sliderInput("margin", "% Margin of Error",
                min = 1, max = 5, value = 2, step = 1
    ),
    sliderInput("bad", "% Expected Proportion (Prior)",
                min = 0, max = 50, value = 10, step = 5
    )
  ),
  dashboardBody(
    column(12,"Calculator for Discrete Variables"),
              fluidRow(
                valueBoxOutput("rate"),
                valueBoxOutput("count"),
                valueBoxOutput("users")
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
                  title = "Error Margin",
                  plotOutput("margPlot")
                )
                
              )
      
  )
)



