library(shiny)
library(devtools)
devtools::install_github("zanidean/sra", quick = T)
library(sRa)
library(ggrepel)
library(tidyverse)
library(readxl)

shinyServer(function(input, output) {
  
  dataframe <- reactive({
    inFile <- input$inputFile
    if (is.null(inFile))
      return(NULL)
    

    dataframe <- read.csv(inFile$datapath)

    dataframe <- dataframe %>% 
      xmR(., "Measure", recalc = T) %>% 
      select(-Order)
    dataframe
  })
  
  
  chart <- reactive({
    whitetheme <- theme_bw() +
      theme(strip.background = element_rect(fill = NA, linetype = 0),
            panel.border = element_rect(color = NA),
            panel.spacing.y  = unit(5.5, "lines"),
            panel.spacing.x  = unit(6, "lines"),
            panel.grid.minor = element_blank(),
            panel.grid.major = element_line(colour = "#fff2ff"),
            axis.ticks.y = element_blank(),
            axis.ticks.x = element_blank(),
            text = element_text(family = "sans"),
            axis.text.x = element_text(colour = "#000000", size = 13),
            axis.title.x = element_text(size = input$textsize, face = "bold"),
            axis.text.y = element_blank(),
            axis.title.y = element_text(size = input$textsize, face = "bold"),
            strip.text = element_text(size = input$titlesize),
            plot.title = element_text(size = input$titlesize, 
                                      hjust = 0.5, face = "bold"))
    
    inFile <- input$inputFile
    if (is.null(inFile))
      return(NULL)
    
    
    dataframe <- read.csv(inFile$datapath)
    
    dataframe <- dataframe %>% 
      xmR(., "Measure", recalc = T) %>% 
      select(-Order)
    dataframe
    
    ggplot(dataframe, aes(as.character(Time), group = 1)) +
      geom_line(aes(y = `Central Line`),
                size = input$refline, 
                linetype = "dotted", 
                na.rm = T) +
      geom_line(aes(y = `Lower Natural Process Limit`),  
                color = "#d02b27",
                size  = input$refline,
                linetype = "dashed", 
                na.rm  = T) +
      geom_line(aes(y  = `Upper Natural Process Limit`), 
                color  = "#d02b27",
                size   = input$refline, 
                linetype = "dashed", 
                na.rm  = T) +
      geom_line(aes(y  = Measure)) + 
      geom_point(aes(y = Measure), 
                 size  = input$dotsize + 1, 
                 color = "#000000") +
      geom_point(aes(y = Measure), 
                 size  = input$dotsize, 
                 color = "#7ECBB5") + 
      geom_label_repel(aes(y = Measure, label = Measure),
                       size = input$labelsize,
                       label.r = unit(0.2, "lines"),
                       label.size = 0.15, nudge_x = 0.32) +
      guides(colour = FALSE) + whitetheme +
      labs(x = input$x, y = input$y) + ggtitle(input$title)
  })
  
"P:/xmr_generator/"
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
  
  output$downloadPlot <- downloadHandler(
    filename = "Plot.pdf",
    content = function(file){
    ggsave(file, chart(), cairo_pdf, 
           height = input$height,
           width = input$width)
    }
  )
  
  
  output$downloadPlotPNG <- downloadHandler(
    filename = "Plot.png",
    content = function(file){
      ggsave(file, chart(),
             height = input$height,
             width = input$width, dpi = 1200)
    }
  )
  
})
