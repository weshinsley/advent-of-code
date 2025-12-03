parse_input <- function(f) {
  x <- readLines(f)
  blank <- which(x == "")
  start <- c(1, blank + 1)
  end <- c(blank - 1, length(x))
  maps <- list()
  for (m in seq_along(start)) {
    xsize <- nchar(x[start[m]])
    ysize <- 1 + (end[m] - start[m])
    maps[[m]] <- matrix(
      as.integer(strsplit(
        paste0(x[start[m]:end[m]], collapse = ""), "")[[1]] == "#"),
      nrow = ysize, ncol = xsize, byrow = TRUE)
  }
  maps
}

reflects <- function(s) {
  res <- rep(FALSE, length(s))
  for (i in seq(1.5, length(s) - 0.5)) {
    left <- s[1:floor(i)]
    right <- s[ceiling(i):length(s)]
    size <- min(length(left), length(right))
    left <- left[(1 + length(left) - size):length(left)]
    right <- right[1:size]
    res[floor(i)] <- all(left == rev(right))
  }
  which(res)
}

get_score <- function(map) {
  score <- 0
  hrefs <- seq_len(ncol(map))
  vrefs <- seq_len(nrow(map))

  for (j in seq_len(nrow(map))) {
    hrefs <- hrefs[hrefs %in% reflects(map[j, ])]
  }

  for (i in seq_len(ncol(map))) {
    vrefs <- vrefs[vrefs %in% reflects(map[, i])]
  }

  score <- 0
  if (length(hrefs) > 0) score <- score + hrefs
  if (length(vrefs) > 0) score <- score + (100 * vrefs)

  list(hrefs = hrefs, vrefs = vrefs, score = score)
}

part1 <- function(d, p2 = FALSE) {
  tot <- 0
  for (m in seq_along(d)) {
    map <- d[[m]]
    score <- get_score(map)
    if (p2) {
      done <- FALSE
      for (i in seq_len(ncol(map))) {
        if (done) break
        for (j in seq_len(nrow(map))) {
          map[j, i] <- (1 - map[j, i])
          score2 <- get_score(map)

          if (length(score2$hrefs) + length(score2$vrefs) > 1) {
            score2$hrefs <- setdiff(score2$hrefs, score$hrefs)
            score2$vrefs <- setdiff(score2$vrefs, score$vrefs)
            if (length(score2$hrefs) == 1) {
              score2$score <- score2$hrefs
            } else {
              score2$score <- score2$vrefs * 100
            }
            score$score <- score2$score
            done <- TRUE
            break
          }

          if ((length(score2$score) == 1) && (score2$score != 0) &&
               (score2$score != score$score)) {
            score$score <- score2$score
            done <- TRUE
            break
          }
          map[j, i] <- 1 - map[j, i]
        }
      }
    }
    tot <- tot + score$score
  }
  tot
}

part2 <- function(d) {
  part1(d, TRUE)
}

d <- parse_input("../inputs/input_13.txt")
c(part1(d), part2(d))
