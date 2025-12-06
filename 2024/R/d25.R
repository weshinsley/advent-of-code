source("../../shared/R/matrix.R")

parse_file <- function(f = "../inputs/input_25.txt") {
  d <- readLines(f)
  sp <- c(which(d == ""), length(d) + 1)
  m <- list()
  for (i in seq_along(sp)) {
    m[[i]] <- strings_to_char_matrix(d[(sp[i]-7):(sp[i]-1)])
    m[[i]] <- matrix(m[[i]] == "#", nrow = 7, ncol = 5)
  }
  m
}

part1 <- function(d) {
  tot <-0
  keys <- list()
  locks <- list()
  for (i in seq_along(d)) {
    heights <- colSums(d[[i]]) - 1
    if (sum(d[[i]][1, ]) == 5) { 
      locks[[length(locks) + 1]] <- heights
    } else { 
      keys[[length(keys) + 1]] <- heights
    }
  }
  
  for (k in keys)
    for (v in locks)
      tot <- tot + all(k + v <= 5)
  tot
}

d <- parse_file()
part1(d)
