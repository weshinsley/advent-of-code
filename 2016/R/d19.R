d <- as.integer(readLines("../AtariBasic/d19/INPUT.TXT"))
d3 <- 3 ^ floor(log(d, base = 3))
c(2 * (d - 2^floor(log2(d))) + 1, 
  ifelse(d3 == d, d, d - d3 + max(0, (d - (2 * d3)))))
