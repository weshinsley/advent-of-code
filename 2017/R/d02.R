advent2a <- function(s) {
  biggest <- unlist(lapply(s, function(x) max(unlist(x))))
  smallest <- unlist(lapply(s, function(x) min(unlist(x))))
  sum(biggest - smallest)
  
}

is_even <- function(x) {
  as.integer(x) == x
}

advent2b_helper <- function(s) {
  answer <- -1
  for (x in seq_along(s)) {
    if (sum(is_even(s[x] / s)) > 1) {
      res <- s[which(is_even(s[x] / s))]
      res <- res[res!=s[x]]
      answer <- (s[x] / res)
      break
    }
  }
  answer
}

advent2b <- function(s) {
  sum(unlist(lapply(s, function(x) advent2b_helper(unlist(x)))))
}

input <- readLines("../inputs/input_2.txt")
for (line in seq_along(input)) {
  input[line] <- strsplit(input[[line]], "\t")
}

input <- lapply(input, function(x) as.numeric(x))
c(advent2a(input), advent2b(input))

