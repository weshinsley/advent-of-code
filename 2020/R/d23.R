d <- as.numeric(strsplit(readLines("../inputs/input_23.txt")[1], "")[[1]])

solve <- function(d, part2 = FALSE) {
  if (part2) {
    d <- c(d, (max(d)+1):1000000)
  }
  n_cups <- length(d)
  next_cup <- rep(NA, n_cups)
  for (i in seq_len(n_cups)) {
    next_cup[d[i]] <- d[ifelse(i == length(d), 1, i + 1)]
  }
  i <- 0 
  turns <- ifelse(!part2, 100, 10000000)
  current <- d[1]
  while (i < turns) {
    pickup <- c(next_cup[current], 
                next_cup[next_cup[current]],
                next_cup[next_cup[next_cup[current]]])
    dest <- ifelse(current == 1, length(d), current - 1)
    while (dest %in% pickup) {
      dest <- ifelse(dest == 1, length(d), dest - 1)
    }
    leftover <- next_cup[dest]
    next_cup[dest] <- pickup[1]
    next_cup[current] <- next_cup[pickup[3]]
    next_cup[pickup[3]] <- leftover
    current <- next_cup[current]
    i <- i + 1
  }
  
  first <- next_cup[1]
  if (!part2) {
    res <- NULL
    for (i in (seq_len(length(d)-1))) {
      res <- c(res, first)
      first <- next_cup[first]
    }
    return(paste0(res, collapse = ""))
  } else {
    options(digits = 12)
    return(first * next_cup[first])
  }
}
c(solve(d), solve(d, TRUE))
