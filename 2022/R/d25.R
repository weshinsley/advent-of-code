parse <- function(f) {
  readLines(f)
}

snafu_to_normal <- function(n) {
  n <- strsplit(n, "")[[1]]
  x <- 1
  t <- 0
  for (j in length(n):1) {
    if (n[[j]] == "2")  t <- t + (x * 2)
    else if (n[[j]] == "1") t <- t + (x * 1)
    else if (n[[j]] == "-") t <- t - x
    else if (n[[j]] == "=") t <- t - (x * 2)
    x <- x * 5
  }
  t
}

normal_to_snafu <- function(n) {
  if (n == 0) ""
  else if ((n %% 5) == 0) paste0(normal_to_snafu(n %/% 5), "0")
  else if ((n %% 5) == 1) paste0(normal_to_snafu(n %/% 5), "1")
  else if ((n %% 5) == 2) paste0(normal_to_snafu(n %/% 5), "2")
  else if ((n %% 5) == 3) paste0(normal_to_snafu((n + 2) %/% 5), "=")
  else if ((n %% 5) == 4) paste0(normal_to_snafu((n + 1) %/% 5), "-")
}

part1 <- function(d) {
  tot <- sum(unlist(lapply(d, snafu_to_normal)))
  normal_to_snafu(tot)
}

d <- parse("../inputs/input_25.txt")
part1(d)
