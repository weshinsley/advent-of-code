source("d09/wes_computer.R")

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

test <- function(amps, phases) {
  expect_equal(launch(amps, phases, 1,
                       c(3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0)),
                         43210)
  expect_equal(launch(amps, phases, 1,
                       c(3,23,3,24,1002,24,10,24,1002,23,-1,23,
                         101,5,23,23,1,24,23,23,4,23,99,0,0)), 54321)
  expect_equal(launch(amps, phases, 1,
                       c(3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
                         1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0)), 65210)

  expect_equal(launch(amps, phases, 2,
                      c(3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,
                        27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5)), 139629729)

  expect_equal(launch(amps, phases, 2,
                      c(3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,
                        -5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,
                        53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10)), 18216)

}

amps <- list()
phases <- permute(c(0,1,2,3,4))
test(amps, phases)
for (i in 1:5) amps[[i]] <- IntComputer$new(file = "d07/wes-input.txt")
message(sprintf("Part1: %d", part1(amps, phases)))
message(sprintf("Part2: %d", part2(amps, phases)))
