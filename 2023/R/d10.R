parse_input <- function(f) {
  d <- lapply(readLines(f), function(x) strsplit(x, "")[[1]])
  sy <- which(unlist(lapply(d, function(x) "S" %in% x)))
  sx <- which(d[[sy]] == "S")

  north_link <- (sy > 1) && d[[sy - 1]][sx] %in% c("F", "|", "7")
  east_link <- (sx < length(d[[1]])) && d[[sy]][sx + 1] %in% c("J", "-", "7")
  west_link <- (sx > 1) && d[[sy]][sx - 1] %in% c("F", "-", "L")
  south_link <- (sy < length(d)) && d[[sy + 1]][sx] %in% c("|", "L", "J")

  s <- if (north_link && west_link) list("J", -1, 0)
       else if (north_link && east_link) list("L", 1, 0)
       else if (south_link && west_link) list("7", 0, 1)
       else if (south_link && east_link) list("F", 1, 0)
       else if (south_link && north_link) list("|", 0, 1)
       else if (west_link && east_link) list("-", 1, 0)
  d[[sy]][sx] <- s[[1]]
  list(map = d, sx = sx, sy = sy, dx = s[[2]], dy = s[[3]])
}

part1_solve <- function(d) {
  rules <- rbind(data.frame(ch = "L", dx = 0,  dy = 1,  ndx = 1,  ndy = 0),
                 data.frame(ch = "L", dx = -1, dy = 0,  ndx = 0,  ndy = -1),
                 data.frame(ch = "J", dx = 1,  dy = 0,  ndx = 0,  ndy = -1),
                 data.frame(ch = "J", dx = 0,  dy = 1,  ndx = -1, ndy = 0),
                 data.frame(ch = "7", dx = 1,  dy = 0,  ndx = 0,  ndy = 1),
                 data.frame(ch = "7", dx = 0,  dy = -1, ndx = -1, ndy = 0),
                 data.frame(ch = "F", dx = -1, dy = 0,  ndx = 0,  ndy = 1),
                 data.frame(ch = "F", dx = 0,  dy = -1, ndx = 1,  ndy = 0),
                 data.frame(ch = "|", dx = 0,  dy = 1,  ndx = 0,  ndy = 1),
                 data.frame(ch = "|", dx = 0,  dy = -1, ndx = 0,  ndy = -1),
                 data.frame(ch = "-", dx = 1,  dy = 0,  ndx = 1,  ndy = 0),
                 data.frame(ch = "-", dx = -1, dy = 0,  ndx = -1, ndy = 0))
  dx <- d$dx
  dy <- d$dy
  x <- d$sx + dx
  y <- d$sy + dy
  d$map[[d$sy]][d$sx] <- "#"
  steps <- 1

  while ((x != d$sx) || (y != d$sy)) {
    row <- which(rules$ch == d$map[[y]][x] & rules$dx == dx & rules$dy == dy)
    dx <- rules$ndx[row]
    dy <- rules$ndy[row]
    d$map[[y]][x] <- "#"
    x <- x + dx
    y <- y + dy
    steps <- steps + 1
  }

  list(p1 = (steps / 2), d = d)

}

double_grid <- function(d) {
  rules <- rbind(data.frame(ch = ".", r = " ", d = " "),
                 data.frame(ch = "|", r = " ", d = "|"),
                 data.frame(ch = "-", r = "-", d = " "),
                 data.frame(ch = "J", r = " ", d = " "),
                 data.frame(ch = "F", r = "-", d = "|"),
                 data.frame(ch = "7", r = " ", d = "|"),
                 data.frame(ch = "L", r = "-", d = " "))

  d2 <- list()
  for (line in d) {
    l1 <- c()
    l2 <- c()
    for (char in line) {
      l1 <- c(l1, char, rules$r[rules$ch == char])
      l2 <- c(l2, rules$d[rules$ch == char], " ")
    }
    d2[[length(d2) + 1]] <- l1
    d2[[length(d2) + 1]] <- l2
  }
  d2
}

seed_fill <- function(d, sx, sy) {
  work <- list(c(sx, sy))
  index <- 1
  last <- length(work)
  mx <- length(d[[1]])
  my <- length(d)
  while (index <= last) {
    x <- work[[index]][1]
    y <- work[[index]][2]
    index <- index + 1

    if ((x < 1) || (x > mx) || (y < 1) || (y > my)) {
      return(0)
    }

    if ((d[[y]][x] == "Q") || (d[[y]][x] == "#")) {
      next
    }

    d[[y]][x] <- "Q"

    work[[last + 1]] <- c(x - 1, y)
    work[[last + 2]] <- c(x + 1, y)
    work[[last + 3]] <- c(x, y - 1)
    work[[last + 4]] <- c(x, y + 1)
    last <- last + 4
  }

  tiles <- 0
  for (y in seq(1, length(d), by = 2)) {
    for (x in seq(1, length(d[[1]]), by = 2)) {
      if (d[[y]][x] == "Q") tiles <- tiles + 1
    }
  }
  tiles
}

part1 <- function(d) {
  part1_solve(d)$p1
}

part2 <- function(d) {
  d <- list(
    map = double_grid(d$map),
    sx = (2 * d$sx) - 1,
    sy = (2 * d$sy) - 1,
    dx = d$dx,
    dy = d$dy)
  d <- part1_solve(d)$d
  max(seed_fill(d$map, d$sx - 1, d$sy + 1),
      seed_fill(d$map, d$sx + 1, d$sy + 1),
      seed_fill(d$map, d$sx - 1, d$sy - 1),
      seed_fill(d$map, d$sx + 1, d$sy - 1))
}

d <- parse_input("../inputs/input_10.txt")
c(part1(d), part2(d))
