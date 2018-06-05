#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
rm(list=ls())

library(shiny)


shinyUI(fluidPage(
  
 
  includeCSS("www/style.css"),
  
  titlePanel("Digit Recognition"),
  sidebarLayout(
    sidebarPanel(class="row",
      h1("User Inputs"),
      
      h3("Pen Width:"),
      sliderInput("slider", "Width(px):", 10, 20, 15),
      
      h3("Draw Digit Here:"),
      
      div(
        actionButton("clear", "Clear"),
        actionButton("predict", "Predict")),
      
      div(id="canvas-div", class="col-md-4 row", 
               tags$canvas(id="canvas", width="240px", height="240px")
      )
    
    ),
    
    mainPanel(
      tags$div(
        h3("Information"),
        tags$ol(
          tags$li("Draw a digit from 0-9 on the left."), 
          tags$li("The bar chart below displays the conditional probabilities of the labels 0-9
                  based on a neural network trained on the MNIST dataset.")
        )
      ),
      plotOutput("predict"),
      "Note:",
      tags$ol(
        tags$li("Please give about 10 seconds for app to calculate result."),
        tags$li("Validation set accuracy obtained was 97.5%, however, 
                due to processing of canvas image accuracy may be affected.")
      )
    )
  ),
  
  includeScript("www/fabric.min.js"),
  includeScript("www/drawcanvas.js")
  
))
