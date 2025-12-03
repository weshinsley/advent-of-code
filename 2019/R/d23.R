source("wes_computer.R")

solve <- function(fn, part1 = TRUE) {
  network <- list()
  for (i in 1:50) {
    network[[i]] <- IntComputer$new(fn)
    network[[i]]$add_input(i - 1)$run()
  }
  nat_x <- -1
  nat_y <- -1
  last_nat_y <- -2
  
  while (TRUE) {
    for (i in 1:50) {
      if (network[[i]]$input_size() == 0) network[[i]]$add_input(-1)
      network[[i]]$run()
      while (network[[i]]$output_available()) {
        to <- network[[i]]$read_output()
        dx <- network[[i]]$read_output()
        dy <- network[[i]]$read_output()
        if (to == 255) {
          if (part1) return(dy)
          else {
            nat_x <- dx
            nat_y <- dy
          }
        } else {
          network[[to + 1]]$add_input(c(dx,dy))
        }
      }
    }
    
    if (!part1) {
      count_idle <- 0
      for (i in 1:50)
        if (network[[i]]$input_size() == 0) count_idle <- count_idle + 1
      
      if (count_idle == 50) {
        network[[1]]$add_input(c(nat_x, nat_y))
        if (nat_y == last_nat_y) return(nat_y)
        last_nat_y <- nat_y
      }
    }
  }
}

c(solve("../inputs/input_23.txt"),
  solve("../inputs/input_23.txt", FALSE))
