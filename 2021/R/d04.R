parse_input <- function(d) {
  d <- lapply(d, trimws)
  d <- lapply(d, function(x) gsub("  ", " ", x))
  starts <- seq(3, length(d), by = 6)
  cards <- list()
  gone <- list()
  for (i in seq_along(starts)) {
    cards[[i]] <- as.integer(strsplit(
      paste(d[starts[i]:(starts[i]+4)], collapse = " "), "\\s+")[[1]])
    gone[[i]] <- rep(FALSE, length(cards[[i]]))
  }
  list(cards = cards,
       gone = gone,
       score = rep(-1, length(cards)),
       calls = as.integer(strsplit(d[[1]], ",")[[1]]))
}

play <- function(d) {
  win_order <- rep(-1, length(d$cards))
  win_n <- 1
  
  check_end <- function(gone) {
    grid <- matrix(gone, ncol = 5)
    5 %in% c(rowSums(grid), colSums(grid))
  }
  
  for (i in d$calls) {
    for (j in seq_along(d$cards)) {
      if (d$score[j] >= 0) {
        next
      }
      if (i %in% d$cards[[j]]) {
        x <- which(d$cards[[j]] == i)
        d$gone[[j]][x] <- TRUE
        if (check_end(d$gone[[j]])) {
          d$score[j] <- sum(d$cards[[j]][!d$gone[[j]]]) * i
          win_order[win_n] <- j
          win_n <- win_n + 1
          if (win_n > length(d$cards)) {
            return(c(d$score[win_order[1]], 
                     d$score[win_order[win_n - 1]]))
          }
        }
      }
    }
  }
}
part1 <- function(p) { p[1] }
part2 <- function(p) { p[2] }

res <- play(parse_input(readLines("../inputs/input_4.txt")))
c(part1(res), part2(res))
