salt <- readLines("../inputs/input_14.txt")

solve <- function(part2 = FALSE) {
  
  hash <- function(x, part2) {
    md5 <- digest::digest(x, algo = "md5", serialize = FALSE)
    if (part2) {
      for (i in 1:2016) {
        md5 <- digest::digest(md5, algo = "md5", serialize = FALSE)
      }
    }
    md5
  }
  
  cache <- new.env(hash = TRUE)
  i <- 0
  key <- 0
  while (TRUE) {
    code <- paste0(salt, i)
    md5 <- ifelse(exists(code, envir = cache), get0(code, envir = cache), 
             hash(code, part2))
    digs <- c(strsplit(md5, "")[[1]], "z", "z")
    trip <- digs[1:(length(digs)-2)] == digs[2:(length(digs)-1)] &
            digs[2:(length(digs)-1)] == digs[3:(length(digs))]
    if (any(trip)) {
      dig <- digs[which(trip)[1]]
      pent <- paste0(dig, dig, dig, dig, dig)
      j <- i + 1
      
      while (j <= i + 1000) {
        code <- paste0(salt, j)
        if (!exists(code, envir = cache)) {
          assign(code, hash(code, part2), envir = cache)
        }
        md5 <- get0(code, envir = cache)
        if (grepl(pent, md5)) {
          key <- key + 1
          if (key == 64) {
            return(i)  
          }
          break
        }
        j <- j + 1
      }
    }
    i <- i + 1
  }
}

c(solve(), solve(TRUE))
