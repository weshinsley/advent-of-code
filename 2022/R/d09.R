parse <- function(f) {
  d <- strsplit(readLines(f), " ")
  unlist(lapply(d, function(x) rep(x[1], as.integer(x[2]))))
}

move <- function(xy, dir) {
  c(xy[1] + if (dir == "R") 1 else if (dir == "L") -1 else 0,
    xy[2] + if (dir == "D") 1 else if (dir == "U") -1 else 0)
}

follow <- function(hxy, txy) {
  if ((abs(txy[1] - hxy[1]) <= 1) &&
     (abs(txy[2] - hxy[2]) <= 1))
    return(txy)

  if (hxy[1] == txy[1])
    return(c(txy[1], txy[2] + sign(hxy[2] - txy[2])))

  if (hxy[2] == txy[2])
    return(c(txy[1] + sign(hxy[1] - txy[1]), txy[2]))

  c(txy[1] + sign(hxy[1] - txy[1]),
    txy[2] + sign(hxy[2] - txy[2]))
}

part1 <- function(d) {
  history <- rep(0, length(d))
  hxy <- c(0, 0)
  txy <- c(0, 0)
  for (n in seq_along(d)) {
    hxy <- move(hxy, d[n])
    txy <- follow(hxy, txy)
    history[n] <- (txy[1] * 1000) + txy[2]
  }
  length(unique(history))
}

part2 <- function(d) {
  lgth <- 0
  history <- rep(0, length(d))
  knots <- rep(list(c(0, 0)), 10)

  for (n in seq_along(d)) {
    knots[[10]] <- move(knots[[10]], d[n])
    for (k in 10:(10 - lgth)) {
      knots[[k - 1]] <- follow(knots[[k]], knots[[k - 1]])
    }
    history[n] <- knots[[1]][1] * 1000 + knots[[1]][2]
    if (lgth < 8) lgth <- lgth + 1
  }
  length(unique(history))

}

input <- parse("../inputs/input_9.txt")
c(part1(input), part2(input))
