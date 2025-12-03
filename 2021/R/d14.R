read_input <- function(f) {
  d <- gsub(" -> ", ",", readLines(f))
  target <- strsplit(d[1], "")[[1]]
  rules <- read.csv(text = d[3:length(d)], header = FALSE,
                    col.names = c("from", "to"))
  list(target = target, rules = rules)
  
}

solve_slow <- function(target, rules, n) {
  
  step <- function(t, rules) {
    t2 <- NULL
    for (i in seq_len(length(t) - 1)) {
      t2 <- c(t2, t[i], rules$to[rules$from == paste0(t[i], t[i+1])])
    }
    c(t2, t[length(t)])
  }
  
  for (i in seq_len(n)) {
    target <- step(target, rules)
  }
  x <- table(target)
  max(x) - min(x)
}

solve_fast <- function(t, rules, n) {
  rules$freq <- 0
  for (i in seq_len(length(t) - 1)) {
    ind <- rules$from == paste0(t[i], t[i+1])
    rules$freq[ind] <- rules$freq[ind] + 1
  }
  
  rules2 <- rules
  for (steps in seq_len(n)) {
    rules2$freq <- 0
    for (j in seq_len(nrow(rules))) {
      if (rules$freq[j] > 0) {
        r <- rules$from[j]
        r1 <- which(rules2$from == paste0(substring(r, 1, 1), rules$to[j]))
        r2 <- which(rules2$from == paste0(rules$to[j], substring(r, 2, 2)))
        rules2$freq[r1] <- rules2$freq[r1] + rules$freq[j]
        rules2$freq[r2] <- rules2$freq[r2] + rules$freq[j]
      }    
    }
    rules <- rules2
  }
  final <- data.frame(ch = unique(rules$to), freq = 0)
  for (i in seq_len(nrow(rules))) {
    ind = which(final$ch == substring(rules$from[i], 1, 1))
    final$freq[ind] <- final$freq[ind] + rules$freq[i]
  }
  
  last <- which(final$ch == t[length(t)])
  final$freq[last] <- final$freq[last] + 1
  max(final$freq) - min(final$freq)
}

options(digits = 14)

part1 <- function(t, r, n = 10) {
  solve_fast(t, r, n)
}

part2 <- function(t, r) {
  part1(t, r, 40)
}

d <- read_input("../inputs/input_14.txt")
c(part1(d$target, d$rules), part2(d$target, d$rules))
