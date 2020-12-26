source("d09/wes_computer.R")

run <- function(ic) {
  ic$run()
  s <- NULL
  while (ic$output_available()) 
    s <- c(s, ic$read_output())
  paste(s, collapse = ",")
}

test <- function() {
  ic <- IntComputer$new(program = c(109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99))
  expect_equal(run(ic), "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99")
  ic <- IntComputer$new(program = c(1102,34915192L,34915192L,7,4,7,99,0))
  expect_equal(run(ic), "1219070632396864")
  ic <- IntComputer$new(program = c(104,1125899906842624,99))
  expect_equal(run(ic), "1125899906842624")
}

test()
message(sprintf("Part 1: %s", 
  run(IntComputer$new(file = "d09/wes-input.txt")$add_input(1))))
