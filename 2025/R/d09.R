parse_file <- function(f = "../inputs/input_9.txt") {
  d <- read.csv(f, sep = ",", header = FALSE, col.names = c("x", "y"))
  d$x <- as.numeric(d$x)
  d$y <- as.numeric(d$y)
  d
}

dists <- function(d) {
  df <- as.data.frame(data.table::rbindlist(
    lapply(1:nrow(d), function(i) {
      df <- data.frame(x1 = d$x[i], y1 = d$y[i],
                       x2 = d$x, y2 = d$y)
      df$area <- (abs(df$x1 - df$x2) + 1) * (abs(df$y1 - df$y2) + 1)
      df
    }
  )))
  df[order(df$area, decreasing = TRUE), ]
}

part1 <- function(d) {
  d$area[1]
}

part2 <- function(d, m) {
  lines <- d
  lines$x2 <- c(d$x[2:nrow(d)], d$x[1])
  lines$y2 <- c(d$y[2:nrow(d)], d$y[1])
  lines$vert <- lines$x == lines$x2
  vlines <- lines[lines$vert, c("x", "y", "y2")]
  vlines <- data.frame(x = vlines$x, ymin = pmin(vlines$y, vlines$y2), ymax = pmax(vlines$y, vlines$y2))
  hlines <- lines[!lines$vert, c("x", "x2", "y")]
  hlines <- data.frame(y = hlines$y, xmin = pmin(hlines$x, hlines$x2), xmax = pmax(hlines$x, hlines$x2))
  hlines <- hlines[order(hlines$y), ]
  vlines <- vlines[order(vlines$x), ]

  crossesH <- function(hlines,x, y1, y2) {
    ymin <- min(y1, y2)
    ymax <- max(y1, y2)
    ycross <- (hlines$y > ymin) & (hlines$y < ymax)
    xcross <- (x >= hlines$xmin) & (x <= hlines$xmax)
    any(xcross & ycross)
  }

  crossesV <- function(vlines,y, x1, x2) {
    xmin <- min(x1, x2)
    xmax <- max(x1, x2)
    xcross <- (vlines$x > xmin) & (vlines$x < xmax)
    ycross <- (y >= vlines$ymin) & (y <= vlines$ymax)
    any(xcross & ycross)
  }

  i <- 0
  while(TRUE) {
    i <- i + 1
    rect <- m[i, ]  # Does the perimeter intersect any lines?
    if (crossesH(hlines, rect$x1, rect$y1, rect$y2)) next
    if (crossesH(hlines, rect$x2, rect$y1, rect$y2)) next
    if (crossesV(vlines, rect$y1, rect$x1, rect$x2)) next
    if (crossesV(vlines, rect$y2, rect$x1, rect$x2)) next
    return(rect$area)
  }
}

d <- parse_file()
m <- dists(d)
c(part1(m), part2(d, m))

