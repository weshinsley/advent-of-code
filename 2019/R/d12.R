read_input <- function(file) {
  m <- strsplit(gsub("[<xyz,=>]","",readLines(file))," ")
  data.frame(stringsAsFactors = FALSE,
    x = as.numeric(unlist(lapply(m, "[[", 1))),
    y = as.numeric(unlist(lapply(m, "[[", 2))),
    z = as.numeric(unlist(lapply(m, "[[", 3)))
  )
}

solve <- function(moons, iter, part2 = FALSE) {
  repx <- -1
  repy <- -1
  repz <- -1
  orig <- moons

  vels <- moons
  vels$x <- 0
  vels$y <- 0
  vels$z <- 0
  i <- 0
  while (i < iter) {
    for (m in seq_len(nrow(moons))) {
      for (n in seq_len(nrow(moons))) {
        if (m != n) {
          if (repx < 0) vels$x[m] <- vels$x[m] + (moons$x[n] > moons$x[m]) - (moons$x[n] < moons$x[m])
          if (repy < 0) vels$y[m] <- vels$y[m] + (moons$y[n] > moons$y[m]) - (moons$y[n] < moons$y[m])
          if (repz < 0) vels$z[m] <- vels$z[m] + (moons$z[n] > moons$z[m]) - (moons$z[n] < moons$z[m])
        }
      }
    }
    for (m in seq_len(nrow(moons))) {
      if (repx < 0) moons$x[m] <- moons$x[m] + vels$x[m]
      if (repy < 0) moons$y[m] <- moons$y[m] + vels$y[m]
      if (repz < 0) moons$z[m] <- moons$z[m] + vels$z[m]
    }
    i <- i + 1
    if (part2) {
      if ((repx < 0) && (all(moons$x == orig$x)) && (all(vels$x == 0))) repx <- i
      if ((repy < 0) && (all(moons$y == orig$y)) && (all(vels$y == 0))) repy <- i
      if ((repz < 0) && (all(moons$z == orig$z)) && (all(vels$z == 0))) repz <- i
      if ((repx > 0) && (repy > 0) && (repz > 0)) break
    }
  }
  if (!part2) {
    ener <- 0
    for (m in seq_len(nrow(moons))) {
      ener <- ener + ((abs(moons$x[m]) + abs(moons$y[m]) + abs(moons$z[m])) * 
                      (abs(vels$x[m]) + abs(vels$y[m]) + abs(vels$z[m])))
    }
    return(ener)
  } else {
    return(lcm(c(repx, repy, repz)))
  }
}

lcm <- function(nums) {
  res <- 1
  mx <- max(nums)
  div <- 2
  while (div < mx) {
    if (any(nums %% div == 0)) {
      wh <- which(nums %% div == 0)
      nums[wh] <- nums[wh] / div
      mx <- max(nums)
      res <- res * div
    } else {
      div <- div + 1
    }
  }
  res * prod(nums)
}

moons <- read_input("../inputs/input_12.txt")
c(solve(moons, 1000),
  solve(moons, Inf, TRUE))
