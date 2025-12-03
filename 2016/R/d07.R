d <- strsplit(gsub("\\]", ",", gsub("\\[", ",", 
       readLines("../inputs/input_7.txt"))), ",")

abba <- function(s) {
  s <- strsplit(s, "")[[1]]
  for (i in seq(length(s)-3)) {
    if ((s[i] != s[i+1]) && (s[i+1] == s[i+2]) && (s[i+3] == s[i])) {
      return(TRUE)
    }
  }
  FALSE
}

tls <- function(s) {
  odds <- unlist(lapply(seq(1, length(s), by = 2), function(x) abba(s[x])))
  evens <- unlist(lapply(seq(2, length(s), by = 2), function(x) abba(s[x])))
  any(odds) & all(!evens)
}

aba <- function(s, hyper = FALSE) {
  s <- strsplit(s, "")[[1]]
  res <- NULL
  for (i in seq(length(s)-2)) {
    if ((s[i] != s[i+1]) && (s[i] == s[i+2])) {
      res <- unique(c(res, ifelse(hyper, paste0(s[i], s[i+1], s[i]),
                                         paste0(s[i+1], s[i], s[i+1]))))
    }
  }
  res
}

ssl <- function(s) {
  odds <- unlist(lapply(seq(1, length(s), by = 2), function(x) aba(s[x], FALSE)))
  evens <- unlist(lapply(seq(2, length(s), by = 2), function(x) aba(s[x], TRUE)))
  length(intersect(odds, evens)) > 0
}
  
c(sum(unlist(lapply(d, tls))), sum(unlist(lapply(d, ssl))))

