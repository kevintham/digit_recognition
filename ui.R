#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)



shinyUI(fluidPage(
  
 
  includeCSS("www/style.css"),
  
  titlePanel("Digit Recognition"),
  sidebarLayout(
    sidebarPanel(
      h1("Adjust Pen Width"),
      
      sliderInput("slider", "Width(px):", 10, 20, 15),
      
      h3("Draw Digit Here:"),
      
      tags$div(id="canvas-div", class="col-md-4", 
               tags$canvas(id="canvas", width="240px", height="240px")
      ),
      actionButton("clear", "Clear"),
      actionButton("predict", "Predict")

    ),
    
    mainPanel(
    
      
      #plotOutput("proc"),
      #plotOutput("recon"),
      #plotOutput("code"),
      plotOutput("predict")
      #tableOutput("out")
      #textOutput("class")
      #verbatimTextOutput('console')
    )
  ),
  
  includeScript("www/fabric.min.js"),
  includeScript("www/drawcanvas.js")
  
))
