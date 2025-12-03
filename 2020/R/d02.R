valid1 <- function(d) {
  d <- strsplit(d, " ")[[1]]
  char <- substr(d[2], 1, 1)
  xy <- as.integer(strsplit(d[1], "-")[[1]])
  freq <- sum(strsplit(d[3], "")[[1]] == char)
  (freq >= xy[1] & freq <= xy[2])
}

valid2 <- function(d) {
  d <- strsplit(d, " ")[[1]]
  xy <- as.integer(strsplit(d[1], "-")[[1]])
  char <- substr(d[2], 1, 1)
  pwd <- strsplit(d[3], "")[[1]]
  ((pwd[xy[1]] == char) + (pwd[xy[2]] == char) == 1)
}

wes <- readLines("../inputs/input_2.txt")
c(sum(unlist(lapply(wes, valid1))),
  sum(unlist(lapply(wes, valid2))))
