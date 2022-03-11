library(keras)
library(jpeg)
library(raster)

# Read images directly
load.image <- function(path) {
  return(
    readJPEG(paste('../data/img/', path, sep=''))
  )
}

# Choose size to crop all images too
ncol <- 40; nrow <- 40

# Print out images
print.image <- function(path) {
  img <- brick(paste('../data/img/', path, sep=''))
  plotRGB(img)
}

# Look up the files
data_dir <- file.path('../data', 'img')
images <- list.files(data_dir, pattern = ".jpg", recursive = TRUE)

# Get the label of the data from the filename
get_label <- function(file_path) {
  parts <- strsplit(file_path, "/")
  if (parts[[1]][[1]] == 'pos') {
    return(1)
  } else {
    return(0)
  }
}

# Extract the label from the file path and load the image
preprocess_path <- function(file_paths) {
  n <- length(file_paths)
  data <- list(
    exp=array(
      dim=c(n, ncol, nrow, 3)
    ),
    resp=vector('numeric', n),
    name=vector('character', n)
  )
  i <- 0
  for (path in file_paths) {
    # Crop images
    img <- load.image(path)
    if (
      length(dim(img)) == 3 &&
      all(!is.na(img))
    ) {
      i <- i + 1
      data$resp[i] <- get_label(path)
      data$exp[i,,,] <- img[1:ncol,1:nrow,]
      data$name[i] <- path
    }
  }
  data$resp <- data$resp[1:i]
  data$exp <- data$exp[1:i,,,]
  data$name <- data$name[1:i]
  return(data)
}

# Load the images from the directories -- has a separate positive and negative
# thing.
imgs <- preprocess_path(images)

# Show some sample data
par(mfrow=c(2,2))
for (i in seq_len(2*2)) {
  x <- floor(runif(1, min=1, max=length(imgs$name)))
  print.image(imgs$name[[x]])
}

# Show some sample data (greyscale)
par(mfrow=c(2,2))
for (i in seq_len(2*2)) {
  x <- floor(runif(1, min=1, max=length(imgs$name)))
  image(imgs$exp[x,,,1])
}

# Define a non-covolutional model
model <- keras_model_sequential() %>%
  layer_conv_2d(filters=10,
                kernel_size=c(3,3), 
                activation="relu",
                input_shape = c(ncol,nrow,3)) %>%
  layer_max_pooling_2d(pool_size=c(2,2)) %>%
  layer_flatten() %>%
  layer_dense(units=20, activation = "relu") %>%
  layer_dense(units=1, activation="softmax")

# And compile it
model %>% 
  compile(
    loss = "mean_absolute_error",
    optimizer = "adam",
    metrics = "accuracy"
  ) 

# And fit it
model %>%
  fit(imgs$exp, as.numeric(as.factor(imgs$resp)), epochs = 5)
