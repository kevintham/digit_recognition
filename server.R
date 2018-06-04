#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(imager)
library(ggplot2)
library(reshape2)
library(caret)
library(nnet)
library(plyr)
library(plot3D)
library(RColorBrewer)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  img_grey <- observeEvent(input$img_array, {
    
    # rescale values to between 0-1
    img <- 255 - unlist(input$img_array)
    
    # obtain width of image
    width <- sqrt(length(img)/4)
    
    # reshape vector into array and remove transparency dimension
    img_arr <- aperm(array(img, dim=c(4, width, width)), c(2,3,1))[,,1:3]
    
    # convert format for imager manipulation to resize and greyscale
    im <- as.cimg(img_arr)
    resized_img <- resize(im, 28, 28)
    
    #output$proc <- renderPlot({
    #  plot(255-grayscale(resized_img))
    #})
    
    test_vec <- as.vector(grayscale(resized_img))/255
    test_arr <- array(test_vec, dim=c(1,784))
    test_df <- data.frame(test_arr)
    names(test_df) <- 1:784
    
    output$proc <- renderPlot({
      matrix_obs <- array(as.numeric(test_df), c(28,28))[,28:1]
      image2D(matrix_obs, col=brewer.pal(9, 'Greys'))
      
    })
    
    test_h2o <- as.h2o(test_df)
    
    #preproc <- readRDS('www/preproc.RDS')
    #model <- readRDS('www/model.RDS')
    
    autoencode <- readRDS('www/autoencode.RDS')
    model <- readRDS('www/h2omodel.RDS')
    
    withProgress(message='Performing Calculations:', value=1, {
      recon_obs <- predict(autoencode, test_h2o)
      prediction <- as.vector(predict(model, test_h2o))
    })

    output$code <- renderPlot({
      code <- h2o.deepfeatures(autoencode, test_h2o, layer=2)
      matrix_code <- array(code, c(8,8))[,8:1]
      image2D(matrix_code, col=brewer.pal(9, 'Greys'))
    })
    
    output$recon <- renderPlot({
      matrix_obs <- array(as.numeric(recon_obs), c(28,28))[,28:1]
      image2D(matrix_obs, col=brewer.pal(9,'Greys'))
      
    })
    
    
    output$console <- renderPrint({print(prediction)})
    
    output$predict <- renderPlot({
    
      ggplot(data.frame(digit=factor(0:9), prob=as.numeric(prediction[-1])), aes(x=digit,y=prob)) + geom_bar(stat='identity')
    })
    
    
  })
  


  
  
  
  
  
  
})
