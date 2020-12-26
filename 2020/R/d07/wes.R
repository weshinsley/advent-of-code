library(crayon)
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

test <- load("test_4_32.txt")
stopifnot(solve1(test) == 4)
stopifnot(solve2(test, "shiny gold") == 32)

test <- load("test_x_126.txt")
stopifnot(solve2(test, "shiny gold") == 126)

wes <- load("wes-input.txt")
cat(red("\nAdvent of Code 2020 - Day 07\n"))
cat(blue("----------------------------\n\n"))
cat("Part 1:", green(solve1(wes)), "\n")
cat("Part 2:", green(solve2(wes, "shiny gold")), "\n")
