solve <- function(d, n) {
  set <- new.env()
  for (i in 1:(length(d)-1)) {
    set[[d[i]]] <- i
  }
  count <- length(d)
  next_val <- d[length(d)]
  while (count < n) {
    prev <- set[[next_val]]
    set[[next_val]] <- count
    next_val <- ifelse(is.null(prev), "0", as.character(count - prev))
    count <- count + 1
  }
  next_val
}

wes <- as.character(strsplit(readLines("../inputs/input_15.txt"), ",")[[1]])
c(solve(wes, 2020), solve(wes, 30000000))
