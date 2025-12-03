parse <- function(f) {
  m <- lapply(readLines(f), utf8ToInt)
  matrix(unlist(m), nrow = length(m), byrow = TRUE)
}

index_to_pos <- function(i, sizex, sizey) {
  c(((i - 1) %/% sizey) + 1, ((i - 1) %% sizey) + 1)
}

solve <- function(d, start = which(unlist(d) == utf8ToInt("E"))) {
  start <- index_to_pos(start, ncol(d), nrow(d))
  end <- index_to_pos(which(unlist(d) == utf8ToInt("S")), ncol(d), nrow(d))

  d[start[2], start[1]] <- utf8ToInt("z")
  d[end[2], end[1]] <- utf8ToInt("a")

  best <- nrow(d) * ncol(d)
  steps <- d + best
  steps[start[2], start[1]] <- 0

  queue <- list()
  queue[[1]] <- list(pos = start, steps = 0)
  qpos <- 1
  tail <- 2

  while (qpos <= length(queue)) {
    state <- queue[[qpos]]
    qpos <- qpos + 1
    cx <- state$pos[1]
    cy <- state$pos[2]

    if (all(c(cx, cy) == end)) {
      best <- min(best, state$steps)
      next
    }

    if (state$steps >= best) next

    for (dir in 1:4) {
      tx <- cx + c(0, 1, 0, -1)[dir]
      ty <- cy + c(1, 0, -1, 0)[dir]
      if ((tx * ty == 0) || (tx > ncol(d)) || (ty > nrow(d)) ||
       ((d[cy, cx] - d[ty, tx]) > 1) || (steps[ty, tx] <= state$steps + 1)) next

      queue[[tail]] <- list(pos = c(tx, ty), steps = state$steps + 1)
      steps[ty, tx] <- state$steps + 1
      tail <- tail + 1
    }
  }

  c(best, min(unlist(steps)[unlist(d) == utf8ToInt("a")]))
}

part1 <- function(res) res[1]
part2 <- function(res) res[2]

d <- solve(parse("../inputs/input_12.txt"))
c(part1(d), part2(d))
