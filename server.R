#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
#rm(list=ls())

library(shiny)
library(imager)
library(ggplot2)
library(h2o)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  img_grey <- observeEvent(input$img_array, {
    
    
    # loading message
    withProgress(message='Performing Calculations:', value=1, {
      
      # rescale values to between 0-1
      img <- 255 - unlist(input$img_array)
      
      # obtain width of image
      width <- sqrt(length(img)/4)
      
      # reshape vector into array and remove transparency dimension
      img_arr <- aperm(array(img, dim=c(4, width, width)), c(2,3,1))[,,1:3]
      
      # convert format for imager manipulation to resize and greyscale 
      # and rescale between 0-1
      im <- as.cimg(img_arr)
      resized_img <- resize(im, 28, 28)
      test_vec <- as.vector(grayscale(resized_img))/255
      
      # reformat data
      test_arr <- array(test_vec, dim=c(1,784))
      test_df <- data.frame(test_arr)
      names(test_df) <- 1:784

      # To obtain predictions from trained model
      dfstr <- sapply(1:ncol(test_df), function(i) 
        paste(paste0('\"', names(test_df)[i], '\"'), test_df[1,i], sep = ':'))
      
      json <- paste0('{', paste0(dfstr, collapse = ','), '}')

      predict <- h2o.predict_json(model = 'www/nn_model.zip', json = json)
      prediction <- as.vector(predict)
      
      # Bar plot of prediction
      output$predict <- renderPlot({
        ggplot(data.frame(digit=factor(0:9), 
                          prob=as.numeric(prediction[[3]])), aes(x=digit,y=prob)) + 
          geom_bar(stat='identity') + labs(title='Model Prediction of Input Digit')
      })
    
    })
    
  })
  
})
