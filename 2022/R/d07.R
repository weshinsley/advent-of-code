parse <- function(lines) {
  current_path <- "/"
  fs <- data.frame(path = "/", size = 0)
  current_index <- 1
  x <- 2

  while (x <= length(lines)) {
    line <- lines[x]
    if (grepl("\\$ ls", line)) {
      x <- x + 1
      line <- lines[x]

      while ((!is.na(line)) && (!grepl("\\$", line))) {
        if (grepl("dir ", line)) {
          fs <- rbind(fs, data.frame(
            path = paste0(current_path, substring(line, 5), "/"), size = 0))

        } else {
          fs$size[current_index] <- fs$size[current_index] +
            as.integer(gsub("[a-z. ]", "", line))
        }
        x <- x + 1
        line <- lines[x]
      }

    } else if (grepl("\\$ cd", line)) {
      newdir <- substring(line, 6)
      if (newdir == "..") {
        current_path <- strsplit(current_path, "/")[[1]]
        current_path <- current_path[-length(current_path)]
        current_path <- paste0(paste(current_path, collapse = "/"), "/")
        current_index <- which(fs$path == current_path)
      } else {
        current_path <- paste0(current_path, newdir, "/")
        current_index <- which(fs$path == current_path)
      }
      x <- x + 1
    }
  }

  fs$recurse_size <- 0
  for (i in seq_len(nrow(fs))) {
    fs$recurse_size[i] <- sum(fs$size[grepl(paste0("^", fs$path[i]), fs$path)])
  }
  fs
}

part1 <- function(fs) {
  sum(fs$recurse_size[fs$recurse_size <= 100000])
}

part2 <- function(fs) {
  free_me <- 30000000L - (70000000L - fs$recurse_size[1])
  min(fs$recurse_size[fs$recurse_size > free_me])
}

fs <- parse(readLines("../inputs/input_7.txt"))
c(part1(fs), part2(fs))
