library(shiny)
library(sRa)
library(tidyverse)

shinyUI(fluidPage(theme = "www/paper_modified.css",
                  tags$style(HTML(".js-irs-0 .irs-single, .js-irs-0 .irs-bar-edge, 
                  .js-irs-0 .irs-bar {color: #000; background: #7ECBB5 ; border-color: #7ECBB5}")),
                  tags$style(HTML(".js-irs-1 .irs-single, .js-irs-1 .irs-bar-edge, 
                                  .js-irs-1 .irs-bar {color: #000; background: #FFDFA4 ; border-color: #FFDFA4  }")),
                  tags$style(HTML(".js-irs-2 .irs-single, .js-irs-2 .irs-bar-edge, 
                  .js-irs-2 .irs-bar {color: #000; background: #EBAF99 ; border-color: #EBAF99}")),
                  
                
                  tags$style(HTML(".js-irs-3 .irs-single, .js-irs-3 .irs-bar-edge, 
                                  .js-irs-3 .irs-bar {color: #000; background: #c3c6c9 ; border-color: #c3c6c9  }")),
                  tags$style(HTML(".js-irs-4 .irs-single, .js-irs-4 .irs-bar-edge, 
                                  .js-irs-4 .irs-bar {color: #000; background: #c3c6c9 ; border-color: #c3c6c9  }")),
                  tags$head(tags$style(".progress-bar{color: #000; background-color:#FFDFA4; border-color:: #fff; }")),
                  tags$style(".nav-tabs-custom .nav-tabs li.active:hover a, .nav-tabs-custom .nav-tabs li.active a {colour: #000; background-color: #ffff2; border-color:: #fff;}"),
                  

                  
  titlePanel("XMR Chart Generator"),
  
          sidebarPanel(fluid = TRUE,
                       tabsetPanel(
                        tabPanel("Upload",
                           HTML("<br/>"),
                           helpText("This program will take in your data and output a chart and plot 
                                    with XMR boundaries calculated."),
                           HTML("<b> Instructions </b>"),
                           HTML("<br/>"),
                           HTML("<b>1.</b> Upload a .csv file."),
                           HTML("<br/>"),
                           HTML("<b>2.</b> The first column of this .csv must be labeled 'Time', 
                                and it must contain unique measures of time."),
                           HTML("<br/>"),
                           HTML("<b>3.</b> The second column must be labeled 'Measure', 
                                and must contain some numeric measure."),
                           HTML("<br/>"),
                           HTML("<br/>"),


                           fileInput("inputFile", NULL, buttonLabel = "Upload .csv file", width = "100%",
                                     placeholder = "No file uploaded")),
                        tabPanel("Chart Properties",
                          HTML("<br/>"),
                          helpText("Label your chart and choose it's properties"),
                           textInput("title", label = "Chart Title", value = ""),
                           textInput("x", label = "X-Axis Label", value = "Time"),
                           textInput("y", label = "Y-Axis Label", value = "Measure"),
                          numericInput("titlesize", "Chart Title Size", min = 5, max = 50, value = 20),
                          numericInput("textsize", "Axis Label Size", min = 5, max = 20, value = 15),

                          sliderInput("dotsize", "Point Size", value = 5, min = 3, max = 20, ticks = F),
                          sliderInput("labelsize", "Label Size", value = 6, min = 3, max = 20, ticks = F),
                          sliderInput("refline", "Reference Line Size", value = 1, min = 0, max = 2, 
                                      ticks = F, step = 0.1)),
                       

                        tabPanel("Export",
                           HTML("<br/>"),
                           helpText("Save the XMR plots using these button."),
                           helpText("PNG can be placed into Excel."),
                           
                           downloadButton('downloadPlot', 'Save PDF', 
                                          style ="color: #000; background-color: #7ECBB5; border-color: #7ECBB5"),
                           downloadButton('downloadPlotPNG', 'Save PNG', 
                                          style ="color: #000; background-color: #7ECBB5; border-color: #7ECBB5"),
                           helpText(""),
                           #radioButtons("type", "PDF or PNG", select = "PDF", choices = c("PDF", "PNG")),
                           sliderInput("height", "Saved Plot Height (inches)", value = 4, min = 3, max = 20, ticks = F),
                           sliderInput("width", "Saved Plot Width (inches)", value = 14, min = 3, max = 20, ticks = F),
                           helpText("Save the table to make your own XMR charts."),
                           downloadButton('downloadData', 'Save Table', 
                                          style ="color: #000; background-color: #EBAF99; border-color: #EBAF99"),
                           helpText(" \n ")
                       )),
                       width = 3),


  mainPanel(plotOutput("xmr", width = "auto"),  
            HTML("<br/>"),
            tableOutput("contents"))
  )
)
