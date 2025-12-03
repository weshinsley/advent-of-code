source("wes_computer.R")

get_pix <- function(ic, x, y) {
  ic$reset()$add_input(x)$add_input(y)$run()$read_output() == 1
}

solve1 <- function(ic) {
  count <- 0
  left_most <- 0
  for (y in 0:49) {
    positive <- FALSE
    for (x in left_most:49) {
      pix <- as.integer(get_pix(ic, x, y))
      if ((pix == 1) && (!positive)) {
        positive <- TRUE
        left_most <- x
      }
      if ((pix == 0) && (positive)) break
      count <- count + pix
    }
  }
  count
}

solve2 <- function(ic) {
  # Compensate for how slow my int computer is.
  right <- 990
  y <- 1000
  while (!get_pix(ic, right, y)) right <- right + 1
  while (get_pix(ic, right, y)) right <- right + 1
  right <- right - 1
  while (TRUE) {
    y <- y + 1
    while (get_pix(ic, right, y)) right <- right + 1
    right <- right - 1
    if ((get_pix(ic, right - 99, y)) && 
        (get_pix(ic, right - 99, y + 99)) && 
        (get_pix(ic, right, y + 99))) {
          return(((right - 99) * 10000) + y)
      }
    }
  }

ic <- IntComputer$new("../inputs/input_19.txt")
c(solve1(ic), solve2(ic))
