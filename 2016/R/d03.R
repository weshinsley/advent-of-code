d <- read.csv("../inputs/input_3.txt", header = FALSE, sep = "",
              col.names = c("a", "b", "c"))
solve <- function(d, part2 = FALSE) {
  if (part2) {
    d <- data.frame(matrix(c(d$a, d$b, d$c), ncol = 3, byrow = TRUE))
    names(d) <- c("a", "b", "c")
  }
  sum((d$a + d$b > d$c) & (d$b + d$c > d$a) & (d$a + d$c > d$b))               
}

c(solve(d), solve(d, TRUE))
