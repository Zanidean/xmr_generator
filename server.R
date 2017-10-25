library(shiny)
library(devtools)
devtools::install_github("zanidean/sra", quick = T)
devtools::install_github("daattali/colourpicker")
library(colourpicker)
library(sRa)
library(ggrepel)
library(tidyverse)
library(readxl)

shinyServer(function(input, output) {
  
  dataframe <- reactive({
    inFile <- input$inputFile
    if (is.null(inFile))
      return(NULL)
    
    if(input$type == ".xlsx"){
    dataframe <- read_excel(inFile$datapath)
    } else {dataframe <- read.csv(inFile$datapath)}
    
    dataframe <- dataframe %>% 
      xmR(., "Measure", recalc = T) %>% 
      select(-Order)
    dataframe
  })
  
  
  chart <- reactive({
    
    if(input$center == "Center"){alig = 0.5} else {alig = 0}
    if(input$grid == T){gridcol = "#f2f2f2"} else {gridcol = "#ffffff"}
    
    whitetheme <- theme_bw() +
      theme(strip.background = element_rect(fill = NA, linetype = 0),
            panel.border = element_rect(color = NA),
            panel.spacing.y  = unit(10, "lines"),
            panel.spacing.x  = unit(10, "lines"),
            panel.grid.minor = element_blank(),
            panel.grid.major = element_line(colour = gridcol),
            axis.ticks.y = element_blank(),
            axis.ticks.x = element_blank(),
            text = element_text(family = "sans"),
            axis.text.x = element_text(colour = "#000000", size = input$textsize-3),
            axis.title.x = element_text(size = input$textsize, face = "bold"),
            axis.text.y = element_blank(),
            axis.title.y = element_text(size = input$textsize, face = "bold"),
            strip.text = element_text(size = input$titlesize),
            plot.title = element_text(size = input$titlesize, 
                                      hjust = alig, 
                                      face = "bold"),
            plot.subtitle = element_text(size = input$titlesize*.66, 
                                         hjust = alig))
    
    inFile <- input$inputFile
    if (is.null(inFile))
      return(NULL)
    
    
    if(input$type == ".xlsx"){
      dataframe <- read_excel(inFile$datapath)
    } else {dataframe <- read.csv(inFile$datapath)}
    
    
    dataframe <- dataframe %>% 
      xmR(., "Measure", recalc = T) %>% 
      select(-Order)
    dataframe
    
    plot <- ggplot(dataframe, aes(as.character(Time), group = 1)) +
      geom_line(aes(y = `Central Line`),
                size = input$refline, 
                linetype = "dotted", 
                na.rm = T) +
      geom_line(aes(y = `Lower Natural Process Limit`),  
                color = input$linecol,
                size  = input$refline,
                linetype = "dashed", 
                na.rm  = T) +
      geom_line(aes(y  = `Upper Natural Process Limit`), 
                color  = input$linecol,
                size   = input$refline, 
                linetype = "dashed", 
                na.rm  = T) +
      geom_line(aes(y  = Measure)) + 
      geom_point(aes(y = Measure), 
                 size  = input$dotsize + 1, 
                 color = "#000000") +
      geom_point(aes(y = Measure), 
                 size  = input$dotsize, 
                 color = input$dotcol) + 
      scale_x_discrete() + 
      guides(colour = FALSE) + whitetheme +
      labs(x = input$x, y = input$y) + ggtitle(input$title, subtitle = input$subtitle)
    
      if(input$labelsize != 0){
        plot <- plot + geom_label_repel(aes(y = Measure, 
                                                label = if(input$l_format == "Percent") {
                                                  scales::percent(round(Measure, input$digits))
                                                } else if(input$l_format == "Dollars"){
                                                  scales::dollar(round(Measure, input$digits))
                                                } else {round(Measure, input$digits)}),
        size = input$labelsize,
        label.r = unit(0.2, "lines"),
        label.size = 0.15, nudge_x = 0.32)
      } 
    plot
    
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
             width = input$width, dpi = input$dpi)
    }
  )
  
})
