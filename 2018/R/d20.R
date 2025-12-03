scan <- function(input, pos, start_x, start_y, dist, d) {
  XD <- c(0, 1, 0, -1)
  YD <- c(-1, 0, 1, 0)
  chs <- c('N','E','S','W')
  current_x <- start_x
  current_y <- start_y
  remember_d <- d

  if ((dist[current_y, current_x] == -1) || (dist[current_y, current_x] > d))
    dist[current_y, current_x] <- d

  while (TRUE) {
    ch <- input[pos]
    pos <- pos + 1

    if (ch %in% chs) {
      dir <- which(ch == chs)
      current_x <- current_x + XD[dir]
      current_y <- current_y + YD[dir]
      d <- d + 1
      if ((dist[current_y, current_x] == -1) || (dist[current_y, current_x] > d))
        dist[current_y, current_x] <- d

    } else if (ch == '|') {
      current_x <- start_x
      current_y <- start_y
      d <- remember_d

    } else if (ch == '(') {
      res <- scan(input, pos, current_x, current_y, dist, d)
      pos <- res[[1]]
      dist <- res[[2]]
      d <- res[[3]]

    } else if ((ch == ')') || (ch=='$')) {
      return(list(pos, dist, d))

    }
  }
}

advent20 <- function(input) {
  dist <- matrix(nrow = 200, ncol = 200, data = -1)
  res <- scan(input, 2, 100, 100, dist, 0)
  c(max(res[[2]]), sum(res[[2]] >= 1000))
}

advent20(unlist(strsplit(readLines("../inputs/input_20.txt"), "")))
