# Keeping this one fairly simple for example.
# Speed later perhaps...
# part1 could use diff probably, but
# the idea of the edges gives me a headache.

add_basin <- function(d, i, j) {
  explore <- c(i, j, rep(0, 352))
  head <- 1
  tail <- 3
  tot <- 0
  di <- c(0, 1, 0, -1)
  dj <- c(-1, 0, 1, 0)
  maxx <- length(d[[1]])
  maxy <- length(d)
  
  while (tail > head) {
    i <- explore[head]
    j <- explore[head + 1]
    head <- head + 2
    val <- d[[j]][i]
    if (d[[j]][i] == 9) next
    tot <- tot + 1
    d[[j]][i] <- 9
    for (dir in 1:4) {
      i2 <- i + di[dir]
      j2 <- j + dj[dir]
      if ((i2 >= 1) && (i2 <= maxx) &&
          (j2 >= 1) && (j2 <= maxy) && (d[[j2]][i2] != 9)) {
        explore[tail] <- i2
        explore[tail + 1] <- j2
        tail <- tail + 2
      }
    }
  }
  tot
}

solve <- function(d) {
  tot <- 0
  basins <- NULL
  maxx <- length(d[[1]])
  maxy <- length(d)
  
  for (j in seq_along(d)) {
    row <- d[[j]]
    for (i in seq_along(row)) {
      v <- row[i]
      n <- if (j > 1) d[[j-1]][i] else 10
      s <- if (j < maxy) d[[j+1]][i] else 10
      e <- if (i < maxx) d[[j]][i+1] else 10
      w <- if (i > 1) d[[j]][i-1] else 10
      if ((v<n) && (v<s) && (v<e) && (v<w)) {
        tot <- tot + 1 + v
        basins <- c(basins, add_basin(d, i, j))
        if (length(basins) == 4) {
          basins <- rev(sort(basins))[1:3]
        }
      }
    }
  }
  c(tot, prod(basins))

}

part1 <- function(res) { res[1] }
part2 <- function(res) { res[2] }

d <- lapply(strsplit(readLines("../inputs/input_9.txt"), ""), as.integer)
res <- solve(d)
c(part1(res), part2(res))
