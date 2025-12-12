parse_file <- function(f = "../inputs/input_7.txt") {
  lapply(readLines(f), function(x) strsplit(x, "")[[1]])
}

solve <- function(d) {
  xs <- which(d[[1]] == "S") 
  y <- 2
  splits <- 0
  freq <- rep(0, length(d[[1]]))
  freq[xs] <- 1
  while (y < length(d)) {
    freq2 <- rep(0, length(d[[1]]))
    y <- y + 1
    newx <- c()
    for (x in xs) {
      if (d[[y]][x] == "^") {
        splits <- splits + 1
        newx <- c(newx, x - 1, x + 1)
        freq2[x - 1] <- freq2[x - 1] + freq[x]
        freq2[x + 1] <- freq2[x + 1] + freq[x]        
      } else {
        newx <- c(newx, x)
        freq2[x] <- freq2[x] + freq[x]
      }
    }
    xs <- unique(newx)
    freq <- freq2
    y <- y + 1  # Always a blank line...
  }
  c(splits, sum(freq))
}

part1 <- function(d) { d[1] }
part2 <- function(d) { d[2] }

options(digits=16)
d <- solve(parse_file())
c(part1(d), part2(d))
