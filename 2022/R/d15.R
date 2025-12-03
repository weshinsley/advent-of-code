parse <- function(f) {
  d <- as.data.frame(data.table::rbindlist(lapply(readLines(f), function(x) {
    row <- as.integer(strsplit(gsub("[A-Za-z= ]", "", x), "[,:]")[[1]])
    data.frame(sx = row[1], sy = row[2], bx = row[3], by = row[4])})))
  d$md <- abs(d$bx - d$sx) + abs(d$by - d$sy)
  d
}

part1 <- function(d, yv = 2000000) {
  beacons <- length(unique(d$bx[d$by == yv]))
  d <- d[(yv <= (d$sy + d$md)) & (yv >= (d$sy - d$md)), ]
  d$ydist <- abs(d$sy - yv)
  d$xdist <- abs(d$md - d$ydist)
  d$fromx <- (d$sx - d$xdist)
  d$tox <- d$sx + d$xdist
  d <- d[order(d$fromx), ]

  z1 <- -1
  z2 <- -2
  while (z1 != z2) {
    z1 <- nrow(d)
    d$fromx[2:nrow(d)] <- pmax(d$fromx[2:nrow(d)], 1 + d$tox[1:(nrow(d) - 1)])
    d <- d[d$tox >= d$fromx, ]
    d <- d[order(d$fromx), ]
    z2 <- nrow(d)
  }

  sum(1 + (d$tox - d$fromx)) - beacons
}

part2 <- function(d) {
  d$top <- d$sy - d$md
  d$right <- d$sx + d$md
  d$bottom <- d$sy + d$md
  d$left <- d$sx - d$md
  for (i in seq_len(nrow(d))) {

    shape <- d[i, ]
    p1 <- c(shape$sx, shape$top - 1)
    p3 <- c(shape$right + 1, shape$sy)
    p5 <- c(shape$sx, shape$bottom + 1)
    p7 <- c(shape$left - 1, shape$sy)
    p2 <- p3 - 1
    p4 <- p5 + c(1, -1)
    p6 <- p7 + 1
    p8 <- p1 + c(-1, 1)

    df <- data.frame(x = c(p1[1]:p2[1], p3[1]:p4[1], p5[1]:p6[1], p7[1]:p8[1]),
                     y = c(p1[2]:p2[2], p3[2]:p4[2], p5[2]:p6[2], p7[2]:p8[2]))

    for (j in seq_len(nrow(d))[-i]) {
      sen <- d[j, ]
      df <- df[((abs(df$x - sen$sx)) + (abs(df$y - sen$sy))) > sen$md, ]
    }

    if (nrow(df) == 1) break
  }
  format(df$x * 4000000 + df$y, digits = 16)
}

d <- parse("../inputs/input_15.txt")
c(part1(d), part2(d))
