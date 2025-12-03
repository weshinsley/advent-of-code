conv <- function(x) {
  strtoi(gsub("[FL]", "0", gsub("[BR]", "1", x)), base = 2)
}

wes <- unlist(lapply(readLines("../inputs/input_5.txt"), conv))
range <- min(wes):max(wes)

c(max(wes), range[!range %in% wes])
