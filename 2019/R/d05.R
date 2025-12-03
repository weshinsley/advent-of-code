source("wes_computer.R")

run <- function(program, input) {
  wc <- IntComputer$new(program = program)$add_input(input)$run()
  s <- NULL
  while (wc$output_available()) {
    s <- c(s, wc$read_output())
  }
  as.numeric(s)
}

program <- as.numeric(unlist(strsplit(readLines("../inputs/input_5.txt"), ",")))
c(run(program, 1)[10], run(program, 5))
