d <- strsplit(readLines("../inputs/input_2.txt"), "")

solve <- function(part1 = TRUE) {
  T <- if(part1) list(
    L = c(1,1,2,4,4,5,7,7,8),
    U = c(1,2,3,1,2,3,4,5,6),
    D = c(4,5,6,7,8,9,7,8,9),
    R = c(2,3,3,5,6,6,8,9,9)
  ) else list(
    L = c(1,2,2,3,5,5,6,7,8,10,10,11,13),
    U = c(1,2,1,4,5,2,3,4,9,6,7,8,11),
    D = c(3,6,7,8,5,10,11,12,9,10,13,12,13),
    R = c(1,3,4,4,6,7,8,9,9,11,12,12,13))

  n <- 5
  paste(unlist(lapply(d, function(x) {
    for (j in seq_along(x)) {
      n <- T[[x[j]]][n]
    }
    ifelse(n >= 10, c("A","B","C","D")[n - 9], n)
  })), collapse = "")
}

c(solve(), solve(FALSE))
