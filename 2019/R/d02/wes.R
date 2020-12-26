source("d09/wes_computer.R")

part2 <- function(file) {
  df <- data.frame(i = rep(0:99, 100),
                   j = rep(0:99, each = 100))
  res <- which(unlist(lapply(seq_len(nrow(df)), function(x)
    IntComputer$new(file)$poke(1,df$i[x])$poke(2,df$j[x])$run()$peek(0) == 19690720)))

  (df$i[res] * 100) + df$j[res]

}

expect_result <- function(prog, result, test, verbose = FALSE) {
  ic <- IntComputer$new(program = prog)$run(verbose)
  ic_res <- unlist(lapply(0:(length(result)-1), ic$peek))
  if (!all(ic_res == result)) message(sprintf("Test %s failed - got %s", test, paste(ic_res, collapse = ',')))
}

test <- function() {
  expect_result(c(1,9,10,3,2,3,11,0,99,30,40,50), c(3500,9,10,70,2,3,11,0,99,30,40,50), "1")
  expect_result(c(1,0,0,0,99), c(2,0,0,0,99), "2")
  expect_result(c(2,3,0,3,99), c(2,3,0,6,99), "3")
  expect_result(c(2,4,4,5,99,0), c(2,4,4,5,99,9801), "4")
  expect_result(c(1,1,1,4,99,5,6,0,99), c(30,1,1,4,2,5,6,0,99), "5")
}

test()
message(sprintf("Part 1: %d", IntComputer$new("d02/wes-input.txt")$reset()$poke(1,12)$poke(2,2)$run()$peek(0)))
message(sprintf("Part 2: %d", part2("d02/wes-input.txt")))
