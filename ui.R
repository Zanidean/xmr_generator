library(shiny)
library(sRa)
library(tidyverse)

shinyUI(fluidPage(theme = "www/paper_modified.css",
                  
  titlePanel("XMR Chart Generator"),
  sidebarPanel(fluid = TRUE,
               helpText("This program will take in your data and output a chart and plot with XMR boundaries calculated."),
               fileInput("inputFile", "Upload a file"),
               helpText("This .csv file must contain two columns:"),
               helpText("The first column must measure 'Time', and it must be labeled as such."),
               helpText("The second must be labeled 'Measure', and must contain some numeric measure."),

               submitButton("Update View", icon("refresh")),
               helpText(" "),
               downloadButton('downloadData', 'Save Data', 
                              style ="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
               helpText(" "), width = 3),
  mainPanel(plotOutput("xmr", width = "auto"),  
            tableOutput("contents"))
  )
)
