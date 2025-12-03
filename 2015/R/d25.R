rc <- as.numeric(strsplit(gsub("[,.]", "", 
  readLines("../inputs/input_25.txt")), " ")[[1]][c(17, 19)])
  
i <- 2
n <- 0
while (i <= rc[2]) {
  n <- n + i
  i <- i + 1
}
j <- 0
while (j < (rc[1] - 1)) {
  n <- n + j + rc[2]
  j <- j + 1
}

x <- 20151125
i <- 0

while (i < n) {
  x <- (x * 252533) %% 33554393
  i <- i + 1
}
x

