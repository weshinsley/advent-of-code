to_bin <- function(i) {
  b <- rev(as.integer(intToBits(i)))
  as.character(c(rep(0, 36-length(b)), b))
}

to_dec <- function(b) {
  b <- paste(b, collapse = "")
  little <- substring(b, 9)
  big <- substr(b, 1, 8)
  as.double(strtoi(little, 2)) +
    as.double(2^28 * strtoi(big, 2))
}

solve <- function(d, part2) {
  set <- new.env()
  for (i in seq_along(d)) {
    line <- strsplit(d[i], " ")[[1]]
    if (line[1] == 'mask') {
      mask <- strsplit(line[3], "")[[1]]
      countx <- sum(mask == 'X')
     } else {
      val <- as.integer(line[3])
      addr <- as.double(gsub("[^0-9]", "", line[1]))
      bits <- to_bin(ifelse(part2, addr, val))
      if (!part2) {
        bits[mask != 'X'] <- mask[mask != 'X']
        set[[as.character(addr)]] <- to_dec(bits)
      } else {
        bits[mask != '0'] <- mask[mask != '0']
        for (j in 0:((2^countx)-1)) {
          xval <- "0"
          if (j > 0) {
            xval <- rev(as.integer(intToBits(j)))
            xval <- xval[which(xval == "1")[1]:length(xval)]
          }
          xval <- c(rep("0", countx - length(xval)), xval)
          addr2 <- bits
          addr2[which(mask == 'X')] <- xval
          set[[as.character(to_dec(addr2))]] <- val
        }
      }
    }
  }
  sum(unlist(lapply(names(set), function(x) set[[x]])))
}
options(digits = 14)
wes <- readLines("../inputs/input_14.txt")
c(solve(wes, FALSE), solve(wes, TRUE))
