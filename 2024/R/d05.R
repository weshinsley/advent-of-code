parse_file <- function(f = "../inputs/input_5.txt", d = readLines(f)) {
  list(order = read.csv(text = d[1:(which(d == "") - 1)], sep = "|",
                        header = FALSE, col.names = c("x", "y")),
       updates = lapply(d[(which(d == "") + 1):length(d)], function(x) {
                       as.integer(strsplit(x, ",")[[1]])}))
}

fix_up <- function(up, rules, change = TRUE) {
  while (change) {
    change <- FALSE
    for (r in seq_len(nrow(rules))) {
      rule <- rules[r, ]
      index_x <- which(up == rule$x)
      index_y <- which(up == rule$y)
      if (index_x > index_y) {
        change <- TRUE
        ords <- seq_along(up)
        ords[ords == index_x] <- index_y - 0.5
        up <- up[order(ords)]
      }
    }
  }
  up
}

part1 <- function(d, p2 = FALSE, tot = 0) {
  for (up in d$updates) {
    ordered <- TRUE
    fixed <- FALSE
    rules <- d$order[d$order$x %in% up & d$order$y %in% up, ]
    for (r in seq_len(nrow(rules))) {
      rule <- rules[r, ]
      if (which(up == rule$x) > which(up == rule$y)) {
        if (p2) {
          up <- fix_up(up, rules)
          fixed <- TRUE
          break
          
        } else {
          ordered <- FALSE
          break
        }
      }
    }
    if ((ordered & !p2) || (fixed & p2)) {
      tot <- tot + up[1 + (length(up) %/% 2)]
    }
  }
  tot
}

part2 <- function(d) {
  part1(d, TRUE)
}

d <- parse_file()
c(part1(d), part2(d))
