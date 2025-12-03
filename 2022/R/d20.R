parse <- function(f) {
  x <- data.frame(val = as.integer(readLines(f)))
  x$current_pos <- seq_len(nrow(x))
  x$prv <- x$current_pos - 1
  x$prv[1] <- nrow(x)
  x$nxt <- x$current_pos + 1
  x$nxt[nrow(x)] <- 1
  x
}

solve <- function(d, iters = 1, key = 1L) {
  d$val <- d$val * key
  for (j in 1:iters) {
    for (i in seq_len(nrow(d))) {
      d$nxt[d$prv[i]] <- d$nxt[i]
      d$prv[d$nxt[i]] <- d$prv[i]
      moves <- d$val[i] %% (nrow(d) - 1)
      p <- d$nxt[i]
      while (moves > 0) {
        p <- d$nxt[p]
        moves <- moves - 1
      }
      d$nxt[i] <- p
      d$prv[i] <- d$prv[d$nxt[i]]
      d$nxt[d$prv[i]] <- i
      d$prv[d$nxt[i]] <- i
    }
  }

  pointer <- which(d$val == 0)
  s <- 0
  for (j in 1:3) {
    for (i in 1:1000) pointer <- d$nxt[pointer]
    s <- s + d$val[pointer]
  }
  format(s, digits = 16)
}

part1 <- function(d) {
  solve(d)
}

part2 <- function(d) {
  solve(d, 10, 811589153)
}

d <- parse("../inputs/input_20.txt")
c(part1(d), part2(d))
