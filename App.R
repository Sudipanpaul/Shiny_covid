
library(shiny)
library(httr)
library(jsonlite)
library(dplyr)
library(ggplot2)
library(leaflet)
library(tidyr)
library(shinythemes)
library(maps)
library(bslib)
library(DT)
library(plotly)

url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
covid_data <- read.csv(url)

covid_data_long <- covid_data %>%
  pivot_longer(cols = starts_with("X"), names_to = "Date", values_to = "Cases") %>%
  mutate(Date = as.Date(Date, format = "X%m.%d.%y"))


ui <- fluidPage(
  
  

  theme = bs_theme(bg = "#fff",
                   fg = "black",
                   primary = "#E69F00",
                   secondary = "#0072B2",
                   success = "#009E73",
                   base_font = font_google("Inter"),
                   code_font = font_google("JetBrains Mono")),

  
  
  titlePanel(div(style = "text-align: center;color : #E69F00 ;height: 100px; line-height: 100px;",
                   strong("COVID-19 ANALYSIS"))),
  sidebarLayout(
    sidebarPanel(
      selectInput("country", "Select Country:", choices = unique(covid_data$Country.Region)),
      dateRangeInput("dateRange", "Select Date Range:",
                     start = min(covid_data_long$Date), end = max(covid_data_long$Date)),
      
      #card start
      card(
        card_header("Total counts",class = "bg-dark"),
        card_body(
          div(
          style = "text-align:center;color :#AF2C10;height: 50px;font-size:25px;font-family:Times New Roman",
          strong(textOutput("counts"))
          )
          
        ),
        card_footer(div(style ="text-align:center",
                        shiny::icon("solid fa-person-arrow-up-from-line"),strong("POP:effected")))
      ),
      
      #card end
      
      
    ),
    mainPanel(
      tabsetPanel(
      tabPanel("data",
               dataTableOutput("table")),
      tabPanel(
      "Plots",
      fluidRow(
      column(6,
      plotlyOutput("trendPlot")),#col1 end
      
      column(6,
      leafletOutput("map")),#col2 end
      ),
      fluidRow(
      column(8,offset = 2,
      plotlyOutput("hist")
      )))
    ))),#remove one here for fluidrow
  
  
  
  
  
  
)


server <- function(input, output, session) {
  filtered_data <- reactive({
    covid_data_long %>%
      filter(Country.Region == input$country,
             Date >= input$dateRange[1],
             Date <= input$dateRange[2])
  })
  
  output$table = renderDataTable({
    datatable(filtered_data())
  })
  
  
  output$counts <-renderText({
    sum(filtered_data()[['Cases']])
  })
  
  output$trendPlot <- renderPlotly({
    
  p =  ggplot(filtered_data(), aes(x = Date, y = Cases)) +
      geom_line() +
      labs(title = paste("COVID-19 Cases in", input$country),
           x = "Date", y = "Number of Cases")
  p2 = ggplotly(p)
  return(p2)
  
  })
  
  output$hist <-renderPlotly({
     p = ggplot(filtered_data(),aes(Cases),tit)+theme_bw()+
      theme(axis.line = element_line(size=1, colour = "black"),
            panel.grid = element_blank(), panel.border = element_blank(), 
            panel.background = element_blank(), panel.spacing = unit(0.3, "lines"),
            axis.text = element_text(colour="black", size = 12,family = "Arial"),
            #axis.text.y=element_text(colour="black", size = 12),
            axis.title=element_text(size=12,face = "bold",color ="black"),
            strip.text.x = element_text(size = 12, face="bold"))+
      geom_histogram(fill = "brown")+xlab("Cases Counts") 
     
     ggplotly(p)
  })
  
  output$map <- renderLeaflet({
    country_data <- covid_data_long %>%
      filter(Country.Region == input$country)
    
    country_data2 <- covid_data_long %>% 
      dplyr::group_by(Country.Region) %>% 
      summarize(Cases = sum(Cases),
                Lat = first(Lat),
                Long = first(Long))
    
    leaflet(country_data2) %>%
      addTiles() %>%
      addCircles(lng = ~Long, lat = ~Lat, weight = 1,radius = ~Cases/100000,
                  popup = ~paste(Country.Region,"Cases:",Cases))
  })
}


shinyApp(ui, server)


#etxra code
#leaflet(covid_data_long%>%dplyr::filter(Country.Region == "Australia"))%>%addTiles()%>%addCircles(lng =~Long,lat = ~Lat,radius =  50)
