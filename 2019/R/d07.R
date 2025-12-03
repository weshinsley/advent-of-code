source("wes_computer.R")

permute <- function(nums, current = NULL) {
  if (length(nums) == 0) return(list(current))
  res <- list()
  for (i in nums) {
    res <- c(res, permute(nums[nums!=i], c(current, i)))
  }
  res
}

part1 <- function(amps, phases) {
  max <- 0
  for (x in seq_along(phases)) {
    phase <- phases[[x]]
    signal <- 0
    for (a in 1:5) {
      amps[[a]]$reset()$add_input(c(phase[a], signal))$run()
      signal <- amps[[a]]$read_output()
    }
    max <- max(max, signal)
  }
  max
}

part2 <- function(amps, phases) {
  max <- 0
  for (x in seq_along(phases)) {
    phase <- phases[[x]] + 5
    signal <- 0
    for (a in 1:5) {
      amps[[a]]$reset()$add_input(phase[a])
    }
    while (amps[[5]]$get_status() != amps[[5]]$HALT) {
      
      for (a in 1:5) {
        signal <- amps[[a]]$add_input(signal)$run()$read_output()
      }
    }
    max <- max(max, signal)
  }
  max
}

launch <- function(amps, phases, part, prog) {
  for (i in 1:5) amps[[i]] <- IntComputer$new(program = prog)
  if (part == 1) part1(amps, phases)
  else part2(amps, phases)
}

amps <- list()
phases <- permute(c(0,1,2,3,4))
for (i in 1:5) amps[[i]] <- IntComputer$new(file = "../inputs/input_7.txt")
c(part1(amps, phases), part2(amps, phases))
