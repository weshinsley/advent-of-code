d <- readLines("../inputs/input_5.txt")
s <- lapply(d, function(x) strsplit(x, "")[[1]])
n <- lapply(s, function(x) unlist(lapply(x, utf8ToInt)))
p2 <- lapply(d, function(x) substring(x, 1:(nchar(x)), 2:(nchar(x))))
p2a <- lapply(p2, function(x) {
  unlist(lapply(seq_along(x), function(y) {
    w <- which(x == x[y])
    w <- w[!w %in% c(y - 1, y, y + 1)]
    length(w) > 0
  }))
})

p2b <- lapply(n, function(x) {
  unlist(lapply(seq_along(x), function(y) {
    (y+2) %in% which(x == x[y])
  }))
})

c(sum(unlist(lapply(seq_along(d), function(x) {
  (sum(table(s[[x]])[c("a","e","i","o","u")], na.rm = TRUE) > 2) &
  (0 %in% diff(n[[x]])) &
  (0 == grepl("ab", d[[x]]) + grepl("cd", d[[x]]) + 
        grepl("pq", d[[x]]) + grepl("xy", d[[x]]))
  }))),

  sum(unlist(lapply(seq_along(d), function(x) {
    sum(p2a[[x]] > 0) & sum(p2b[[x]] > 0)
}))))
    