advent3a <- function(steps) {
  RIGHT <- 1
  UP <- 2
  LEFT <- 3
  DOWN <- 4

  x <- 0
  y <- 0
  current_direction <- RIGHT

  max_paces <- 1
  paces <- 1

  while (steps > 1) {
    if (current_direction == RIGHT) x <- x + 1
    else if (current_direction == UP) y <- y - 1
    else if (current_direction == LEFT) x <- x - 1
    else if (current_direction == DOWN) y <- y + 1
    paces <- paces - 1
    if (paces == 0) {
      current_direction = current_direction + 1
      if (current_direction == 5) current_direction <- RIGHT
      if (current_direction == LEFT || current_direction == RIGHT) {
        max_paces <- max_paces + 1
      }
      paces <- max_paces
    }
    steps <- steps - 1
  }
  abs(x) + abs(y)
}


advent3b <- function(threshold) {
  width <- 3
  height <- 3

  RIGHT <- 1
  UP <- 2
  LEFT <- 3
  DOWN <- 4
  current_direction <- RIGHT
  max_paces <- 1
  paces <- 1

  x <- 2
  y <- 2
  val <- 1
  mat <- matrix(data = 0, nrow = height, ncol = width)
  mat[y,x] <- val

  while (val < threshold) {
    if (current_direction == RIGHT) x <- (x + 1)
    else if (current_direction == UP) y <- (y - 1)
    else if (current_direction == LEFT) x <- (x - 1)
    else if (current_direction == DOWN) y <- (y + 1)
    if (x > width - 1 ) {
      mat <- cbind(mat, matrix(data = 0, nrow = height, ncol = 1))
      width <- width + 1
    } else if (x == 1) {
      mat <- cbind(matrix(data = 0, nrow=height, ncol=1), mat)
      x <- x + 1
      width <- width + 1
    } else if (y > height - 1) {
      mat <- rbind(mat, matrix(data=0, ncol = width, nrow = 1))
      height <- height + 1
    } else if (y == 1) {
      mat <- rbind(matrix(data=0, ncol=width, nrow=1), mat)
      y <- y + 1
      height <- height + 1
    }

    mat[y,x] <- sum(mat[(y-1):(y+1),(x-1):(x+1)])
    val <- mat[y,x]
    paces <- paces - 1
    if (paces == 0) {
      current_direction = current_direction + 1
      if (current_direction == 5) current_direction <- RIGHT
      if (current_direction == LEFT || current_direction == RIGHT) {
        max_paces <- max_paces + 1
      }
      paces <- max_paces
    }
  }
  val

}

input <- as.numeric(readLines("../inputs/input_3.txt"))
c(advent3a(input), advent3b(input))
