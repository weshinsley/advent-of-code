d <- unlist(strsplit(readLines("../inputs/input_6.txt"), ""))
f <- function(part1) {
  paste(unlist(lapply(1:8, function(x) 
    names(sort(table(d[seq(x, length(d), by = 8)]), decreasing = part1)[1]))),
    collapse = "")
}
c(f(TRUE), f(FALSE))
