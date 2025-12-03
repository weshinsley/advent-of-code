expand_left <- function(grid) {
  for (i in seq_len(length(grid))) {
    grid[[i]] <- c(".",grid[[i]])
  }
  grid
}

expand_right <- function(grid) {
  for (i in seq_len(length(grid))) {
    grid[[i]] <- c(grid[[i]],".")
  }
  grid
}

expand_up <- function(grid) {
  x <- rep(".", length(grid[[1]]))
  grid <- c(list(x), grid)
  grid
}

expand_down <- function(grid) {
  x <- rep(".", length(grid[[1]]))
  grid <- c(grid, list(x))
  grid
}

advent22a <- function(data, n, part_b = FALSE) {
  grid <- lapply(data, function(x) unlist(strsplit(x, "")))
  xsize <- length(grid[[1]])
  ysize <- length(grid)
  x <- 1 + floor(xsize / 2)
  y <- 1 + floor(ysize / 2)
  UP <- 1
  RIGHT <- 2
  DOWN <- 3
  LEFT <- 4
  current_direction <- UP
  inf_burst <- 0

  while (n > 0) {
    if (!part_b) {
      if (grid[[y]][x] == '#') {
        current_direction <- (current_direction %% 4) + 1
        grid[[y]][x] <- '.'
      } else {
        current_direction <- current_direction - 1
        if (current_direction == 0) current_direction <- 4
        grid[[y]][x] <- '#'
        inf_burst <- inf_burst + 1
      }
    } else {
      if (grid[[y]][x] == '.') {
        current_direction <- current_direction - 1
        if (current_direction == 0) current_direction <- 4
        grid[[y]][x] <- 'W'

      } else if (grid[[y]][x] == 'W') {
        grid[[y]][x] <- '#'
        inf_burst <- inf_burst + 1

      } else if (grid[[y]][x] == '#') {
        current_direction <- (current_direction %% 4) + 1
        grid[[y]][x] <- 'F'
      } else if (grid[[y]][x] == 'F') {
        current_direction <- (current_direction %% 4) + 1
        current_direction <- (current_direction %% 4) + 1
        grid[[y]][x] <- '.'
      }
    }
    x <- x + (current_direction == RIGHT) - (current_direction == LEFT)
    y <- y + (current_direction == DOWN) - (current_direction == UP)
    if (x == 0) {
      grid <- expand_left(grid)
      x <- 1
    }
    if (y == 0) {
      grid <- expand_up(grid)
      y <- 1
    }
    if (x == xsize) grid <- expand_right(grid)
    if (y == ysize) grid <- expand_down(grid)
    xsize <- length(grid[[1]])
    ysize <- length(grid)
    n <- n - 1

  }
  inf_burst
}

advent22b <- function(data, n) {
  advent22a(data, n, TRUE)
}

data <- readLines("../inputs/input_22.txt")
c(advent22a(data, 10000), advent22b(data, 10000000))

