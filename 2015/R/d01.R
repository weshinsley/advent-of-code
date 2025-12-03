d <- ifelse(unlist(strsplit(
  readLines("../inputs/input_1.txt", warn = FALSE), "")) == "(", 1, -1)

c(sum(d), which(cumsum(d) == -1)[1])

