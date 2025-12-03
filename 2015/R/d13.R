d <- read.csv(text = unlist(lapply(readLines("../inputs/input_13.txt"), 
  function(x) {
    gsub("would gain ", "", gsub("would lose ", "-", 
      gsub("\\.", "", gsub("happiness units by sitting next to ", "", x))))
  })), header = FALSE, sep = " ", col.names = c("p1", "d", "p2"))

solve <- function(seated, rest, d) {
  
  calc <- function(seated, d) {
    score <- 0
    for (i in seq_along(seated)) {
      n1 <- seated[ifelse(i == 1, length(seated), i - 1)]
      n2 <- seated[ifelse(i == length(seated), 1, i + 1)]
      score <- score + sum(d$d[d$p1 == seated[i] & 
                           d$p2 %in% c(n1, n2)])
    }
    score
  }
  
  if (length(rest) == 0) {
    best <<- max(best, calc(seated, d))
    return()
  }
  for (r in rest) {
    solve(c(seated, r), rest[rest!= r], d)
  }
}

seat <- function(d, part2 = FALSE) {
  p <- unique(d$p1)
  if (part2) {
    d <- rbind(d, data.frame(p1 = p, d = 0, p2 = "me"),
                  data.frame(p1 = "me", d = 0, p2 = p))
    p <- c(p, "me")
  }
  best <<- (-999999) 
  solve(p[1], p[-1], d)
  best
}

c(seat(d), seat(d, TRUE))
