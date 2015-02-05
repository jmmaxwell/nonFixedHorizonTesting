library(shiny)
library(shinydashboard)


ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      
      box(
        title = "Test Inputs",
        numericInput("tao", label = h3("Effect Prior's Variance"), value = 1),
        numericInput("test.sample.size", label = h3("Number of Test Group Observations"), value = 100),
        numericInput("control.sample.size", label = h3("Number of Control Group Observations"), value = 100),
        numericInput("test.conversions", label = h3("Number of Test Group Conversions"), value = 10),
        numericInput("control.conversions", label = h3("Number of Control Group Conversions"), value = 10)
      ),
      
      box(
        tableOutput("values")
        )
    )
  )
)