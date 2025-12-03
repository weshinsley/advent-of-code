source("wes_computer.R")

solve <- function(ic, part2 = FALSE) {
  ic$reset()$run()
  while (ic$output_available()) ic$read_output()

  instr <- "NOT C J\nNOT B T\nOR T J\nNOT A T\nOR T J\nAND D J\n"
  if (!part2) extra <- "WALK\n"
  else extra <- "OR E T\nOR H T\nAND T J\nRUN\n"

  ic$add_input(utf8ToInt(sprintf("%s%s", instr, extra)))
  ic$run()
  for (i in 0:12) ic$read_output()
  ic$read_output()
}

ic <- IntComputer$new("../inputs/input_21.txt")
c(solve(ic), solve(ic, TRUE))
