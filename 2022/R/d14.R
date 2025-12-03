parse <- function(f) {
  lapply(readLines(f), function(x) {
    x <- strsplit(x, " -> ")[[1]]
    lapply(x, function(x) as.integer(strsplit(x, ",")[[1]]))
  })
}

part1 <- function(d, part2 = FALSE) {
  maxy <- 1
  sand <- matrix(data = 0, nrow = 180, ncol = 700)
  for (g in seq_along(d)) {
    draw <- d[[g]]
    ox <- draw[[1]][1]
    oy <- draw[[1]][2] + 1
    maxy <- max(oy, maxy)
    for (h in 2:length(draw)) {
      px <- draw[[h]][1]
      py <- draw[[h]][2] + 1
      maxy <- max(py, maxy)

      sand[oy:py, ox:px] <- 1
      ox <- px
      oy <- py
    }
  }

  if (part2) {
    sand[maxy + 2, 1:700] <- 1
    maxy <- maxy + 2
  }

  g <- 0
  abyss <- FALSE

  while (!abyss) {
    x <- 500
    y <- 1
    if (sand[y, x] != 0) break
    while (TRUE) {
      if (y >= maxy) {
        abyss <- TRUE
        break
      }

      if (sand[y + 1, x] == 0) {
        y <- y + 1
      } else if (sand[y + 1, x - 1] == 0) {
        x <- x - 1
        y <- y + 1
      } else if (sand[y + 1, x + 1] == 0) {
        x <- x + 1
        y <- y + 1
      } else {
        break
      }
    }
    if (!abyss) {
      sand[y, x] <- 2
      g <- g + 1
    }
  }
  g
}

part2 <- function(d) part1(d, TRUE)

d <- parse("../inputs/input_14.txt")
c(part1(d), part2(d))
