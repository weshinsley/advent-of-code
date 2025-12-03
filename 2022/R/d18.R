parse <- function(f) {
  d <- read.csv(f, header = FALSE, col.names = c("x", "y", "z"))
  d$x <- d$x + 2 - min(d$x)
  d$y <- d$y + 2 - min(d$y)
  d$z <- d$z + 2 - min(d$z)
  space <- array(0, c(max(d$x) + 1, max(d$y) + 1, max(d$z) + 1))
  for (i in seq_len(nrow(d))) {
    space[d$x[i], d$y[i], d$z[i]] <- 1
  }
  space
}

index_to_3d <- function(arr, index) {
  sizes <- dim(arr)
  index <- index - 1
  z <- 1 + ((index) %/% (sizes[1] * sizes[2]))
  index <- (index) %% (sizes[1] * sizes[2])
  y <- 1 + (index) %/% sizes[1]
  index <- 1 + (index) %% sizes[1]
  list(x = index, y = y, z = z)
}

part1 <- function(d) {
  cubes <- lapply(which(d == 1), function(x) index_to_3d(d, x))
  sum(unlist(lapply(cubes, function(cube) {
    sum(6 - (d[cube$x - 1, cube$y, cube$z] + d[cube$x + 1, cube$y, cube$z] +
             d[cube$x, cube$y - 1, cube$z] + d[cube$x, cube$y + 1, cube$z] +
             d[cube$x, cube$y, cube$z - 1] + d[cube$x, cube$y, cube$z + 1]))
  })))
}

part2 <- function(d) {
  cubes <- lapply(which(d == 1), function(x) index_to_3d(d, x))
  size <- dim(d)
  for (q in cubes) {
    if (sum(d[1:(q$x - 1), q$y, q$z]) == 0)        d[q$x - 1, q$y, q$z] <- 2
    if (sum(d[q$x, 1:(q$y - 1), q$z]) == 0)        d[q$x, q$y - 1, q$z] <- 2
    if (sum(d[q$x, q$y, 1:(q$z - 1)]) == 0)        d[q$x, q$y, q$z - 1] <- 2
    if (sum(d[(q$x + 1):size[1], q$y, q$z]) == 0)  d[q$x + 1, q$y, q$z] <- 2
    if (sum(d[q$x, (q$y + 1):size[2], q$z]) == 0)  d[q$x, q$y + 1, q$z] <- 2
    if (sum(d[q$x, q$y, (q$z + 1):size[3]]) == 0)  d[q$x, q$y, q$z + 1] <- 2
  }

  mx <- c(-1, 1, 0, 0, 0, 0)
  my <- c(0, 0, -1, 1, 0, 0)
  mz <- c(0, 0, 0, 0, -1, 1)

  queue <- as.list(which(d == 2))
  head <- 1
  tail <- length(queue) + 1

  while (head <= length(queue)) {
    pos <- index_to_3d(d, queue[[head]])
    head <- head + 1
    for (m in 1:6) {
      nx <- pos$x + mx[m]
      ny <- pos$y + my[m]
      nz <- pos$z + mz[m]
      if ((nx <= 0) || (nx > size[1])) next
      if ((ny <= 0) || (ny > size[2])) next
      if ((nz <= 0) || (nz > size[3])) next
      if (d[nx, ny, nz] != 0) next

      d[nx, ny, nz] <- 2
      queue[[tail]] <- ((nz - 1) * size[1] * size[2]) +
                       ((ny - 1) * size[1]) + nx
      tail <- tail + 1
    }
  }

  sum(unlist(lapply(which(d == 2), function(st) {
    st <- index_to_3d(d, st)
    f <- 0
    if (st$x > 1) f <- f + (d[st$x - 1, st$y, st$z] == 1)
    if (st$y > 1) f <- f + (d[st$x, st$y - 1, st$z] == 1)
    if (st$z > 1) f <- f + (d[st$x, st$y, st$z - 1] == 1)
    if (st$x < size[1] - 1) f <- f + (d[st$x + 1, st$y, st$z] == 1)
    if (st$y < size[2] - 1) f <- f + (d[st$x, st$y + 1, st$z] == 1)
    if (st$z < size[3] - 1) f <- f + (d[st$x, st$y, st$z + 1] == 1)
    f
  })))
}

d <- parse("../inputs/input_18.txt")
c(part1(d), part2(d))
