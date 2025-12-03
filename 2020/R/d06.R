load <- function(f) {
  strsplit(paste(readLines(f), collapse = "\n"), "\n\n")[[1]]
}

solve <- function(xs) {
  c(sum(unlist(lapply(xs, function(x)
      length(unique(strsplit(gsub("\n", "", x), "")[[1]]))))),
    sum(unlist(lapply(xs, function(x)
      length(Reduce(intersect, strsplit(strsplit(x, "\n")[[1]], "")))))))
}

solve(load("../inputs/input_6.txt"))
