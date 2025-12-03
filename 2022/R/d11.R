monkey <- function(items, op, op_arg, test_div, true_to, false_to) {
  list(items = items,
       op = op,
       op_arg = op_arg,
       test_div = test_div,
       true_to = true_to,
       false_to = false_to,
       insp = 0)
}

numcom <- function(s) {
  as.integer(gsub("[A-Za-z:= *+]", "", s))
}

parse <- function(f) {
  m <- list()
  d <- readLines(f)
  i <- 1
  while (i < length(d)) {
    id <-  numcom(d[i])
    its <- as.integer(strsplit(gsub("[A-Za-z: ]", "", d[i + 1]), ",")[[1]])
    op <- strsplit(d[i + 2], "= old ")[[1]][2]
    if (grepl("\\+", op)) op_f <- "add"
    else if (grepl("\\* old", op)) op_f <- "sqr"
    else op_f <- "mul"
    if (op_f %in% c("add", "mul")) op_arg <- numcom(op)
    else op_arg <- 0
    test_div <- numcom(d[i + 3])
    true_to <- numcom(d[i + 4])
    false_to <- numcom(d[i + 5])
    m[[id + 1]] <- monkey(its, op_f, op_arg, test_div, true_to, false_to)
    i <- i + 7
  }
  m
}

do_round <- function(d, part2 = FALSE, modulo = "William Of Orange") {
  for (i in seq_along(d)) {
    for (j in seq_along(d[[i]]$items)) {
      item <- d[[i]]$items[j]
      if (d[[i]]$op == "mul")      new_item <- item * d[[i]]$op_arg
      else if (d[[i]]$op == "add") new_item <- item + d[[i]]$op_arg
      else if (d[[i]]$op == "sqr") new_item <- item * item

      if (!part2) new_item <- new_item %/% 3
      else new_item <- new_item %% modulo
      dest <- d[[i]]$false_to
      if (new_item %% d[[i]]$test_div == 0) dest <- d[[i]]$true_to
      d[[dest + 1]]$items <- c(d[[dest + 1]]$items, new_item)
      d[[i]]$insp <- d[[i]]$insp + 1
    }
    d[[i]]$items <- c()
  }
  d
}

part1 <- function(d) {
  for (r in 1:20) {
    d <- do_round(d)
  }
  prod(sort(unlist(lapply(d, `[[`, "insp")), decreasing = TRUE)[1:2])
}

part2 <- function(d) {

  # Apparently you do this.
  # I had no idea and had to cheat/google here.

  # Actually... it's not quite as bad if I think properly!

  # We're not interested in what the worry-factor is,
  # only the number of inspections - hence, separate
  # the calculations of worry from the final "do I
  # throw it to the false-monkey or true-monkey"

  # So all we then need is for overflow to not
  # affect the result of the last div - hence wrap
  # at a number common to all the divs (ie, the product)

  modulo <- prod(unlist(lapply(d, `[[`, "test_div")))
  for (r in 1:10000) {
    d <- do_round(d, TRUE, modulo)
  }
  prod(sort(unlist(lapply(d, `[[`, "insp")), decreasing = TRUE)[1:2])
}

d <- parse("../inputs/input_11.txt")
c(part1(d), part2(d))
