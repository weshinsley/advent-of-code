source("wes_computer.R")

data_frame <- function(...) { data.frame(stringsAsFactors = FALSE, ...) }

solve <- function(ic, start, draw) {
  ic$reset()
  rx <- 0
  ry <- 0
  rd <- 1
  dx <- c(0, 1, 0, -1)
  dy <- c(-1, 0, 1, 0)

  history <- data_frame()
  while (ic$get_status() != ic$HALT) {
    lookup <- which(history$x == rx & history$y == ry)
    if (length(lookup) > 0) {
      ic$add_input(history$pix[lookup])

    } else {
      pixel <- 0
      if (nrow(history) == 0) pixel <- start
      history <- rbind(history, data_frame(
        x = rx, y = ry, pix = pixel))
      ic$add_input(pixel)
    }

    ic$run()

    if (ic$output_available()) {
      col <- ic$read_output()
      history$pix[history$x == rx & history$y == ry] <- col
      lr <- ic$read_output()
      if (lr == 0) rd <- rd - 1
      else if (lr == 1) rd <- rd + 1
      if (rd == 0) rd <- 4
      if (rd == 5) rd <- 1
      rx <- rx + dx[rd]
      ry <- ry + dy[rd]
    }
  }

  if (draw) {
    minx <- min(history$x)
    maxx <- max(history$x)
    miny <- min(history$y)
    maxy <- max(history$y)
    for (y in miny:maxy) {
      s <- rep(" ", 1 + (maxx - minx))
      xs <- history$x[history$y == y & history$pix == 1]
      s[xs + 1] <- '@'
      message(sprintf("%s", s))
    }
  }
  nrow(history)
}

ic <- IntComputer$new("../inputs/input_11.txt")
message(sprintf("%d", solve(ic, 0, FALSE)))
message("\n")
invisible(solve(ic, 1, TRUE))
