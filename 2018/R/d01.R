advent1a <- function(nums) {
  sum(nums)
}

advent1b <- function(nums) {
  previous <- cumsum(nums)
  w <- which(duplicated(previous)) 
  while (length(w) == 0) {
    append <- cumsum(c(previous[length(previous)], nums))
    previous <- c(previous, append[2:length(append)])
    w <- which(duplicated(previous)) 
  }
  previous[w[1]]
}

input <- as.numeric(readLines("../inputs/input_1.txt"))
c(advent1a(input), advent1b(input))
