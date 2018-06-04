rm(list=ls())

if (!require("pacman")) install.packages("pacman")
pacman::p_load(dplyr, ggplot2, tidyr, neuralnet, caret, plyr, h2o)
h2o.init(nthreads = 3)

setwd('/home/kevintham/work/ds_portfolio/mnist_app/www/')

train_file <- "/home/kevintham/work/ds_portfolio/mnist_app/www/train.csv.gz"
test_file <- "/home/kevintham/work/ds_portfolio/mnist_app/www/test.csv.gz"
train <- h2o.importFile(train_file)
test <- h2o.importFile(test_file)

names(train) <- as.character(1:785)
names(test) <- as.character(1:785)

y <- "785" 
x <- setdiff(names(train), y)  

# Since the response is encoded as integers, we need to tell H2O that
# the response is in fact a categorical/factor column.  Otherwise, it 
# will train a regression model instead of multiclass classification.
train[,y] <- as.factor(train[,y])
test[,y] <- as.factor(test[,y])

train[,1:784] <- train[,1:784]/255
test[,1:784] <- test[,1:784]/255

hidden <- c(128,64,128)

ae_model <- h2o.deeplearning(x=x,
                             training_frame=train,
                             model_id="autoencoder",
                             ignore_const_cols=FALSE,
                             activation="Tanh",
                             hidden=hidden,
                             autoencoder=TRUE)

saveRDS(ae_model, file='autoencode.RDS')

nn_model <- h2o.deeplearning(x=x,
                             y=y,
                             training_frame=train,
                             ignore_const_cols=FALSE,
                             model_id="nn_mode",
                             hidden=hidden,
                             seed=1,
                             pretrained_autoencoder="autoencoder")

saveRDS(nn_model, file='h2omodel.RDS')
