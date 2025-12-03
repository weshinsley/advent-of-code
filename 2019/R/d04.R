valid1 <- function(num) {
  chars <- strsplit(as.character(num), "")[[1]]
  dup <- FALSE
  dec <- FALSE
  for (j in seq_len(length(chars)-1)) {
    dup <- dup | (chars[j] == chars[j+1])
    dec <- dec | (chars[j + 1] < chars[j])
  }
  (dup && !dec)
}

valid2 <- function(num) {
  chars <- strsplit(as.character(num), "")[[1]]
  dup <- FALSE
  dec <- FALSE
  for (j in seq_len(length(chars)-1)) {
    ch_prev <- "!"
    ch_next <- "!"
    if (j > 1) ch_prev <- chars[j - 1]
    if (j + 2 <= length(chars)) ch_next <- chars[j + 2]
    dup <- dup | ((chars[j] == chars[j+1]) && 
                  (chars[j+1] != ch_next) && 
                  (chars[j] != ch_prev))
    dec <- dec | (chars[j + 1] < chars[j])
  }
  (dup && !dec)
}

range <- strsplit(readLines("../inputs/input_4.txt"), "-")[[1]]
c(sum(unlist(lapply(range[1]:range[2], valid1))),
  sum(unlist(lapply(range[1]:range[2], valid2))))
