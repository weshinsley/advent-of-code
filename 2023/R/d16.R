parse_input <- function(f) {
  lapply(readLines(f), function(x) strsplit(x, "")[[1]])
}

part1 <- function(d, sx = 1, sy = 1, sd = 1) {
  wid <- length(d[[1]])
  hei <- length(d)
  mem <- matrix(0, nrow = hei, ncol = wid)
  dx <- c(1, 0, -1, 0)
  dy <- c(0, 1, 0, -1)
  dirs <- c(1, 2, 4, 8)
  beams <- list(list(x = sx, y = sy, dir = sd))
  bno <- 1
  beam <- beams[[bno]]
  while (TRUE) {
    if ((beam$y < 1) || (beam$y > hei) || (beam$x < 1) || (beam$x > hei) ||
       (bitwAnd(mem[beam$y, beam$x], dirs[beam$d]) > 0)) {
      bno <- bno + 1
      if (bno > length(beams)) {
        return(sum(mem > 0))
      }
      beam <- beams[[bno]]
      next
    }
    mem[beam$y, beam$x] <- mem[beam$y, beam$x] + dirs[beam$d]
    sym <- d[[beam$y]][beam$x]
    if (sym == "\\") beam$dir <- c(2, 1, 4, 3)[beam$dir]
    else if (sym == "/") beam$dir <- c(4, 3, 2, 1)[beam$dir]
    else if (sym == "-") {
      if (beam$dir %in% c(2, 4)) {
        beams <- c(beams, list(list(x = beam$x + 1, y = beam$y, dir = 1)))
        beam$dir <- 3
      }
    } else if (sym == "|") {
      if (beam$dir %in% c(1, 3)) {
        beams <- c(beams, list(list(x = beam$x, y = beam$y + 1, dir = 2)))
        beam$dir <- 4
      }
    }
    beam$x <- beam$x + dx[beam$dir]
    beam$y <- beam$y + dy[beam$dir]
  }
  sum(mem > 0)
}

part2 <- function(d) {
  wid <- length(d[[1]])
  hei <- length(d)
  best <- 0
  for (i in seq_len(wid)) {
    best <- max(best, part1(d, i, 1, 2), part1(d, i, hei, 4))
  }
  for (j in seq_len(hei)) {
    best <- max(best, part1(d, 1, j, 1), part1(d, wid, j, 3))
  }
  best
}

d <- parse_input("../inputs/input_16.txt")
c(part1(d), part2(d))
