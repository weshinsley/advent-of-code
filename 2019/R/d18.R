parse_input <- function(f) {
  map <- lapply(readLines(f), function(x) strsplit(x, "")[[1]])
  wid <- length(map[[1]])
  hei <- length(map)
  squish <- unlist(map)
  interesting <- which(!squish %in% c("#", "."))
  places <- data.frame(
    char = squish[interesting],
    x = 1 + ((interesting - 1) %% wid),
    y = 1 + ((interesting - 1) %/% wid)
  )
  list(map = map, wid = wid, hei = hei, places = places)
}

explore <- function(d, start_ch) {
  x <- d$places$x[d$places$char == start_ch]
  y <- d$places$y[d$places$char == start_ch]
  hist <- rep(d$hei * d$wid, d$hei * d$wid)
  hist[1 + ((y * d$wid) + x)] <- 0
  queue <- list(list(x = x, y = y, s = 0))
  index <- 1
  dx <- c(1, 0, -1, 0)
  dy <- c(0, 1, 0, -1)
  last <- 1
  links <- list()
  while (index <= last) {
    state <- queue[[index]]
    index <- index + 1
    hash <- 1 + ((state$y * d$wid) + state$x)
    if (hist[hash] < state$s) {
      next
    }
    if (!d$map[[state$y]][state$x] %in% c(".", start_ch)) {
      links[[d$map[[state$y]][state$x]]] <-
        min(links[[d$map[[state$y]][state$x]]], state$s)
      next
    }
    for (dir in 1:4) {
      nx <- state$x + dx[dir]
      ny <- state$y + dy[dir]
      if (d$map[[ny]][nx] != '#') {
        hash <- 1 + ((ny * d$wid) + nx)
        if (hist[hash] > state$s + 1) {
          last <- last + 1
          queue[[last]] <- list(x = nx, y = ny, s = state$s + 1)
          hist[hash] <- state$s + 1
        }
      }
    }
  }
  data.frame(from = start_ch, to = names(links), dist = as.numeric(links))
}

part1 <- function(d, p2 = FALSE, best = 99999) {
  net <- as.data.frame(
    data.table::rbindlist(lapply(d$places$char, function(x) explore(d, x))))
  net$key <- unlist(lapply(net$to, utf8ToInt)) >= 97
  tot <- length(unique(net$to[net$key]))
  robots_pos <- if (!p2) "@" else c("!", "$", "%", "&")
  starts <- net[net$from %in% robots_pos & net$key, ]
  queue <- list()
  hist <- new.env()
  assign(paste0(paste0(robots_pos, collapse = ""), "_"), 0, envir = hist)
  for (i in seq_len(nrow(starts))) {
    row <- starts[i, ]
    robot_no <- which(robots_pos == row$from)
    new_robots_pos <- robots_pos
    new_robots_pos[robot_no] <- row$to
    queue[[i]] <- list(at = new_robots_pos, steps = row$dist, keys = row$to)
  }
  index <- 1
  last <- length(queue)
  while (index <= last) {
    state <- queue[[index]]
    index <- index + 1
    dests <- which(net$from %in% state$at &
                  ((net$key) | (tolower(net$to) %in% state$keys) |
                   (net$to %in% c("!", "$", "%", "&", "@"))))

    for (i in dests) {
      nsteps <- state$steps + net$dist[i]
      if (nsteps >= best) {
        next
      }
      nkeys <- state$keys
      if ((net$key[i]) && (!net$to[i] %in% nkeys)) {
        nkeys <- sort(c(nkeys, net$to[i]))
        if (length(nkeys) == tot) {
          best <- min(best, nsteps)
          next
        }
      }
      robot_no <- which(state$at == net$from[i])
      new_robot_pos <- state$at
      new_robot_pos[robot_no] <- net$to[i]

      hash <- paste0(paste0(new_robot_pos, collapse = ""), "_",
                     paste0(nkeys, collapse = ""))
      if (exists(hash, envir = hist)) {
        old_steps <- get(hash, envir = hist)
        if (old_steps <= nsteps) {
          next
        }
      }
      assign(hash, nsteps, envir = hist)

      last <- last + 1
      queue[[last]] <- list(at = new_robot_pos, steps = nsteps,
                            keys = nkeys)

    }
  }
  best
}

part2 <- function(d, best) {
  startx <- d$places$x[d$places$char == "@"]
  starty <- d$places$y[d$places$char == "@"]
  d$map[[starty - 1]][(startx - 1):(startx + 1)] <- c("!", "#", "%")
  d$map[[starty]][(startx - 1):(startx + 1)]     <- c("#", "#", "#")
  d$map[[starty + 1]][(startx - 1):(startx + 1)] <- c("$", "#", "&")
  d$places <- rbind(d$places[d$places$char != "@", ],
   data.frame(x = c(startx - 1, startx - 1, startx + 1, startx + 1),
              y = c(starty - 1, starty + 1, starty - 1, starty + 1),
              char = c("!", "$", "%", "&")))

  part1(d, TRUE, best)
}

d <- parse_input("../inputs/input_18.txt")
res <- part1(d)
c(res, part2(d, res))
