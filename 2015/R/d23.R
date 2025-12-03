d <- read.csv("../inputs/input_23.txt", sep=" ", header = FALSE, 
              col.names = c("op", "x", "y"))
d$x <- gsub(",", "", d$x)
d$y[d$op == "jmp"] <- d$x[d$op == "jmp"]

solve <- function(part2 = FALSE) {
  S <- list(a = ifelse(part2, 1, 0), b = 0, L = 1)
  
  math <- function(S, x, y, f) { 
    list(L = S$L + 1, a = ifelse(x == "a", f(S$a), S$a), 
                      b = ifelse(x == "b", f(S$b), S$b)) 
  }
  
  jump <- function(S, x, y, f) {
    list(L = ifelse(f(S[[x]]), S$L + as.integer(y), S$L + 1), a = S$a, b = S$b)
  } 

  hlf <- function(S, x, y) { math(S, x, y, function(z) z / 2) }
  tpl <- function(S, x, y) { math(S, x, y, function(z) z * 3) }
  inc <- function(S, x, y) { math(S, x, y, function(z) z + 1) }
  jmp <- function(S, x, y) { jump(S, x, y, function(z) TRUE) }
  jio <- function(S, x, y) { jump(S, x, y, function(z) z == 1) }
  jie <- function(S, x, y) { jump(S, x, y, function(z) z %% 2 == 0) } 
  
  while (S$L <= nrow(d)) {
    S <- do.call(d$op[S$L], list(S = S, x = d$x[S$L], y = d$y[S$L]))
  }
  S$b
}

c(solve(FALSE), solve(TRUE))
