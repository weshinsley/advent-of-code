source("../../shared/R/hash.R")

parse_file <- function(f = "../inputs/input_11.txt") {
  as.integer(strsplit(readLines(f), "\\s+")[[1]])
}

calc <- function(d, n) {
  transform <- hash_new()
  freq <- hash_new()
  delta <- hash_new()
  hash_put(transform, 0, 1)
  f <- table(d)
  hash_inc(freq, names(f), as.integer(f))
  
  for (i in seq_len(n)) {
    for (num in hash_keys(freq)) {
      count <- hash_get(freq, num)
      if (count == 0) {
        next
      }
      hash_put(freq, num, 0)
      if (hash_contains(transform, num)) {
        res <- hash_get(transform, num)[[1]]
        hash_inc(delta, res, count)
        
      } else {
        j <- as.numeric(num)
        if (nchar(j) %% 2 == 0) {
          half <- nchar(j) / 2
          res <- c(j %% 10^half, j %/% 10^half)
        } else {
          res <- j * 2024
        }
        hash_put(transform, num, list(res))
        hash_inc(delta, res, count)
      }
    }
    hash_copy(delta, freq)
    hash_set_all(delta, 0)
  }
  hash_sum(freq)
}

part1 <- function(d) {
  calc(d, 25)
}

part2 <- function(d) {
  calc(d, 75)
}

dig <- options()$digits
options(digits = 16)
d <- parse_file()
c(part1(d), part2(d))
options(digits = dig)
