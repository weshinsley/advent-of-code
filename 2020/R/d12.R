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


wes <- load("../inputs/input_12.txt")
c(solve1(wes), solve2(wes))
