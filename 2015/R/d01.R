d <- ifelse(unlist(strsplit(
  readLines("../Java/d01/input.txt", warn = FALSE), "")) == "(", 1, -1)

c(sum(d), which(cumsum(d) == -1)[1])

