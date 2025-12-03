dist <- function(x,y) {
  steps <- 0

  while ((x!=0) || (y!=0)) {
    if (x==0) {
      steps <- steps + abs(y/2)
      y <- 0
    } else {
      if ((x>0) && (y>=0)) {
        x <- x - 1
        y <- y - 1
      } else if ((x>0) && (y<0)) {
        x <- x - 1
        y <- y + 1
      } else if ((x<0) && (y<=0)) {
        x <- x + 1
        y <- y + 1
      } else if ((x<0) && (y>0)) {
        x <- x + 1
        y <- y - 1
      }
      steps <- steps + 1
    }
  }
  steps
}

advent10a <- function(input, find_max = FALSE) {
  moves <- unlist(strsplit(input,","))
  x <- 0
  y <- 0
  max_dist <- 0
  for (move in moves) {
    if (move == 'n') y <- y - 2
    else if (move == 's') y <- y + 2
    else if (move == 'se') {
      y <- y + 1
      x <- x + 1
    } else if (move == 'sw') {
      y <- y + 1
      x <- x - 1
    } else if (move == 'ne') {
      y <- y - 1
      x <- x + 1
    } else if (move == 'nw') {
      y <- y - 1
      x <- x - 1
    }
    if (find_max) {
      max_dist <- max(max_dist, dist(x,y))
    }
  }

  max(dist(x,y),max_dist)
}

advent10b <- function(input) {
  advent10a(input, TRUE)
}

input <- readLines("../inputs/input_11.txt")
c(advent10a(input), advent10b(input))

