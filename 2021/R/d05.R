parse_input <- function(d) {
  read.csv(text = gsub(" -> ", ",", readLines(d)),
           header = FALSE, col.names = c("x1", "y1", "x2", "y2"))
}

solve <- function(d, part2 = FALSE) {
  minx <- min(c(d$x1, d$x2))
  miny <- min(c(d$y1, d$y2))
  
  if (minx <= 0) {
    d$x1 <- d$x1 - (minx - 1)
    d$x2 <- d$x2 - (minx - 1)
    minx <- 1
  }
  if (miny <= 0) {
    d$y1 <- d$y1 - (miny - 1)
    d$y2 <- d$y2 - (miny - 1)
    miny <- 1
  }
  maxx <- max(c(d$x1, d$x2))
  maxy <- max(c(d$y1, d$y2))
  
  grid <- list()
  for (i in (1:maxy)) {
    grid[[i]] <- rep(0, maxx)
  }
  
  for (i in seq_len(nrow(d))) {
    row <- d[i,]
    if ((row$x1 == row$x2) || (row$y1 == row$y2)) {
      for (y in row$y1:row$y2) {
        grid[[y]][row$x1:row$x2] <- grid[[y]][row$x1:row$x2] + 1
      }
    } else if (part2) {
      dy <- ifelse(row$y2 > row$y1, 1, -1)
      y <- row$y1
      for (x in row$x1:row$x2) {
        grid[[y]][x] <- grid[[y]][x] + 1
        y <- y + dy
      }
    }
  }
  sum(unlist(grid)>=2)
}

part1 <- function(d) { solve(d) }
part2 <- function(d) { solve(d, TRUE) }

d <- parse_input("../inputs/input_5.txt")
c(part1(d), part2(d))
