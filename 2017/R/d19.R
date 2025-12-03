advent19a <- function(input, return_steps = FALSE) {
  DOWN <- 1
  LEFT <- 2
  UP <- 3
  RIGHT <- 4

  input <- lapply(input, function(x) unlist(strsplit(x, "")))
  y <- 1
  x <- which(input[[y]]!=" ")
  direction  <- DOWN
  track <- ""
  steps <- 0
  while (input[[y]][x] != ' ') {
    steps <- steps + 1
    y <- y + (direction == DOWN) - (direction == UP)
    x <- x + (direction == RIGHT) - (direction == LEFT)

    if (input[[y]][x] == '+') {
      if (direction %in% c(UP,DOWN)) {
        if (input[[y]][x-1] != ' ') {
          direction <- LEFT
        } else {
          direction <- RIGHT
        }
      } else {
        if (input[[y-1]][x] != ' ') {
          direction <- UP
        } else {
          direction <- DOWN
        }
      }

    } else if (!(input[[y]][x] %in% c("|","-"," "))) {
      track <- c(track, input[[y]][x])
    }
  }
  if (return_steps) {
    steps
  } else {
    paste(track, collapse="")
  }
}

advent19b <- function(input) {
  advent19a(input, return_steps=TRUE)
}

input <- readLines("../inputs/input_19.txt")
c(advent19a(input), advent19b(input))
