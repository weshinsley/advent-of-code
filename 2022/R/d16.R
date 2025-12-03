parse <- function(f) {
  x <- readLines(f)
  x <- data.frame(valve = substr(x, 7, 8),
                  rate = as.integer(gsub("[; ]", "", substr(x, 24, 26))),
                  to = gsub("[es ]", "", substring(x, 48)))

  x[order(x$valve), ]
}

get_shortest <- function(d, useful) {
  shortest <- matrix(data = 999, nrow = nrow(useful), ncol = nrow(useful))
  for (i in seq_len(nrow(useful))) {
    current <- which(d$valve == useful$valve[i])
    queue <- list()
    head <- 1
    tail <- 2
    queue[[1]] <- list(pos = current, steps = 0)
    best <- rep(999, nrow(d))
    best[current] <- 0
    while (head <= length(queue)) {
      state <- queue[[head]]
      head <- head + 1
      if (best[state$pos] < state$steps) next
      best[state$pos] <- state$steps
      dests <- match(strsplit(d$to[state$pos], ",")[[1]], d$valve)
      for (dest in dests) {
        if (best[dest] > state$steps + 1) {
          queue[[tail]] <- list(pos = dest, steps = state$steps + 1)
          tail <- tail + 1
        }
      }
    }
    best <- best[d$valve == "AA" | d$rate > 0]
    shortest[, i] <- best
    # shortest[3,1] is shortest valve AA to CC - but is symmetrical...
  }
  shortest
}

do_dfs <- function(time_left, useful, shortest) {
  history <- new.env(parent = emptyenv())
  history$best <- rep(0, 65535)
  dfs <- function(start, time_left, state, pressure, useful, shortest) {
    leftovers <- sum(useful$rate[bitwAnd(useful$valve, state) == 0]) * time_left
    if ((leftovers + pressure) <= history$best[state + 1]) return()

    history$best[state + 1] <- max(history$best[state + 1], pressure)

    for (i in 2:nrow(useful)) {
      if (bitwAnd(useful$valve[i], state)) next
      time_left2 <- time_left - shortest[start, i] - 1
      if (time_left2 > 0)
        dfs(i, time_left2, bitwOr(state, useful$valve[i]),
            pressure + (time_left2 * useful$rate[i]), useful, shortest)
    }
    history$best
  }
  dfs(1, time_left, 0, 0, useful,shortest)
}

part1 <- function(useful, shortest) {
  useful$valve <- 2 ^ (seq_len(nrow(useful)) - 1)
  max(do_dfs(30, useful, shortest))
}

part2 <- function(useful, shortest) {
  useful$valve <- 2 ^ (seq_len(nrow(useful)) - 1)
  best <- do_dfs(26, useful, shortest)

  max(unlist(lapply(which(best > 0) - 1, function(x) {
    max(best[1 + x] + best[bitwAnd(x, 0:sum(useful$valve)) == 0])
  })), na.rm = TRUE)
}

d <- parse("../inputs/input_16.txt")
useful <- d[d$valve == "AA" | d$rate > 0, c("valve", "rate")]
shortest <- get_shortest(d, useful)

c(part1(useful, shortest), part2(useful, shortest))
