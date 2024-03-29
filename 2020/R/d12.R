library(crayon)
library(data.table)

load <- function(f) {
  x <- readLines(f)
  x[grepl("L180", x)] <- "R180"
  x[grepl("L270", x)] <- "R90"
  x[grepl("L90", x)] <- "R270"
  data.frame(stringsAsFactors = FALSE,
             code = substring(x, 1, 1),
             num = as.integer(substring(x, 2)))
}

nesw <- data.frame(stringsAsFactors = FALSE,
  dx = c(1, 0, -1, 0), dy = c(0, 1, 0, -1), dir = c("E", "S", "W", "N"))

solve1 <- function(d) {
  ship <- c(0,0)
  ship_dir <- which(nesw$dir == 'E')
  for (i in seq_len(nrow(d))) {
    cmd <- d[i, ]
    if (grepl(cmd$code, "NEWS")) {
      j <- which(nesw$dir == cmd$code)
      ship <- ship + (cmd$num * c(nesw$dx[j], nesw$dy[j]))
    } else if (cmd$code == 'F') {
      ship <- ship + (cmd$num * c(nesw$dx[ship_dir], nesw$dy[ship_dir]))
    } else if (cmd$code == 'R') {
      ship_dir <- 1 + (((ship_dir - 1) + (cmd$num / 90)) %% 4)
    } 
  }
  sum(abs(ship))
}

solve2 <- function(d) {
  ship <- c(0,0)
  way <- c(10, -1)
  for (i in seq_len(nrow(d))) {
    cmd <- d[i, ]
    if (grepl(cmd$code, "NEWS")) {
      j <- which(nesw$dir == cmd$code)
      way <- way + (cmd$num * c(nesw$dx[j], nesw$dy[j]))
    } else if (cmd$code == 'F') {
      ship <- ship + (cmd$num * way)
    } else if (cmd$code == 'R') {
      for (j in seq(cmd$num / 90)) {
        way <- c(-way[2], way[1])
      }
    } 
  }
  sum(abs(ship))
}


test <- load("../Java/d12/test_25_286.txt")
stopifnot(solve1(test) == 25)
stopifnot(solve2(test) == 286)

wes <- load("../Java/d12/wes-input.txt")
cat(red("\nAdvent of Code 2020 - Day 12\n"))
cat(blue("----------------------------\n\n"))
cat("Part 1:", green(solve1(wes)), "\n")
cat("Part 2:", green(solve2(wes)), "\n")
