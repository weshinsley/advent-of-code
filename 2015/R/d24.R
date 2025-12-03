d <- rev(sort(as.integer(readLines("../inputs/input_24.txt"))))

best <<- prod(d)

explore <- function(d, len, targ, sofar = NULL) {
  full <- (length(sofar) == len)
  s <- sum(sofar)
  for (i in seq_along(d)) {
    if (s + d[i] == targ) {
      pr <- prod(sofar * d[i])
      if (pr < best) {
        # Apparently, the others can always be balanced... (why?)
        best <<- pr
      }
      return()
    } else if ((!full) && (s + d[i] < targ)) {
      explore(d[-i], len, targ, c(sofar, d[i]))
    }
  }
}

solve <- function(d, groups) {
  target <- sum(d) / groups
  small_group_size <- which(cumsum(d) >= target)[1]
  best <<- prod(d)
  explore(d, small_group_size, target)
  best
}

c(solve(d,3), solve(d, 4))
