advent6a <- function(points, min_x, max_x, min_y, max_y) {
  grid <- matrix(ncol = 1 + (max_x - min_x), nrow = 1 + (max_y - min_y), data = 0)
  
  closest <- function(i, j) {
    dist <- abs(points$x - i) + abs(points$y - j)
    if (length(dist[dist == min(dist)]) > 1) 
      0
    else which(dist == min(dist))
  }
  
  for (j in (min_y:max_y)) 
    for (i in (min_x:max_x))
      grid[1+(j-min_y), 1+(i-min_x)] <- closest(i, j)
  
  points$infinite <- FALSE
  
  for (i in 0:(max_x+1)) {
    v <- closest(i, 1)
    if (v>=0) points$infinite[v] <- TRUE
    v <- closest(i, max_y)
    if (v>=0) points$infinite[v] <- TRUE
  }
  
  for (j in 0:(max_y+1)) {
    v <- closest(0, j)
    if (v>=0) points$infinite[v] <- TRUE
    v <- closest(max_x+1, j)
    if (v>=0) points$infinite[v] <- TRUE
  }
  
  best <- 0
  for (i in seq_len(nrow(points))) {
    if (!points$infinite[i]) {
      area <- sum(grid == i)
      if (area > best) best <- area
    }
  }
  best
}

advent6b <- function(points, min_x, max_x, min_y, max_y) {
  r <- 0
  for (j in (min_y:max_y))
    for (i in (min_x:max_x)) {
      d <- sum(abs(points$x - i) + abs(points$y - j))
      if (d < 10000) r<- r + 1
    }
  r
}

input <- read.csv("../inputs/input_6.txt", header = FALSE)
names(input) <- c("x","y")
min_x <- min(input$x)
max_x <- max(input$x)
min_y <- min(input$y)
max_y <- max(input$y)
c(advent6a(input, min_x, max_x, min_y, max_y), 
  advent6b(input, min_x, max_x, min_y, max_y))
