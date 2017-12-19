library(shiny)
library(xmrr)
library(tidyverse)
library(readxl)
library(colourpicker)

shinyUI(fluidPage(theme = "www/paper_modified.css",
                  
                  tags$style(HTML(".js-irs-0 .irs-single, .js-irs-0 .irs-bar-edge,
                  .js-irs-0 .irs-bar 
                                  {color: #000; background: #c3c6c9 ; border-color: #9BA0A5}")),
                  tags$style(HTML(".js-irs-1 .irs-single, .js-irs-1 .irs-bar-edge,
                                  .js-irs-1 .irs-bar 
                                  {color: #000; background: #c3c6c9 ; border-color: #9BA0A5}")),
                  tags$style(HTML(".js-irs-2 .irs-single, .js-irs-2 .irs-bar-edge,
                  .js-irs-2 .irs-bar 
                                  {color: #000; background: #c3c6c9; border-color: #9BA0A5}")),

                  tags$style(HTML(".js-irs-3 .irs-single, .js-irs-3 .irs-bar-edge,
                                  .js-irs-3 .irs-bar 
                                  {color: #000; background: #c3c6c9 ; border-color: #9BA0A5}")),
                  tags$style(HTML(".js-irs-4 .irs-single, .js-irs-4 .irs-bar-edge,
                                  .js-irs-4 .irs-bar 
                                  {color: #000; background: #c3c6c9 ; border-color: #9BA0A5}")),

                  tags$style(HTML(".js-irs-5 .irs-single, .js-irs-5 .irs-bar-edge,
                                  .js-irs-5 .irs-bar 
                                  {color: #000; background: #c3c6c9 ; border-color: #9BA0A5}")),
                  tags$style(HTML(".js-irs-6 .irs-single, .js-irs-6 .irs-bar-edge,
                                  .js-irs-6 .irs-bar 
                                  {color: #000; background: #c3c6c9 ; border-color: #9BA0A5}")),
                  
                  tags$style(HTML(".js-irs-7 .irs-single, .js-irs-7 .irs-bar-edge,
                                  .js-irs-7 .irs-bar 
                                  {color: #000; background: #c3c6c9 ; border-color: #9BA0A5}")),

                  
                  tags$head(tags$style(".progress-bar{color: #000; background-color: #EBAF99; border-color:#fff; }")),

                  tags$style(HTML(".nav-tabs>li.active>a, .nav-tabs>li.active>a:focus, .nav-tabs>li.active>a:hover {background-color: #FFDFA4; border-color: #c3c6c9; color: #000;}")),
                  
                  
                  
                  tags$style(HTML(".nav-tabs > li > a {background-color: #c3c6c9; border-color:#c3c6c9; color: #000;}")),
                  tags$style(".btn-file {colour: #b5e1d4 ; border-color: #fff2; background: #b5e1d4}"),

                  #irs-slider single

                  HTML("<br/>"),
  img(src='logo.png', align = "center", width = "400px", alt = "Found me!"),
  titlePanel("XMR Chart Builder"),
          sidebarPanel(fluid = TRUE,
                       tabsetPanel(

                        tabPanel("Upload",

                           helpText("This program takes in time-series data and outputs both a table and a plot
                                    with calculated XMR boundaries."),
                           HTML("<b> Instructions: </b>"),
                           HTML("<br/>"),
                           HTML("<b>1.</b> Upload a file."),
                           HTML("<br/>"),
                           HTML("<b>2.</b> One column must be labeled 'Time', 
                                and it must contain unique and ordered measures of time."),
                           HTML("<br/>"),
                           HTML("<b>3.</b> Another column must be labeled 'Measure', 
                                and must contain some numeric measure. This will be used for calculations."),
                           helpText(" You can change the labels of this chart in the \"Look\" tab."),

                           radioButtons("type", "Choose Type of File:", choices = c(".csv", ".xlsx"), 
                                        inline = F),
                           fileInput("inputFile", NULL, buttonLabel = "Upload a file",
                                     placeholder = "   No file uploaded", accept = "text/csv"),
                           helpText("If you see error messages, ensure the file type is correct and your columns are properly labeled \"Time\" and \"Measure\".")
                           ),


                        tabPanel("Runs",
                                 helpText("Define the arguments used to build your chart"),
                                 checkboxInput("recalc", "Recalculate the bounds?", value = T),
                                 
                                 helpText("How many points is a shortrun?"),
                                 numericInput("sr2", label = NULL, 4),
                                 
                                 helpText("How many of those points need to be significant to qualify it as a shortrun?"),
                                 numericInput("sr1", label = NULL, 3),
                                 
                                 helpText("How many points is a longrun?"),
                                 numericInput("lr2", label = NULL, 8),
                                 helpText("How many of them do you want to use in your calculation?"),
                                 numericInput("lr1", label = NULL, 5)
                        ),

                        tabPanel("Look",
                            
                          #HTML("<br/>"),                  
                          helpText("Label your chart and make it your own"),
                           textInput("title", label = "Chart Title:", value = ""),
                          textInput("subtitle", label = "Subtitle:", value = ""),
                          radioButtons("center", "Title Position:", choices = c("Left", "Center"), 
                                       inline = T),
                           textInput("x", label = "X-Axis Title:", value = ""),
                           textInput("y", label = "Y-Axis Title:", value = ""),
                          checkboxInput("grid", "Grid Lines", value = TRUE),
                          sliderInput("titlesize", "Chart Title Size:", min = 5, max = 50, 
                                      value = 20, ticks = F, step = 0.1),
                          sliderInput("textsize", "Axis Text Size:", min = 5, max = 20, 
                                      value = 15, ticks = F, step = 0.1),
                          sliderInput("labelsize", "Label Size:", value = 6, min = 0, max = 20, 
                                      ticks = F, step = 0.1),
                          radioButtons("l_format", "Label Format:", 
                                       choices = c("Raw", "Percent", "Dollars"), inline = T),
                          numericInput("digits", "Label Digits:", value = 2, min = 0, max = 5),
                          sliderInput("dotsize", "Point Size:", value = 5, min = 3, max = 20, 
                                      ticks = F, step = 0.1),
                          sliderInput("refline", "Reference Line Size:", value = 1, min = 0, max = 2, 
                                      ticks = F, step = 0.01),
                          colourInput("dotcol", "Point Colour:", value = "#7ECBB5"),
                          colourInput("linecol", "Reference Line Colour:", value = "#d02b27")
                        ),
                      
                        tabPanel("Export",
                           #HTML("<br/>"),
                           helpText("Save the XMR charts using the button below"),
                           helpText("PNGs can be easily placed into Excel or Word."),
                           
                           downloadButton('downloadPlot', 'Save PDF', 
                                          style ="color: #000; background-color: #b5e1d4; border-color: #b5e1d4"),
                           downloadButton('downloadPlotPNG', 'Save PNG', 
                                          style ="color: #000; background-color: #b5e1d4; border-color: #b5e1d4"),
                           helpText(""),
                           #radioButtons("type", "PDF or PNG", select = "PDF", choices = c("PDF", "PNG")),
                           sliderInput("height", "Saved Chart Height (inches)", 
                                       value = 4, min = 3, max = 20, ticks = F),
                           sliderInput("width", "Saved Chart Width (inches)", 
                                       value = 14, min = 3, max = 20, ticks = F),
                           sliderInput("dpi", "Saved Chart Resolution (DPI)", 
                                       value = 600, min = 150, max = 1600, ticks = F),
                           helpText("Save the table to make your own XMR charts."),
                           downloadButton('downloadData', 'Save Table', 
                                          style ="color: #000; background-color: #EBAF99; border-color: #EBAF99"),
                           helpText(" \n ")
                       )),
                       width = 3),

  
  mainPanel(
            plotOutput("xmr", width = "auto"),  
            HTML("<br/>"),
            tableOutput("contents"))
  )
)
