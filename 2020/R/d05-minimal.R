w <- strtoi(chartr("FLBR", "0011", readLines("../inputs/input_5.txt")), base = 2)
c(max(w), setdiff(min(w):max(w), w))
