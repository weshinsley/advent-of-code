source("wes_functions.R")

input2 <- readLines("../inputs/input_10.txt")
input1 <- as.numeric(unlist(strsplit(input2, ",")))

c(advent10a(256, input1), advent10b(256, input2))

