parse <- function(f) {
  d <- readLines(f)
  d <- matrix(data = utf8ToInt(paste0(d, collapse = "")),
              nrow = length(d), byrow = TRUE)
  d[d == 35] <- 1
  d[d == 46] <- 0

  # This makes a nice movie and matrix
  # size for my data...

  d2 <- matrix(0, ncol = 150, nrow = 150)
  d2[15:(14 + nrow(d)), 15:(14 + ncol(d))] <- d
  d2
}

prop <- function(elfm, round, x, y) {
  first <- (round - 1) %% 4
  for (i in 0:3) {
    dir <- (first + i) %% 4
    if ((dir == 0) && (sum(elfm[1, ]) == 0)) return(c(x, y - 1))
    if ((dir == 1) && (sum(elfm[3, ]) == 0)) return(c(x, y + 1))
    if ((dir == 2) && (sum(elfm[, 1]) == 0)) return(c(x - 1, y))
    if ((dir == 3) && (sum(elfm[, 3]) == 0)) return(c(x + 1, y))
  }
  c(NA, NA)
}

part1 <- function(d, part2 = FALSE, movie = FALSE) {
  wid <- ncol(d)
  hei <- nrow(d)
  elves <- which(d == 1)
  elfy <- ((elves - 1) %% hei) + 1
  elfx <- ((elves - 1) %/% hei) + 1
  elfd <- 1

  propx <- rep(NA, length(elves))
  propy <- rep(NA, length(elves))

  round <- 1
  while (TRUE) {
    moved <- FALSE
    propm <- d * 0
    for (i in seq_along(elves)) {
      x <- elfx[i]
      y <- elfy[i]
      elfm <- d[(y - 1):(y + 1), (x - 1):(x + 1)]
      if (sum(elfm) == 1) {
        propx[i] <- NA
        propy[i] <- NA
        next
      }
      res <- prop(elfm, round, x, y)
      propx[i] <- res[1]
      propy[i] <- res[2]
      if (!is.na(propx[i])) propm[res[2], res[1]] <- propm[res[2], res[1]] + 1
    }

    for (i in seq_along(elves)) {
      if (is.na(propx[i])) next
      if (propm[propy[i], propx[i]] > 1) next
      d[elfy[i], elfx[i]] <- 0
      d[propy[i], propx[i]] <- 1
      elfx[i] <- propx[i]
      elfy[i] <- propy[i]
      moved <- TRUE
    }

    if ((round == 10) && (!part2)) {
      rx <- range(elfx)
      ry <- range(elfy)
      return(((rx[2] - rx[1]) + 1)  * ((ry[2] - ry[1]) + 1) - length(elfx))
    }

    if ((!moved) && (part2)) return(round)

    if (movie) {
      png(sprintf("out_%s.png", round),
          width = ncol(d) * 5, height = nrow(d) * 5)
      plot(x = NA, y = NA, xlim = c(0, ncol(d)), ylim = c(0, nrow(d)),
           xlab = "", ylab = "", xaxt = "n", yaxt = "n")
      for (j in seq_len(nrow(d))) {
        row <- d[j, ]
        e <- which(row == 1)
        points(e, rep(j, length(e)), pch = 19, col = "darkgreen")
      }
      dev.off()
    }
    round <- round + 1
  }
}

part2 <- function(d) {
  part1(d, TRUE)
}

d <- parse("../inputs/input_23.txt")
c(part1(d), part2(d))
