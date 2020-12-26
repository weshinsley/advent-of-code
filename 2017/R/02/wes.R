test <- function(x,y) { if (x==y) "PASS" else "FAIL" }

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

input <- readLines("input.txt")
for (line in seq_along(input)) {
  input[line] <- strsplit(input[[line]], "\t")
}
input <- lapply(input, function(x) as.numeric(x))

test(advent2a(list(list(5,1,9,5),list(7,5,3),list(2,4,6,8))), 18)
advent2a(input)

test(advent2b(list(list(5,9,2,8), list(9,4,7,3), list(3,8,6,5))), 9)
advent2b(input)

