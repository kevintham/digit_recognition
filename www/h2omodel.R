rm(list=ls())

if (!require("pacman")) install.packages("pacman")
pacman::p_load(dplyr, ggplot2, tidyr, neuralnet, caret, plyr, h2o)
h2o.init(nthreads = 3)

# Set relevant working directory
#setwd('/home/kevintham/work/ds_portfolio/mnist_app/www/')

train_file <- "https://h2o-public-test-data.s3.amazonaws.com/bigdata/laptop/mnist/train.csv.gz"
test_file <- "https://h2o-public-test-data.s3.amazonaws.com/bigdata/laptop/mnist/test.csv.gz"
train <- h2o.importFile(train_file)
test <- h2o.importFile(test_file)

# Rename columns for ease
names(train) <- as.character(1:785)
names(test) <- as.character(1:785)

y <- "785" 
x <- setdiff(names(train), y)  

# Recode target as factor
train[,y] <- as.factor(train[,y])
test[,y] <- as.factor(test[,y])

# Rescale data
train[,1:784] <- train[,1:784]/255
test[,1:784] <- test[,1:784]/255

# Architecture of Network
hidden <- c(128,64,128)

# Train Autoencoder
ae_model <- h2o.deeplearning(x=x,
                             training_frame=train,
                             model_id="autoencoder",
                             ignore_const_cols=FALSE,
                             activation="Tanh",
                             hidden=hidden,
                             autoencoder=TRUE)

# save file
#h2o.downMojo(ae_model, path=getwd(), get_genmodel_jar=TRUE)

# Train network with pretrained autoencoder
nn_model <- h2o.deeplearning(x=x,
                             y=y,
                             training_frame=train,
                             ignore_const_cols=FALSE,
                             model_id="nn_model",
                             hidden=hidden,
                             seed=1,
                             pretrained_autoencoder="autoencoder")

# save model
h2o.download_mojo(nn_model, path=getwd(), get_genmodel_jar=TRUE)
