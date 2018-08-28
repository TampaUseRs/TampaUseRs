# Keras/Tensorflow example; "Deep Learning with R" - F Chollet, JJ Allaire
library(keras)

# Download the data from the keras package and define the test and train datasets (MNIST data comes with Keras)
mnist<-dataset_mnist()
train_images <- mnist$train$x
train_labels <- mnist$train$y
test_images <- mnist$test$x
test_labels <- mnist$test$y
# define our network: 784 ( or 28*28) inputs with first layer of 512 units and second layer of 10 outputs. 
# note the relu activation vs sigmoid. Keras Sequential model is simple layered model. Two layers are defined. 
network <- keras_model_sequential() %>%
  layer_dense(units = 512, activation = "relu", input_shape = c(28*28)) %>%
  layer_dense(units = 10 ,activation = "softmax")

# compile the network based on three parameters.
network %>% compile(
  optimizer = "rmsprop", 
  loss = "categorical_crossentropy",
  metrics = c("accuracy")
)
# reshape (flatten) the arrays into 2D tensors, sampel size of 60000 with length of 784
train_images <- array_reshape (train_images, c(60000, 28*28))
train_images <- train_images/255
test_images <- array_reshape (test_images, c(10000, 28*28))
test_images <- test_images / 255

train_labels <- to_categorical(train_labels)
test_labels <- to_categorical(test_labels)
# now run the model 
network %>% fit(train_images, train_labels, epochs = 5, batch_size = 128)

#Prediction
metrics<- network %>% evaluate(test_images, test_labels)
metrics
# Display the network
summary(network)




