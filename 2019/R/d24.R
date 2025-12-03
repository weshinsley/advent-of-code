library(testthat)

pow2 <- c(1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768,
         65536,131072,262144,524288,1048576,2097152,4194304,8388608,16777216)

to_long <- function(s) {
  s <- strsplit(paste(s, collapse = ""), "")[[1]]
  total <- sum(pow2 * (s == '#'))
}

update1 <- function(d) {
  d2 <- d
  for (i in seq_len(25)) {
    neighbours <- 0
    y <- (i - 1) %/% 5
    x <- (i - 1) %% 5
    bug <- bitwAnd(d, pow2[i]) > 0
    if (x > 0) neighbours <- neighbours + (bitwAnd(d, pow2[i - 1]) > 0)
    if (x < 4) neighbours <- neighbours + (bitwAnd(d, pow2[i + 1]) > 0)
    if (y > 0) neighbours <- neighbours + (bitwAnd(d, pow2[i - 5]) > 0)
    if (y < 4) neighbours <- neighbours + (bitwAnd(d, pow2[i + 5]) > 0)
    if ((bug) & (neighbours != 1)) d2 <- d2 - pow2[i]
    else if ((!bug) & (neighbours %in% c(1,2))) d2 <- d2 + pow2[i]
  }
  d2
}

solve1 <- function(input) {
  input <- to_long(input)
  history <- rep(0, 33554432)
  while (history[(input + 1)] == 0) {
    history[input + 1] <- 1
    input <- update1(input)
  }
  input
}

#############################################

neighbour_same_level <- list(
  c(2,6),c(1,7,3),c(2,8,4),c(3,9,5),c(4,10),
  c(1,7,11),c(2,6,8,12),c(3,7,9),c(4,8,10,14),c(5,9,15),
  c(6,12,16),c(7,11,17),c(),c(9,15,19),c(10,14,20),
  c(11,17,21),c(12,16,18,22),c(17,19,23),c(14,18,20,24),c(15,19,25),
  c(16,22),c(17,21,23),c(18,22,24),c(19,23,25),c(20,24))

neighbour_next_level = list(
  c(),c(),c(),c(),c(),
  c(),c(),c(1,2,3,4,5),c(),c(),
  c(),c(1,6,11,16,21),c(),c(5,10,15,20,25),c(),
  c(),c(),c(21,22,23,24,25),c(),c(),
  c(),c(),c(),c(),c())

neighbour_prev_level <- list(
  c(8,12),c(8),c(8),c(8),c(8,14),
  c(12),c(),c(),c(),c(14),
  c(12),c(),c(),c(),c(14),
  c(12),c(),c(),c(),c(14),
  c(12,18),c(18),c(18),c(18),c(14,18))


min_lev <- 0
max_lev <- 0

update2 <- function(world) {
  world2 <- world
  for (lev in min_lev:max_lev) {
    for (i in seq_len(25)) {
      neighbours <- 0
      for (j in neighbour_same_level[[i]])
        neighbours <- neighbours + (bitwAnd(world[lev], pow2[j]) > 0)
      for (j in neighbour_next_level[[i]])
        neighbours <- neighbours + (bitwAnd(world[lev + 1], pow2[j]) > 0)
      for (j in neighbour_prev_level[[i]])
        neighbours <- neighbours + (bitwAnd(world[lev - 1], pow2[j]) > 0)

      bug <- (bitwAnd(world[lev], pow2[i]) > 0)
      if ((bug) & (neighbours != 1)) world2[lev] <- world2[lev] - pow2[i]
      else if ((!bug) & (neighbours %in% c(1,2))) {
        world2[lev] <- world2[lev] + pow2[i]
        min_lev <<- min(min_lev, lev-1)
        max_lev <<- max(max_lev, lev+1)
      }
    }
  }
  world2
}

solve2 <- function(state, iters) {
  state <- to_long(state)
  world = rep(0, iters * 2)
  max_lev <<- iters - 1
  min_lev <<- iters + 1
  world[iters] <- state
  while (iters > 0) {
    world <- update2(world)
    iters <- iters - 1
  }

  count <- 0
  for (i in min_lev:max_lev) {
    for (j in seq_len(25)) {
      count <- count + (bitwAnd(world[i], pow2[j]) > 0)
    }
  }
  count
}

c(solve1(readLines("../inputs/input_24.txt")),
  solve2(readLines("../inputs/input_24.txt"),200))
