d <- rjson::fromJSON(file = "../inputs/input_12.txt")

number <- function(x) {
  suppressWarnings(ifelse(!is.na(as.numeric(x)), as.numeric(x), 0))
}

count <- function(x, part2 = FALSE) {
  if (part2 & (length(names(x)) > 0)) {
    for (x2 in names(x)) {
      if (length(x[[x2]]) == 1) {
        if (x[[x2]] == "red") {
          return(0)
        }
      }
    }
  }
  ifelse(((class(x) == "list") || (length(x) > 1)),
         sum(unlist(lapply(x, count, part2))),
         number(x))
}
c(count(d), count(d, TRUE))
