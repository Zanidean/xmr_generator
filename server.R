library(shiny)
library(sRa)
library(air)
library(ggrepel)
library(tidyverse)
library(readxl)

shinyServer(function(input, output) {
  
  dataframe <- reactive({
    inFile <- input$inputFile
    if (is.null(inFile))
      return(NULL)
    

    dataframe <- read.csv(inFile$datapath)

    dataframe <- dataframe %>% xmR(., "Measure", recalc = T) %>% select(-Order)
    dataframe
  })
  
  
  
  chart <- reactive({
    whitetheme <- theme_bw() +
      theme(strip.background = element_rect(fill = NA, linetype = 0),
            panel.border = element_rect(color = NA),
            panel.spacing.y  = unit(5.5, "lines"),
            panel.spacing.x  = unit(6, "lines"),
            panel.grid.minor = element_blank(),
            panel.grid.major = element_line(colour = "#fff2f2"),
            axis.text.y  = element_blank(),
            axis.title.y = element_blank(),
            axis.ticks.y = element_blank(),
            axis.ticks.x = element_blank(),
            text = element_text(family = "sans"),
            axis.text.x = element_text(colour = "#000000", size = 17),
            axis.title.x = element_text(size = 20, face = "bold"),
            strip.text = element_text(size = 20),
            title = element_text(size = 20))
    
    inFile <- input$inputFile
    if (is.null(inFile))
      return(NULL)
    
    
    dataframe <- read.csv(inFile$datapath)
    
    dataframe <- dataframe %>% xmR(., "Measure", recalc = T) %>% select(-Order)
    dataframe
    
    ggplot(dataframe, aes(as.character(Time), group = 1)) +
      geom_line(aes(y = `Central Line`),
                size = 1, 
                linetype = "dotted", 
                na.rm = T) +
      geom_line(aes(y = `Lower Natural Process Limit`),  
                color = "#d02b27",
                size  = 1, 
                linetype = "dashed", 
                na.rm  = T) +
      geom_line(aes(y  = `Upper Natural Process Limit`), 
                color  = "#d02b27",
                size   = 1, 
                linetype = "dashed", 
                na.rm  = T) +
      geom_line(aes(y  = Measure)) + 
      geom_point(aes(y = Measure), 
                 size  = 5.55, 
                 color = "#000000") +
      geom_point(aes(y = Measure), 
                 size  = 4.5, 
                 color = "#7ECBB5") + 
      geom_label_repel(aes(y = Measure, label = Measure),
                       size = 6,
                       label.r = unit(0.2, "lines"),
                       label.size = 0.15, nudge_x = 0.32) +
      guides(colour = FALSE) + whitetheme +
      labs(x = "Time")
  })
  

  output$contents <- renderTable({
    dataframe()
  })
  
  output$xmr <- renderPlot({
      chart()
  })

  output$downloadData <- downloadHandler(
    filename = "Download.csv",
    content = function(file){
      write.csv(dataframe(), file, row.names = F, na = "")
      }
  )
  
})
