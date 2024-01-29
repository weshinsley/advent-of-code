# TO-DO - this one is broken!

parse_input <- function(f) {
  d <- readLines(f)
  matrix(as.integer(strsplit(paste0(d, collapse = ""), "")[[1]]),
         nrow = length(d), ncol = nchar(d[[1]]), byrow = TRUE)
}

part <- function(d) {
  state <- list(x = 1, y = 1, steps = 0, )
}


part1 <- function(d) {
  wid <- ncol(d)
  hei <- nrow(d)
  dx <- c(1, 0, -1, 0)
  dy <- c(0, 1, 0, -1)

  best <- 0
  top1 <- 1:wid
  top1 <- top1[top1 %% 4 != 0]
  top2 <- top1 + 2
  top2 <- top2[top2 <= wid]
  best <- sum(d[1, top1]) + sum(d[2, top2]) + sum(d[wid, top1]) + sum(d[wid - 1, top2])

 # for (i in 1:wid) {
#    best <- best + d[i, i]
#    if (i < wid) best <- best + d[i, i + 1]
#  }
  message(best)
  best <- min(750, best)
  message(best)
  bestm <- (d * 0) + best
  bestm <- list(bestm, bestm, bestm)

  work <- list(list(x = 1, y = 1, dir = 1, steps = 0, tot = 0))
  at <- 1
  len <- 1
  while (at <= len) {
    here <- work[[at]]
    at <- at + 1
    #work[[1]] <- NULL
    #len <- len - 1
    if ((here$tot >= best) || (here$x < 1) || (here$y < 1) ||
        (here$x > wid) || (here$y > hei)) {
      next
    }

    if (here$tot >= bestm[[here$steps + 1]][here$y, here$x]) {
      next
    }
    bestm[[here$steps + 1]][here$y, here$x] <- here$tot
    if ((here$x == wid) && (here$y == hei)) {
      best <- min(best, here$tot)
      message(best)
      next
    }

    if (here$steps < 2) {
      if ((here$x + dx[here$dir] >= 1) && (here$x + dx[here$dir] <= wid) &&
          (here$y + dy[here$dir] >= 1) && (here$y + dy[here$dir] <= hei)) {
        newtot <- here$tot + d[here$y + dy[here$dir], here$x + dx[here$dir]]
        if (newtot < best) {

          len <- len + 1
          work[[len]] <- list(x = here$x + dx[here$dir], y = here$y + dy[here$dir],
                            dir = here$dir, steps = here$steps + 1,
                            tot = newtot)
        }
      }
    }

    here$dir <- (here$dir %% 4) + 1
    if ((here$x + dx[here$dir] >= 1) && (here$x + dx[here$dir] <= wid) &&
        (here$y + dy[here$dir] >= 1) && (here$y + dy[here$dir] <= hei)) {
      newtot <- here$tot + d[here$y + dy[here$dir], here$x + dx[here$dir]]
      if (newtot < best) {
        len <- len + 1
        work[[len]] <- list(x = here$x + dx[here$dir], y = here$y + dy[here$dir],
                              dir = here$dir, steps = 0,
                              tot = newtot)
      }
    }

    here$dir <- (here$dir %% 4) + 1
    here$dir <- (here$dir %% 4) + 1
    if ((here$x + dx[here$dir] >= 1) && (here$x + dx[here$dir] <= wid) &&
        (here$y + dy[here$dir] >= 1) && (here$y + dy[here$dir] <= hei)) {
      newtot <- here$tot + d[here$y + dy[here$dir], here$x + dx[here$dir]]
      if (newtot < best) {
        len <- len + 1

        work[[len]] <- list(x = here$x + dx[here$dir], y = here$y + dy[here$dir],
                          dir = here$dir, steps = 0,
                          tot = newtot)
      }
    }
  }
  best
}

part2 <- function(d) {
  0
}

test <- function() {
  d <- parse_input("../inputs/d17-test.txt")
  stopifnot(part1(d) == 102)
  #stopifnot(part2(d) == 51)
}

test()
d <- parse_input("../inputs/d17-input.txt")
part1(d)
part2(d)
