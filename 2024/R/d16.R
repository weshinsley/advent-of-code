source("../../shared/R/matrix.R")

parse_file <- function(f = "../inputs/input_16.txt") {
  pad_matrix(strings_to_char_matrix(readLines(f)), 1, "#")
}

dx <- c(1, 0, -1, 0)
dy <- c(0, 1, 0, -1)
pows <- c(1,2,4,8)

solve <- function(d) {
  d2 <- d
  visited <- array(Inf, dim = c(nrow(d), ncol(d)))
  start <- as.integer(which(d == "S",arr.ind = TRUE))
  end <- as.integer(which(d == "E", arr.ind = TRUE))
  dir <- 1
  visited[start[1], start[2]] <- 0
  queue <- list(c(start[2], start[1], dir, 0))
  i <- 0
  n <- 1
  best <- Inf
  while (i < n) {
    i <- i + 1
    xyds <- queue[[i]]
    x <- xyds[1]
    y <- xyds[2]
    dir <- xyds[3]
    score <- xyds[4]
    d2[y, x] <- "@"
    if ((x == 14) && (y == 3)) {}
    if (x == end[2] && (y == end[1])) {
      best <- min(best, score)
      next
    }
    if (score > best) {
      next
    }
    visited[y, x] <- min(visited[y, x], score)

    dirr <- if (dir == 4) 1 else dir + 1
    dirl <- if (dir == 1) 4 else dir - 1

    # Fwd

    nx <- x + dx[dir]
    ny <- y + dy[dir]
    if ((d[ny, nx] %in% c(".", "E")) && (visited[ny, nx] > score + 1)) {
      visited[ny, nx] <- score + 1
      n <- n + 1
      queue[[n]] <- c(nx, ny, dir, score + 1)
    }

    # Left/Right

    for (dnext in c(dirl, dirr)) {
      nx <- x + dx[dnext]
      ny <- y + dy[dnext]
      if ((d[ny, nx] %in% c(".", "E")) && (visited[ny, nx] > score + 1001)) {
        n <- n + 1
        queue[[n]] <- c(x, y, dnext, score + 1000)
      }
    }
  }

  visited[visited > best] <- Inf
  seats <- matrix(FALSE, nrow = nrow(visited), ncol = ncol(visited))
  x <- end[[2]]
  y <- end[[1]]
  queue <- list(c(x, y, best))
  i <- 0
  n <- 1
  while (i < n) {
    i <- i + 1
    x <- queue[[i]][1]
    y <- queue[[i]][2]
    score <- visited[y, x]
    seats[y, x] <- TRUE
    for (dir in 1:4) {
      if ((visited[y + dy[dir], x + dx[dir]]) < score) {
        n <- n + 1
        queue[[n]] <- c(x + dx[dir], y + dy[dir])
        if (score - visited[y + dy[dir], x + dx[dir]] == 1001) {
          if ((visited[y + dy[dir] + dy[dir],
                       x + dx[dir] + dx[dir]]) == score - 2) {
            n <- n + 1
            queue[[n]] <- c(x + dx[dir] + dx[dir], y + dy[dir] + dy[dir])
          }
        }
      }

    }
  }

  c(best, sum(seats))
}

part1 <- function(d) {
  d[1]
}

part2 <- function(d) {
  d[2]
}

d <- solve(parse_file())
c(part1(d), part2(d))