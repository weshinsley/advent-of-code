library(crayon)

solve1 <- function(d) {
  for (i in seq_len(length(d) - 1)) {
    for (j in (i+1):length(d)) {
      if (d[i] + d[j] == 2020) {
        return(d[i] * d[j])
      }
    }
  }
}

solve2 <- function(d) {
  for (i in seq_len(length(d) - 2)) {
    for (j in (i + 1):(length(d) - 1)) {
      for (k in (j + 1):length(d)) {
        if (d[i] + d[j] + d[k] == 2020) {
          return(d[i] * d[j] * d[k])
        }
      }
    }
  }
}

test <- as.integer(readLines("../Java/d01/test_514579_241861950.txt"))
stopifnot(solve1(test) == 514579)
stopifnot(solve2(test) == 241861950)

wes <- as.integer(readLines("../Java/d01/wes-input.txt"))
cat(red("\nAdvent of Code 2020 - Day 01\n"))
cat(blue("----------------------------\n\n"))
cat("Part 1:", green(solve1(wes)), "\n")
cat("Part 2:", green(solve2(wes)), "\n")
    
