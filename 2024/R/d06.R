source("../../shared/R/matrix.R")

parse_file <- function(f = "../inputs/input_6.txt") {
  strings_to_char_matrix(readLines(f))
}

print <- function(m) {
  for (j in seq_len(nrow(m))) {
    message(paste0(m[j, ], collapse=""))
  }
}

run <- function(d, p2 = FALSE) {
  hist <- matrix(0, nrow = nrow(d), ncol = ncol(d))
  gxy <- as.integer(which(d == "^", arr.ind = TRUE))
  orig <- gxy
  dir <- 1
  dx <- c(0, 1, 0, -1)
  dy <- c(-1, 0, 1, 0)
  pows <- c(1, 2, 4, 8)
  while(TRUE) {
    d[gxy[1], gxy[2]] <- "X"
    if (bitwAnd(hist[gxy[1], gxy[2]], pows[dir]) > 0) {
      return(TRUE)
    }
    hist[gxy[1], gxy[2]] <- bitwOr(hist[gxy[1], gxy[2]], pows[dir])
    nx <- gxy[2] + dx[dir]
    ny <- gxy[1] + dy[dir]
    if ((nx == 0) || (ny == 0) || (nx > ncol(d)) || (ny > nrow(d))) {
      break
    }
    if (d[ny, nx] == '#') {
      dir <- (dir %% 4) + 1
    } else {
      gxy[1] <- ny
      gxy[2] <- nx
    }
  }
  d[orig[1], orig[2]] <- "^"
  d
}

part1 <- function(d) {
  d <- run(d)
  list(sum(d == "X") + 1, d)
}

part2 <- function(d, orig) {
  points <- which(d == "X", arr.ind = TRUE)
  tot <- 0
  for (p in seq_len(nrow(points))) {
    orig[points[p, 1], points[p, 2]] <- "#"
    tot <- tot + isTRUE(run(orig, TRUE))         
    orig[points[p, 1], points[p, 2]] <- "."
  }
  tot
}

d <- parse_file()
d2 <- part1(d)
c(d2[[1]], part2(d2[[2]], d))
