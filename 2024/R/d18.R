source("../../shared/R/matrix.R")
source("../../shared/R/paths.R")

parse_file <- function(f = "../inputs/input_18.txt") {
  read.csv(f, sep = ",", header = FALSE, col.names = c("x", "y"))
}

part1 <- function(d, w = 71, h = 71, n = 1024) {
  m <- pad_matrix(matrix(Inf, nrow = h, ncol = w), 1, -1)
  m[cbind(d$y[1:n] + 2, d$x[1:n] + 2)] <- -1
  shortest_path_bfs(m, c(2, 2), c(w + 1, h + 1))$best
}

part2 <- function(d, w = 71, h = 71, n = 1024) {
  chop <- c(n + 1, nrow(d))
  while (chop[1] <= chop[2]) {
    mid <- sum(chop) %/% 2
    res <- part1(d, w, h, mid)
    if (!is.infinite(res)) {
      chop[1] <- mid + 1
    } else {
      chop[2] <- mid - 1
    }
  }
  return(sprintf("%d,%d",d$x[max(chop)], d$y[max(chop)]))
}

d <- parse_file()
c(part1(d), part2(d))
