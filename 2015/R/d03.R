d <- unlist(strsplit(readLines("../Java/d03/input.txt"), ""))
d <- c(1, -1, length(d), -length(d))[match(d, c(">", "<", "^", "v"))]
 
c(sum(table(c(0, cumsum(d))) > 0),
  sum(table(c(0, cumsum(d[c(TRUE, FALSE)]), 
              0, cumsum(d[c(FALSE, TRUE)]))) > 0))
