source("wes_computer.R")

run <- function(ic) {
  ic$run()
  s <- NULL
  while (ic$output_available()) 
    s <- c(s, ic$read_output())
  paste(s, collapse = ",")
}

c(sprintf("Part 1: %s", 
  run(IntComputer$new(file = "../inputs/input_9.txt")$add_input(1))))
