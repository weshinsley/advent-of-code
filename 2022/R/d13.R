interp <- function(f) {
  x <- readLines(f)
  x <- x[x != ""]
  lapply(x, function(x) {
    eval(parse(text = gsub("\\[", "list(", gsub("\\]", ")", x))))
  })
}

result <- function(r1, r2) {
  if (r1 < r2) 1 else if (r1 == r2) 2 else 3
}

compare <- function(e1, e2) {
  if (is.numeric(e1)) {
    if (is.numeric(e2)) return(result(e1, e2))
    return(compare(list(e1), e2))
  }

  if (is.numeric(e2)) return(compare(e1, list(e2)))

  for (i in seq_len(min(length(e1), length(e2)))) {
    res <- compare(e1[[i]], e2[[i]])
    if (res != 2) return(res)
  }

  return(result(length(e1), length(e2)))

}

# This is a great insertion sort, but as Rich
# pointed out, we don't need to sort the whole list,
# just see where the two new ones fit (how many things
# go before them)

# sort <- function(d) {
#   for (i in seq_len(length(d) - 1)) {
#     best <- i
#     for (j in i:length(d)) {
#       if (compare(d[[j]], d[[best]]) == 1) best <- j
#     }
#     if (best != i) {
#       swap <- d[[i]]
#       d[[i]] <- d[[best]]
#       d[[best]] <- swap
#     }
#   }
#   d
# }

part1 <- function(d) {
  sum(which(unlist(lapply(seq(1, length(d), by = 2), function(x) {
    compare(d[[x]], d[[x + 1]])})) == 1))
}

part2 <- function(d) {
  thing_2 <- list(list(2))
  thing_6 <- list(list(6))

  before_2 <- 1 + sum(unlist(lapply(d, function(x) compare(x, thing_2) == 1)))
  before_6 <- 2 + sum(unlist(lapply(d, function(x) compare(x, thing_6) == 1)))

  before_2 * before_6
}

d <- interp("../inputs/input_13.txt")
c(part1(d), part2(d))
