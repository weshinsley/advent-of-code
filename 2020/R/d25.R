d <- as.integer(readLines("../inputs/input_1.txt"))

crack <- function(subj, pubk) {
  x <- 1
  loops <- 0
  while (x != pubk) {
    x <- (x * subj) %% 20201227
    loops <- loops + 1
  }
  loops
}

encrypt <- function(subj, loops) {
  x <- 1
  while (loops >0) {
    x <- (x * subj) %% 20201227
    loops <- loops - 1
  }
  x
}

encrypt(d[1], crack(7, d[2]))
