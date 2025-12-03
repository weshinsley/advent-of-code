parse <- function(f) {
  utf8ToInt(readLines(f)) - 61
}

plot <- function(g, sh, y) {
  g[y : (y - (length(sh) - 1))] <-
    bitwOr(g[y : (y - (length(sh) - 1))], current)

  for (x in rev(g[-1])) {
    x <- c(bitwAnd(x, 64), bitwAnd(x, 32), bitwAnd(x, 16), bitwAnd(x, 8),
           bitwAnd(x, 4), bitwAnd(x, 2), bitwAnd(x, 1))
    x[x > 1] <- 1
    x <- paste0(c(".", "")[x + 1], collapse = "")
    cat(paste0("|", x, "|\n", collapse = ""))
  }
  cat("+-------+\n\n")
}

part1 <- function(d, part2 = FALSE) {
  tower_height <- rep(0, 5000)
  shapes <- list(30, c(8, 28, 8), c(4, 4, 28), c(16, 16, 16, 16), c(24, 24))
  shape <- 1
  current <- shapes[[shape]]
  y <- 1
  grid <- c(127, 0, 0, 0, 0)
  i <- 1
  y <- length(grid)
  z <- 1
  end <- if (part2) 5000 else 2022
  while (z <= end) {

    yrange <- y : (y - (length(current) - 1))

    if ((d[i] == -1) && (sum(bitwAnd(current, 64)) == 0)) {
      if (sum(bitwAnd(current * 2, grid[yrange])) == 0)
        current <- current * 2

    } else if ((d[i] == 1) && (sum(bitwAnd(current, 1)) == 0)) {
      if (sum(bitwAnd(current / 2, grid[yrange])) == 0)
        current <- current / 2
    }

    i <- (i %% length(d)) + 1

    if (sum(bitwAnd(grid[(y - 1) : (y - (length(current)))], current)) == 0) {
        y <- y - 1

    } else {
      grid[yrange] <- bitwOr(grid[yrange], current)
      shape <- (shape %% 5) + 1
      current <- shapes[[shape]]
      space <- length(current) + 3
      top <- length(grid)
      while (grid[top] == 0) top <- top - 1
      z <- z + 1
      tower_height[z] <- (top - 1)
      y <- top + space
      top <- y
      if (length(grid) < top) {
        grid <- c(grid, rep(0, top - length(grid)))
      }

    }
  }

  if (!part2) {
    top <- length(grid)
    while (grid[top] == 0) top <- top - 1
    return(top - 1)
  }

  burn_in <- 500
  tot_cycles <- 1000000000000

  delta <- diff(tower_height)
  delta <- delta[(burn_in + 1):length(delta)]

  ds <- paste0(delta, collapse = "")
  x <- gregexpr(substring(ds, 1, 1000), substring(ds, 2))[[1]]
  cycle_len <- x[2] - x[1]
  cycle_delta <- sum(delta[1:cycle_len])
  cycles <- (tot_cycles - burn_in) %/% cycle_len
  h <- tower_height[burn_in] + (cycles * cycle_delta)
  extras <- (tot_cycles - burn_in) %% cycle_len
  h <- h + sum(delta[1:extras])
  format(h, digits = 20)
}

part2 <- function(d) {
  part1(d, TRUE)
}

d <- parse("../inputs/input_17.txt")
c(part1(d), part2(d))
