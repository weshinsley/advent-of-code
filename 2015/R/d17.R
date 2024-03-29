d <- sort(as.integer(readLines("../Java/d17/input.txt")))
binary <- lapply(strsplit(R.utils::intToBin(0:((2 ^ length(d))-1)), ""), as.integer)
sols <- which(unlist(lapply(binary, function(x) sum(x * d))) == 150)
c(length(sols), as.integer(table(unlist(lapply(binary[sols], sum))))[1])
