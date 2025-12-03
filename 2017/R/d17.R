advent17a <- function(steps, insertions, result_after) {
  buffer <- 0
  position <- 0
  buffer_size <- length(buffer)
  while (buffer_size <= insertions) {
    position <- (position + steps) %% buffer_size
    if ((position + 1)  == buffer_size) {
      buffer <- c(buffer, buffer_size)
    } else {
      buffer <- c(buffer[1:(position+1)], buffer_size, buffer[(position+2):buffer_size])
    }
    buffer_size <- buffer_size + 1
    position <- (position + 1) %% buffer_size
  }
  index <- which(buffer == result_after) + 1
  if (index > buffer_size) index <- 1
  buffer[index]
}

advent17b <- function(steps, insertions, result_after) {
  buffer <- c(0,0)
  position <- 0
  buffer_size <- 1
  while (buffer_size <= insertions) {
    position <- (position + steps) %% buffer_size
    if (position == 0) {
      buffer[2] = buffer_size
    }
    buffer_size <- buffer_size + 1
    position <- (position + 1) %% buffer_size
  }
  buffer[2]

}

input <- as.numeric(readLines("../inputs/input_17.txt"))
c(advent17a(input, 2017, 2017), advent17b(input, 50000000, 0))
