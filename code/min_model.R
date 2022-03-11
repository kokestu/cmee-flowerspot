
# Imports
#require(keras)
#install_keras()
library(tfdatasets)


## Load image data from directory

img_data <- image_dataset_from_directory(directory="../data/img", seed= 123, validation_split=0.4, subset="training")
test_data <-image_dataset_from_directory(directory="../data/img", seed= 123, validation_split=0.4, subset="validation")


# Prepare tf dataset image for model
prepare_data <- function(data_set, batch_size, shuffle_buffer_size){
  # Shuffles data and puts into batches 
  if (shuffle_buffer_size > 0){
    data_set <- data_set %>% dataset_shuffle(shuffle_buffer_size)
  } }
  

## TESTING

show_data <- function(data=img_data){
  test <- data %>% 
    reticulate::as_iterator() %>% 
    reticulate::iter_next()
  return(test)
}

t <- show_data()
t <- t[[1]][[1]]

print.image <- function(path) {
  img <- brick(paste('../data/img/', path, sep=''))
  plotRGB(img)
}


# Define + compile model

model <- keras_model_sequential() %>%
 # layer_cropping_2d(cropping=list(50,50)) %>%
  layer_conv_2d(filters=10,
                kernel_size=c(3,3), 
                activation="relu",
                input_shape = c(256, 256, 3)) %>%
  layer_max_pooling_2d(pool_size=c(2,2)) %>%
  layer_dropout(rate=0.25) %>%
  layer_flatten() %>%
  layer_dense(units=20, activation = "relu") %>%
  layer_dense(units=2, activation="softmax") %>%
  
  compile(optimizer="adam",
          loss="sparse_categorical_crossentropy",
          metrics=c('accuracy'))

set.seed(888)
model %>% fit(prepare_data(img_data, batch_size=32, shuffle_buffer_size=1000),
              epochs=5,
              verbose=2)


# Evaluate model
model %>% evaluate(prepare_data(test_data, batch_size=32, shuffle_buffer_size=1000))
