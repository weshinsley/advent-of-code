source("wes_computer.R")

solve <- function(ic) {
  blocks <- 0
  
  while (ic$output_available()) {
    x <- ic$read_output()
    y <- ic$read_output()
    z <- ic$read_output()
    blocks <- blocks + (z == 2)
    if (z == 4) bx <- x
    else if (z == 3) px <- x
  }
  res <- blocks
  score <- 0
  ic$poke(0, 2)
  ic$run()
  
  while (TRUE) {
    if (blocks == 0) return(c(res, score))
    if (bx > px) ic$add_input(1)
    else if (bx < px) ic$add_input(-1)
    else ic$add_input(0)
    ic$run()
    while (ic$output_available()) {
      x <- ic$read_output()
      y <- ic$read_output()
      z <- ic$read_output()
      if ((x == -1) && (y == 0)) {
        score <- z
        blocks <- blocks - 1
      } else {
        if (z == 4) bx <- x
        else if (z == 3) px <- x
      }
    }
  }
}
  
solve(IntComputer$new("../inputs/input_13.txt")$poke(0, 2)$run())
