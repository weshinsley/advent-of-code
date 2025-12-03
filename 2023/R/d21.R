parse_input <- function(f) {
  map <- readLines(f)
  wid <- nchar(map[1])
  hei <- length(map)
  matrix(strsplit(paste0(map, collapse = ""), "")[[1]],
         ncol = wid, nrow = hei, byrow = TRUE)

}

dump <- function(m) {
  for (i in seq_len(nrow(m))) {
    message(paste0(m[i, ], collapse = ""))
  }
}

part1 <- function(d, max_steps = 64) {
  x <- which(d == "S")
  y <- (x %/% ncol(d)) + 1
  x <- x %% ncol(d)
  d[y, x] <- "."
  visit <- matrix(0, nrow(d), ncol(d))
  queue <- list(c(x, y, 0))
  i <- 1
  n <- 1
  dx <- c(1, 0, -1, 0)
  dy <- c(0, 1, 0, -1)
  while (i <= n) {
    space <- queue[[i]]
    x <- space[1]
    y <- space[2]
    steps <- space[3]
    i <- i + 1

    if (steps >= max_steps) {
      next
    }

    for (dir in 1:4) {
      nx <- x + dx[dir]
      ny <- y + dy[dir]
      if ((nx == 0) || (ny == 0) || (nx > ncol(d)) || (ny > nrow(d))) {
        next
      }
      if ((d[ny, nx] == ".") && (visit[ny, nx] == 0)) {
        n <- n + 1
        queue[[n]] <- c(nx, ny, steps + 1)
        if (any(((steps + 1) %% 2) == 0)) visit[ny, nx] <- 1
      }
    }
  }
  sum(visit)
}

slow_part1 <- function(d, max_steps = 64) {
  x <- which(d == "S")
  if (max_steps > 64) {
    # Surround our map with two more on all sides
    d <- cbind(d, d, d, d, d)
    d <- rbind(d, d, d, d, d)
    x <- which(d == "S")[13]
  }

  hei <- nrow(d)
  wid <- ncol(d)
  y <- (x %/% wid) + 1
  x <- x %% wid
  d[which(d == "S")] <- "."
  visit <- new.env()
  success <- new.env()
  queue <- list(c(x, y, 0))
  n <- 1
  dx <- c(1, 0, -1, 0)
  dy <- c(0, 1, 0, -1)
  while (n > 0) {
    space <- queue[[n]]
    n <- n - 1
    x <- space[1]
    y <- space[2]
    steps <- space[3]
    hash <- paste0("_", x, "_", y, "_", steps)

    if (exists(hash, envir = visit)) {
      next
    }
    assign(hash, 1, envir = visit)

    if (steps == max_steps) {
      assign(hash, 1, envir = success)
      next
    }


    for (dir in 1:4) {
      nx <- x + dx[dir]
      ny <- y + dy[dir]
      if ((nx == 0) || (ny == 0) || (nx > wid) || (ny > hei)) {
        next
      }
      if (d[ny, nx] == ".") {
        n <- n + 1
        if (n > length(queue)) {
          queue[[n]] <- c(nx, ny, steps + 1)
        } else {
          queue[[n]][1] <- nx
          queue[[n]][2] <- ny
          queue[[n]][3] <- steps + 1
        }
      }
    }
  }
  length(success)
}

part2 <- function(d, steps = 26501365) {
  start <- floor(nrow(d) / 2)
  size <- nrow(d)
  r1 <- slow_part1(d, start)
  r2 <- slow_part1(d, start + size)
  r3 <- slow_part1(d, start + size + size)

  cc <- r1
  bb <- (((4 * r2) - r3) - (3 * r1)) / 2
  aa <- r2 - (cc + bb)

  message(sprintf("Res = %s,%s,%s ... co-eff = %s,%s,%s", r1, r2, r3, aa, bb, cc))

  x <- (steps - start) / size
  format((aa*x*x) + (bb*x) + cc, digits = 14)


}

d <- parse_input("../inputs/input_21.txt")
c(part1(d), part2(d))
