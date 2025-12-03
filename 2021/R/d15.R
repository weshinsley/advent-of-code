parse_data <- function(f) {
  d <- as.integer(strsplit(paste0(readLines(f), collapse = ""), "")[[1]])
  matrix(d, ncol = sqrt(length(d)))
}

part2_matrix <- function(d) {
  size <- nrow(d)
  d2 <- matrix(0L, nrow = size * 5, ncol = size * 5 )
  for (x in 1:5) {
    for (y in 1:5) {
      x1 <- 1 + ((x-1) * size)
      x2 <- x * size
      y1 <- 1 + ((y-1) * size)
      y2 <- y * size
      d2[x1:x2, y1:y2] <- d + ((x - 1L) + (y - 1L))
    }
  }
  d2[d2 > 9L] <- d2[d2 > 9L] - 9L
  d2[d2 > 9L] <- d2[d2 > 9L] - 9L
  d2
}

part1 <- function(d, part2 = FALSE) {
  if (part2) {
    d <- part2_matrix(d)
  } 
  
  size <- nrow(d)
  queue <- c(1L, 1L, rep(0L, 100 * size * size))
  tail <- 4L
  best <- sum(d[, 1]) + sum(d[1, ]) - d[1, 1] - d[size, 1]
  hist <- matrix(best, nrow = size, ncol = size)
  hist[1, 1] <- 0L
  hist[hist < 0L] <- best
  size2 <- size + size
  
  dx <- c(1L, 0L, -1L, 0L)
  dy <- c(0L, 1L, 0L, -1L)
  dd <- 1L:4L
  
  while (tail > 1L) {
    tail <- tail - 3L
    x <- queue[tail]
    y <- queue[tail + 1L]
    dist <- queue[tail + 2L]
    

    for (dir in dd) {
      nx <- x + dx[dir]
      ny <- y + dy[dir]
      
      if ((nx == 0L) || (nx > size) || (ny == 0L) || (ny > size))
        next
      
      if ((dist + size2 - nx - ny) >= best) {
        next
      }
      
      nd <- dist + d[nx, ny]
      if (nd < hist[nx, ny]) {
        hist[nx, ny] <- nd
        if ((nx < size) | (ny < size)) {
          queue[tail] <- nx
          queue[tail + 1L] <- ny
          queue[tail + 2L] <- nd
          tail <- tail + 3L
        } else {
          best <- nd
        }
      }
    }
  }
  hist[size, size]
}

part2 <- function(d) {
  part1(d, TRUE)
} 

d <- parse_data("../inputs/input_15.txt")
c(part1(d), part2(d))
