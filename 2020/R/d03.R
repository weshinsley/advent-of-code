solve <- function(d, dx, dy) {
  ys <- 1 + seq(from = dy, by = dy, to = length(d) - 1)
  xs <- 1 + (dx * seq_along(ys)) %% length(d[[1]])
  as.numeric(sum(unlist(lapply(seq_along(xs), 
    function(i) d[[ys[i]]][xs[i]])) == '#'))
}

solve2 <- function(d) {
  prod(c(solve(d, 1, 1), solve(d, 3, 1), solve(d, 5, 1), 
         solve(d, 7, 1), solve(d, 1, 2)))
}

load <- function(f) {
  lapply(readLines(f), function(x) strsplit(x, "")[[1]])
}

wes <- load("../inputs/input_3.txt")
c(solve(wes, 3, 1), solve2(wes))