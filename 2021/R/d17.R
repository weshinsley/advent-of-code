d <- as.integer(strsplit(gsub("\\.\\.", ",", gsub(", y=", ",", 
       gsub("target area: x=", "", readLines("../inputs/input_17.txt")))),",")[[1]])

shot <- function(xv, yv, x1, x2, y1, y2) {
  x <- 0
  y <- 0
  maxy <- -Inf
  repeat {
    if ((y < y1) || (x > x2)) {
      return(-Inf)
    }
    if ((x >= x1) && (x <= x2) && (y >= y1) && (y <= y2)) {
      return(maxy)
    }

    x <- x + xv
    y <- y + yv
    maxy <- max(y, maxy)
    if (xv > 0L) xv <- xv - 1L
    else if (xv < 0L) xv <- xv + 1L
    yv <- yv - 1L
  }
}

shots <- function(x1, x2, y1, y2) {
  maxy <- -Inf
  hits <- 0L
  maxx <- 0L
  for (xv in seq_len(x2)) {
    maxx <- maxx + xv
    if (maxx < x1) next
    for (yv in (y1:110L)) {
      res <- shot(xv, yv, x1, x2, y1, y2)
      if (res != -Inf) {
        maxy <- max(maxy, res)
        hits <- hits + 1L
      }
    }
  }
  c(maxy, hits)
}

part1 <- function(x) { x[1] }
part2 <- function(x) { x[2] }

res <- shots(d[1], d[2], d[3], d[4])
c(part1(res), part2(res))
