library(data.table)

load <- function(f) {
  d <- rbindlist(lapply(strsplit(readLines(f), " bags contain "), function(x) {
    rbindlist(lapply(strsplit(x[2], ", ")[[1]], function(y) {
      z <- strsplit(y, " ")[[1]]
      if (!grepl("no", z[1])) {
        data.frame(stringsAsFactors = FALSE, 
                   holder = x[1], 
                   count = as.integer(z[1]),
                   name = paste(z[2], z[3]))
      } else {
        NULL
      }
    }))
  }))
}

recurse_contains <- function(df, bag_name, target) {
  bag <- df[df$holder == bag_name, ]
  if (target %in% bag$name) {
    return(TRUE)
  } else {
    for (next_bag in unique(bag$name)) {
      res <- recurse_contains(df, next_bag, target)
      if (res) {
        return(TRUE)
      }
    }
  }
  return(FALSE)
}

solve1 <- function(df) {
  sum(unlist(lapply(unique(df$holder), function(x) 
    recurse_contains(df, x, "shiny gold"))))
}

solve2 <- function(df, target) {
  tot <- 0
  my_bags <- df[df$holder == target, ]
  for (i in seq_len(nrow(my_bags))) {
    tot <- tot + my_bags$count[i] + 
                (my_bags$count[i] * solve2(df, my_bags$name[i]))
  }
  tot
}
wes <- load("../inputs/input_7.txt")
c(solve1(wes), solve2(wes, "shiny gold"))
