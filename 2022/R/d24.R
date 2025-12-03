parse <- function(f) {
  d <- lapply(readLines(f), utf8ToInt)
  hei <- length(d)
  wid <- length(d[[1]])
  d <- unlist(d)
  spaces <- which(d == 46)
  list(wid = wid, hei = hei, map = d, bl = which(d == 60), br = which(d == 62),
       bu = which(d == 94), bd = which(d == 118),
       start = spaces[1], end = spaces[length(spaces)])
}

pr <- function(d) {
  m <- matrix(d$map, ncol = 8, byrow = TRUE)
  for (i in seq_len(nrow(m))) {
    cat(intToUtf8(m[i, ]), "\n")
  }
}

shortest <- function(d, start = d$start, end = d$end) {
  steps <- 0
  cells <- d$wid * d$hei

  next_step <- d$map * 0
  next_step[start] <- 1

  while (TRUE) {
    d$br <- d$br + 1
    collide <- which(d$map[d$br] == 35)
    d$br[collide] <- d$br[collide] - (d$wid - 2)

    d$bl <- d$bl - 1
    collide <- which(d$map[d$bl] == 35)
    d$bl[collide] <- d$bl[collide] + (d$wid - 2)

    d$bu <- d$bu - d$wid
    collide <- which(d$bu == start - d$hei)
    d$bu[collide] <- d$bu[collide] + ((d$hei - 1) * d$wid)
    collide <- which(d$map[d$bu] == 35)
    d$bu[collide] <- d$bu[collide] + ((d$hei - 2) * d$wid)

    d$bd <- d$bd + d$wid
    collide <- which(d$bd == end + d$hei)
    d$bd[collide] <- d$bd[collide] - ((d$hei - 1) * d$wid)
    collide <- which(d$map[d$bd] == 35)
    d$bd[collide] <- d$bd[collide] - ((d$hei - 2) * d$wid)

    d$map[d$map != 35] <- 46
    d$map[c(d$bd, d$bu, d$bl, d$br)] <- 66
    explore <- which(next_step != 0)
    next_step <- next_step * 0

    for (point in explore) {
      if (point == end) return(list(d = d, steps = steps))

      if (d$map[point] == 46) next_step[point] <- 1
      if (d$map[point + 1] == 46) next_step[point + 1] <- 1
      if (d$map[point - 1] == 46) next_step[point - 1] <- 1

      if ((point < cells - d$wid) && (d$map[point + d$wid] == 46))
        next_step[point + d$wid] <- 1
      if ((point > d$wid) && (d$map[point - d$wid] == 46))
        next_step[point - d$wid] <- 1
    }
    steps <- steps + 1
  }
}

part1 <- function(d) {
  shortest(d, d$start, d$end)
}

part2 <- function(d2) {
  count <- d2$steps
  res <- shortest(d2$d, start = d2$d$end, end = d2$d$start)
  count <- count + res$steps + 1
  res <- shortest(res$d, start = d2$d$start, end = d2$d$end)
  count <- count + res$steps + 1
  count
}

d <- parse("../inputs/input_24.txt")
res <- part1(d)
c(res$steps, part2(res))
