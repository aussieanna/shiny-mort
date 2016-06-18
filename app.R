

library(shiny)
library(ggplot2)
library(wesanderson)
library(dplyr)

mortdata_rem <- read.csv("data/mort_data_remote.csv")
rem_p <- filter(mortdata_rem, SEX=="Persons") %>%
  filter(geography != "Australia (total)") %>%
  filter(geography != "Unknown/missing")

ui <- fluidPage(
  
  # Application title
  titlePanel("Mortality Over Regions and Time (MORT) books - Australia"),
  
  sidebarLayout(
    sidebarPanel(
      
      radioButtons(inputId = "measure", 
                  label = "Select a measure to display:",
                  list("Deaths" = "deaths", 
                       "Crude rate (per 100,000)" = "crude_rate", 
                       "Age standardised rate (per 100,000)" = "age_standardised_rate",
                       "Median age at death (years)" = "median_age",
                       "Premature deaths (%)" = "premature_deaths_percent")),
      helpText("Source: The Australian Institute of Health and Welfare"),
      tags$a(href="http://www.aihw.gov.au/deaths/mort/", "MORT books")
      ),
    
    mainPanel (plotOutput("chart"))
    )
)

server <- function(input, output){ 
  output$chart <- renderPlot({
  p <- ggplot(rem_p, aes_string(x = "YEAR" , y = input$measure, color="geography", group = "geography"))
  p <- p + geom_line(size=1) + geom_point(size=3) + scale_color_manual(values = wes_palette("Darjeeling2")) + theme_minimal(base_size = 12) + labs(x = "Year", y = input$measure, colour = "Region")
  print(p)
 })}

shinyApp(ui = ui, server = server)

