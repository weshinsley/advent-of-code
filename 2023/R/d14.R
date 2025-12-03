parse_input <- function(f) {
  d <- readLines(f)
  wid <- nchar(d[1])
  hei <- length(d)
  d <- strsplit(paste0(d, collapse = ""), "")[[1]]
  list(wid = wid, hei = hei,
       rocks = which(d == "O") - 1,
       cubes = which(d == "#") - 1)
}

dump <- function(d) {
  x <- rep(".", d$wid * d$hei)
  x[1 + d$rocks] <- "O"
  x[1 + d$cubes] <- "#"
  for (y in seq_len(d$hei)) {
    message(paste0(x[(1 + ((y - 1) * d$wid)):(y * d$wid)], collapse = ""))
  }
}

part1 <- function(d, pt = 1) {
  burn_in <- 100
  hist <- rep(0, 150)
  memo <- new.env()
  cycle <- 1
  deltas <- c(-d$wid, -1, d$wid, 1)
  dir <- c("N", "W", "S", "E")
  filters <- list(
    "N" = function() which(d$rocks >= d$wid),
    "W" = function() which(d$rocks %% d$wid > 0),
    "S" = function() which(d$rocks < (d$wid * (d$hei - 1))),
    "E" = function() which(d$rocks %% d$wid < (d$wid - 1))
  )
  n <- 1

  moved <- TRUE
  while (TRUE) {
    while (moved) {
      delta <- deltas[n]
      moved <- FALSE
      potentials <- filters[[dir[n]]]()
      rpos <- d$rocks[potentials]
      rpos <- rpos + delta
      rpos[rpos %in% d$rocks | rpos %in% d$cubes] <- NA
      replace <- which(!is.na(rpos))
      if (length(replace) > 0) {
        moved <- TRUE
        d$rocks[potentials[replace]] <- rpos[replace]
      }

      if (!moved) {
        if (pt == 1) return(sum(d$hei - d$rocks %/% d$wid))

        if (dir[n] == "E") {
          score <- sum(d$hei - d$rocks %/% d$wid)
          hist[cycle] <- score
          if (cycle > burn_in) {
            key <- paste0(sort(d$rocks), collapse = "_")
            if (exists(key, memo)) {
              first <- get(key, memo)
              seqlen <- cycle - first
              return(hist[first + (1000000000 - first) %% seqlen])
            } else {
              assign(key, cycle, memo)
            }
          }
          cycle <- cycle + 1
        }

        n <- if (n == 4) 1 else (n + 1)
        moved <- TRUE
      }
    }
  }
}

part2 <- function(d) {
  part1(d, 1000000000)
}

d <- parse_input("../inputs/input_14.txt")
c(part1(d), part2(d))
