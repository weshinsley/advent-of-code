code <- readLines("../inputs/input_4.txt")[1]
n <- paste0(code, 0:3999999)
dig <- function(n) digest::digest(n, serialize = FALSE, algo = "md5")
md5 <- unlist(lapply(n, dig))
c(which(grepl("^00000", md5))[1] - 1, which(grepl("^000000", md5))[1] - 1) 
