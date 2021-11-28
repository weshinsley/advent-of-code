library(crayon)

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

test <- function() {
  stopifnot(solve(c("0","3","6"), 2020) == "436")
  stopifnot(solve(c("1","3","2"), 2020) == "1")
  stopifnot(solve(c("2","1","3"), 2020) == "10")
  stopifnot(solve(c("1","2","3"), 2020) == "27")
  stopifnot(solve(c("2","3","1"), 2020) == "78")
  stopifnot(solve(c("3","2","1"), 2020) == "438")
  stopifnot(solve(c("3","1","2"), 2020) == "1836")
  stopifnot(solve(c("0","3","6"), 30000000) == "175594")
  stopifnot(solve(c("1","3","2"), 30000000) == "2578")
  stopifnot(solve(c("2","1","3"), 30000000) == "3544142")
  stopifnot(solve(c("1","2","3"), 30000000) == "261214")
  stopifnot(solve(c("2","3","1"), 30000000) == "6895259")
  stopifnot(solve(c("3","2","1"), 30000000) == "18")
  stopifnot(solve(c("3","1","2"), 30000000) == "362")
}

  # test()
wes <- as.character(strsplit(readLines("../Java/d15/wes-input.txt"), ",")[[1]])
cat(red("\nAdvent of Code 2020 - Day 15\n"))
cat(blue("----------------------------\n\n"))
cat("Part 1:", green(solve(wes, 2020)), "\n")
cat("Part 2:", green(solve(wes, 30000000)), "\n")
