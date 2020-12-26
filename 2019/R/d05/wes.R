source("d09/wes_computer.R")
library(testthat)

run <- function(program, input) {
  wc <- IntComputer$new(program = program)$add_input(input)$run()
  s <- NULL
  while (wc$output_available()) {
    s <- c(s, wc$read_output())
  }
  as.numeric(s)
}


test <- function() {
  expect_equal(run(c(3,9,8,9,10,9,4,9,99,-1,8), 7), 0)
  expect_equal(run(c(3,9,8,9,10,9,4,9,99,-1,8), 8), 1)
  expect_equal(run(c(3,9,8,9,10,9,4,9,99,-1,8), 9), 0)
  expect_equal(run(c(3,9,7,9,10,9,4,9,99,-1,8), 7), 1)
  expect_equal(run(c(3,9,7,9,10,9,4,9,99,-1,8), 8), 0)
  expect_equal(run(c(3,9,7,9,10,9,4,9,99,-1,8), 9), 0)
  expect_equal(run(c(3,3,1108,-1,8,3,4,3,99), 7), 0)
  expect_equal(run(c(3,3,1108,-1,8,3,4,3,99), 8), 1)
  expect_equal(run(c(3,3,1108,-1,8,3,4,3,99), 9), 0)
  expect_equal(run(c(3,3,1107,-1,8,3,4,3,99), 7), 1)
  expect_equal(run(c(3,3,1107,-1,8,3,4,3,99), 8), 0)
  expect_equal(run(c(3,3,1107,-1,8,3,4,3,99), 9), 0)
  expect_equal(run(c(3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9), 0), 0)
  expect_equal(run(c(3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9), 1), 1)
  expect_equal(run(c(3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9), 2), 1)
  expect_equal(run(c(3,3,1105,-1,9,1101,0,0,12,4,12,99,1), 0), 0)
  expect_equal(run(c(3,3,1105,-1,9,1101,0,0,12,4,12,99,1), 1), 1)
  expect_equal(run(c(3,3,1105,-1,9,1101,0,0,12,4,12,99,1), 2), 1)
  
  prog <- c(3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,
            0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,
            4,20,1105,1,46,98,99)
  
  expect_equal(run(prog, 7), 999)
  expect_equal(run(prog, 8), 1000)
  expect_equal(run(prog, 9), 1001)
}

test()
program <- as.numeric(unlist(strsplit(readLines("d05/wes-input.txt"), ",")))
message(sprintf("Part 1: %d",run(program, 1)[10]))
message(sprintf("Part 2: %d", run(program, 5)))
