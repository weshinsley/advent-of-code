parse_input <- function(d) {
  read.csv(text = gsub(" -> ", ",", readLines(d)),
           header = FALSE, col.names = c("x1", "y1", "x2", "y2"))
}

solve <- function(d, part2 = FALSE) {
  env1 <- new.env()
  env2 <- new.env()
  
  for (i in seq_len(nrow(d))) {
    row <- d[i,]
    if ((row$x1 == row$x2) || (row$y1 == row$y2)) {
      for (y in row$y1:row$y2) {
        for (x in row$x1:row$x2) {
          v <- paste0(x, "_", y)
          if (exists(v, envir = env1)) {
            assign(v, 1, envir = env2)
          } else {
            assign(v, 1, envir = env1)
          }
        }
      }
    } else if (part2) {
      dy <- ifelse(row$y2 > row$y1, 1, -1)
      y <- row$y1
      for (x in row$x1:row$x2) {
        v <- paste0(x, "_", y)
        if (exists(v, envir = env1)) {
          assign(v, 1, envir = env2)
        } else {
          assign(v, 1, envir = env1)
        }
        y <- y + dy
      }
    }
  }
  length(ls(envir = env2))
}

part1 <- function(d) { solve(d) }
part2 <- function(d) { solve(d, TRUE) }

d <- parse_input("../inputs/input_5.txt")
c(part1(d), part2(d))
