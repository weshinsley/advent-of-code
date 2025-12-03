parse_input <- function(f) {
  d <- read.csv(file = f, sep = " ", col.names = c("dir", "dist", "col"),
                header = FALSE)
  d$dist2 <- strtoi(paste0("0x", substring(d$col, 3, 7)))
  d$dir2 <- c("R", "D", "L", "U")[1 + as.integer(substring(d$col, 8, 8))]
  d
}

part1 <- function(d, p2 = FALSE) {
  if (p2) {
    d$dist <- d$dist2
    d$dir <- d$dir2
  }
  x <- 1
  y <- 1
  for (i in seq_len(nrow(d))) {
    d$x1[i] <- x
    d$y1[i] <- y
    y <- y + (((d$dir[i] == "D") - (d$dir[i] == "U")) * d$dist[i])
    x <- x + (((d$dir[i] == "R") - (d$dir[i] == "L")) * d$dist[i])
    d$x2[i] <- x
    d$y2[i] <- y
  }

  # So I had to do some googling...

  # Pick's theorem:

  #   the area of any simple lattice polygon, A, is found by adding the
  #   number of interior lattice points, I, to half the number of lattice
  #   points on the boundary, B, minus 1 ( A = I + B/2 − 1 ).

  # The Shoelace algorithm we talked about on day 12 gives us the interior
  # lattice points I think, when we are giving it pixels, rather than the
  # "outside" perimeter of the pixels.

  area <- 0
  for (i in seq_len(nrow(d))) {
    area <- area + (d$y1[i] * d$x2[i]) - (d$x1[i] * d$y2[i])
  }
  area <- abs(area) %/% 2

  # And then this is the perimeter bit.

  area <- area + as.integer((sum(d$dist) / 2) + 1)
  area
}

part2 <- function(d) {
  format(part1(d, TRUE), digits = 14)
}

d <- parse_input("../inputs/input_18.txt")
c(part1(d), part2(d))
