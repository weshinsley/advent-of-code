library(crayon)

load <- function(f) {
  strsplit(paste(readLines(f), collapse = "\n"), "\n\n")[[1]]
}

solve <- function(xs) {
  c(sum(unlist(lapply(xs, function(x)
      length(unique(strsplit(gsub("\n", "", x), "")[[1]]))))),
    sum(unlist(lapply(xs, function(x)
      length(Reduce(intersect, strsplit(strsplit(x, "\n")[[1]], "")))))))
}

stopifnot(all.equal(solve(load("../Java/d06/test_11_6.txt")), c(11, 6)))

res <- solve(load("../Java/d06/wes-input.txt"))

cat(red("\nAdvent of Code 2020 - Day 06\n"))
cat(blue("----------------------------\n\n"))
cat("Part 1:", green(res[1]), "\n")
cat("Part 2:", green(res[2]), "\n")
