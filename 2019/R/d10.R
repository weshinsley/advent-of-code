load_asteroids <- function(file) {
  map <- readLines(file)
  asteroids <- NULL
  for (y in seq_along(map)) {
    asts = which(unlist(strsplit(map[y], "")) == '#')
    if (length(asts) > 0) {
      asteroids <- rbind(asteroids, data.frame(
        x = asts - 1,
        y = y - 1
        
      ))
    }
  }
  asteroids  
}

line_of_sight <- function(asteroids, x, y) {
  res <- 0
  for (a in seq_len(nrow(asteroids))) {
    xa <- asteroids$x[a]
    ya <- asteroids$y[a]
    if ((x != xa) || (y != ya)) {
      dx <- x - xa
      dy <- y - ya
      if (dx == 0) dy = dy / abs(dy)
      else if (dy == 0) dx = dx / abs(dx)
      else {
        max_vec <- max(abs(dx), abs(dy))
        if (max_vec >= 2) {
          for (k in max_vec:2) {
            if ((dx %% k == 0) && (dy %% k == 0)) {
              dx <- dx / k
              dy <- dy / k
            }
          }
        }
      }
      xa <- xa + dx
      ya <- ya + dy
      clear <- TRUE
      while ((x != xa) || (y != ya)) {
        if (nrow(asteroids[asteroids$x == xa 
                                      & asteroids$y == ya,]) == 1) {
          clear <- FALSE
          break
        }
        xa <- xa + dx
        ya <- ya + dy
      }
      if (clear) res <- res + 1
    }
  }
  res
}

part1 <- function(asteroids) {
  for (i in seq_len(nrow(asteroids))) {
    asteroids$los[i] = line_of_sight(asteroids, 
                                     asteroids$x[i], asteroids$y[i])
  }
  best <- max(asteroids$los)
  index <- which(asteroids$los == best)
  c(best, asteroids$x[index], asteroids$y[index])
}

#############################

calculate_angles <- function(asteroids, x, y) {
  for (i in seq_len(nrow(asteroids))) {
    ax <- asteroids$x[i]
    ay <- asteroids$y[i]
    if ((ax!=x) || (ay!=y)) {
      dist <- sqrt(((ax-x)*(ax-x)) + ((ay-y)*(ay-y)));
      angle <- NA
      if ((ax == x) && (ay < y)) angle <- 0
      else if ((ax == x) && (ay > y)) angle <- pi
      else if ((ay == y) && (ax < x)) angle <- 1.5 * pi
      else if ((ay == y) && (ax > x)) angle <- 0.5 * pi
      else if ((ax > x) && (ay < y)) angle <- asin((ax - x) / dist)
      else if ((ax > x) && (ay > y)) angle <- (0.5 * pi) + asin((ay - y) / dist)
      else if ((ax < x) && (ay > y)) angle <- pi + asin((x - ax) / dist)
      else if ((ax < x) && (ay < y)) angle <- (1.5 * pi) + asin((y - ay) / dist)
      asteroids$dist[i] <- dist
      asteroids$angle[i] <- angle
    }
  }
  asteroids[order(asteroids$angle, asteroids$dist), ]
}

part2 <- function(asteroids, x, y) {
  asteroids <- calculate_angles(asteroids, x, y)
  asteroids$shot <- FALSE
  i <- 1
  n <- 0
  while (TRUE) {
    asteroids$shot[i] <- TRUE
    n <- n + 1
    if (n == 200) {
      return((asteroids$x[i] * 100) + (asteroids$y[i]))
    }
    angle <- asteroids$angle[i]
    while (abs(asteroids$angle[i] - angle) < 1E-10) {
      i <- i + 1
      if (i > nrow(asteroids)) i <- 1
    }
    while (asteroids$shot[i]) {
      i <- i + 1
      if (i > nrow(asteroids)) i <- 1
    }
  }
}

asteroids <- load_asteroids("../inputs/input_10.txt")
res <- part1(asteroids)
c(sprintf("%d at (%d,%d)", res[1], res[2], res[3]),
  sprintf("%d", part2(asteroids, res[2], res[3])))
