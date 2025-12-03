parse_line <- function(d, part2 = FALSE) {
  d <- strsplit(d, ": ")[[1]]
  id <- as.integer(gsub("Game ", "", d[1]))
  res <- list(red = 0, green = 0, blue = 0)
  reveals <- strsplit(d[2], "; ")[[1]]
  for (reveal in reveals) {
    cols <- strsplit(strsplit(reveal, ", ")[[1]], " ")
    for (col in seq_along(cols)) {
      which_col <- cols[[col]][2]
      res[[which_col]] <- max(res[[which_col]], as.integer(cols[[col]][1]))
    }
  }
  if (part2) (res$red * res$green * res$blue)
  else if ((res$red <= 12) && (res$green <= 13) && (res$blue <= 14)) id
  else 0
}


part1 <- function(d) {
  sum(unlist(lapply(d, parse_line)))
}

part2 <- function(d) {
  sum(unlist(lapply(d, parse_line, TRUE)))
}

input <- readLines("../inputs/input_2.txt")
c(part1(input), part2(input))
