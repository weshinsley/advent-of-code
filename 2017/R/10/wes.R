source("wes_functions.R")

test(advent10a(5, c(3,4,1,5)),12)

input2 <- readLines("input.txt")
input1 <- as.numeric(unlist(strsplit(input2, ",")))

advent10a(256, input1)

test(advent10b(256, ""), "a2582a3a0e66e6e86e3812dcb672a272")
test(advent10b(256, "AoC 2017"), "33efeb34ea91902bb2f59c9920caa6cd")
test(advent10b(256, "1,2,3"), "3efbe78a8d82f29979031a4aa0b16a9d")
test(advent10b(256, "1,2,4"), "63960835bcdc130f0b66d7ff4f6a5a8e")

advent10b(256, input2)

