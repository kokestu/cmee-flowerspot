## Load image data from directory

get_tfdataset <- function(filename){
  # takes structured directory and uploads images to tfdataset
img_data <- image_dataset_from_directory(filename)
return(img_data)
}

# Prepare tf dataset image for model
prepare_data <- function(data_set, batch_size, shuffle_buffer_size){
  # Shuffles data and puts into batches 
  if (shuffle_buffer_size > 0){
    data_set <- data_set %>% dataset_shuffle(shuffle_buffer_size)
  }
  
  # prefeth lets dataset fetch batches in the background while the model is training
  data_set %>% dataset_batch(batch_size) %>% dataset_prefetch(buffer_size=tf$data$experimental$AUTOTUNE)
  
}

show_data <- function(data=img_data){
  data %>% 
    reticulate::as_iterator() %>% 
    reticulate::iter_next()
}

# Define + compile model

model <- keras_model_sequential() %>%
  layer_cropping_2d(cropping=list(50,50)) %>%
  layer_conv_2d(filters=10,
                kernel_size=c(5,5), 
                activation="relu",
                input_shape = c(50,50, 3)) %>%
  layer_max_pooling_2d(pool_size=c(2,2)) %>%
  layer_flatten() %>%
  layer_dense(units=20, activation = "relu") %>%
  layer_dense(units=10, activation="softmax") %>%
  
  compile(optimizer="adam",
          loss="sparse_categorical_crossentropy",
          metrics=c('accuracy'))

model %>% fit(prepare_data(img_data, batch_size=32, shuffle_buffer_size=1000),
              epochs=5,
              verbose=2)
