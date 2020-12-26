w <- strtoi(chartr("FLBR", "0011", readLines("wes-input.txt")), base = 2)
cat("1:", max(w), "2:", setdiff(min(w):max(w), w))
