advent1a <- function(s) {
  v1 <- as.numeric(strsplit(s,"")[[1]])
  v2 <- c(0, v1)
  v1[length(v1)+1] <- v1[1]
  sum(v1 * as.numeric(v1==v2))
}

advent1b <- function(s) {
  v1 <- as.numeric(strsplit(s,"")[[1]])
  v2 <- c(v1[(1+(length(v1)/2)):length(v1)] ,
          v1[1:(length(v1)/2)])
  
  sum(v1 * as.numeric(v1==v2))
  
}

s1 <- readLines("../inputs/input_1.txt")
c(advent1a(s1), advent1b(s1))
