library(crayon)

conv <- function(x) {
  strtoi(gsub("[FL]", "0", gsub("[BR]", "1", x)), base = 2)
}

stopifnot(conv("FBFBBFFRLR") == 357)
stopifnot(conv("BFFFBBFRRR") == 567)
stopifnot(conv("FFFBBBFRRR") == 119)
stopifnot(conv("BBFFBBFRLL") == 820)

wes <- unlist(lapply(readLines("../Java/d05/wes-input.txt"), conv))
range <- min(wes):max(wes)

cat(red("\nAdvent of Code 2020 - Day 05\n"))
cat(blue("----------------------------\n\n"))
cat("Part 1:", green(max(wes)), "\n")
cat("Part 2:", green(range[!range %in% wes]), "\n")
