n <- as.integer(readLines("../inputs/input_13.txt"))

solve <- function(part2 = FALSE) {
  x <- 1
  y <- 1
  history <- new.env(hash = TRUE)
  assign("1,1", 0, envir = history)
  dx <- c(1, 0, -1, 0)
  dy <- c(0, 1, 0, -1)
  queue <- list(c(1, 1, 0))
  head <- 1
  tail <- 2
  while (TRUE) {
    if (head > length(queue)) {
      browser()
    }
    p <- queue[[head]]
    head <- head + 1
    for (i in 1:4) {
      p2 <- p
      p2[1] <- p2[1] + dx[i]
      p2[2] <- p2[2] + dy[i]
      p2[3] <- p2[3] + 1
      if ((!part2) && (p2[1] == 31) && (p2[2] == 39)) {
        return(p2[3])
      }
      if ((part2) && (p2[3] == 51)) {
        return(length(queue))
      }
      if ((p2[1] < 0) || (p2[2] < 0) || 
         (exists(paste(p2[1], p2[2], sep=","), envir = history))) {
        next
      }
      v <- n + (p2[1]*p2[1]) + (3*p2[1]) + (2*p2[1]*p2[2]) + p2[2] + (p2[2]*p2[2])
      if (sum(as.integer(intToBits(v))) %% 2 == 0) {
        queue[[tail]] <- p2
        tail <- tail + 1
      }
      assign(paste(p2[1], p2[2], sep=","), 0, envir = history)
    }
  }
}

c(solve(), solve(TRUE))
