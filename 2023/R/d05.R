parse_input <- function(f) {
  d <- readLines(f)
  seeds <- as.numeric(strsplit(d[1], " ")[[1]][-1])
  maps <- list()
  for (map in c("seed-to-soil map:", "soil-to-fertilizer map:",
                "fertilizer-to-water map:", "water-to-light map:",
                "light-to-temperature map:", "temperature-to-humidity map:",
                "humidity-to-location map:")) {
    index <- which(d == map) + 1
    newmap <- list()
    while ((index < length(d)) && (d[index] != "")) {
      newmap[[length(newmap) + 1]] <- as.numeric(strsplit(d[index], " ")[[1]])
      index <- index + 1
    }
    maps[[length(maps) + 1]] <- newmap
  }
  list(seeds = seeds, maps = maps)
}

seed_to_loc <- function(s, d) {
  for (map in d$maps) {
    for (entry in map) {
      dest <- entry[1]
      src <- entry[2]
      size <- entry[3]
      if ((s >= src) && (s < src + size)) {
        s <- s + (dest - src)
        break
      }
    }
  }
  s
}

seed_to_loc_range <- function(ranges, d) {

  intersect <- function(x1, x2, y1, y2) {
    x1 <= y2 && y1 <= x2
  }

  split_ranges <- function(x1, x2, y1, y2) {
    leftovers <- list()
    if (x1 < y1) {
      leftovers <- c(leftovers, list(c(x1, y1 - 1)))
      x1 <- y1
    }
    if (x2 > y2) {
      leftovers <- c(leftovers, list(c(y2 + 1, x2)))
      x2 <- y2
    }
    list(leftovers = leftovers, ready_to_transform = list(c(x1, x2)))
  }

  for (map in d$maps) {
    new_ranges <- list()
    for (entry in map) {
      y1 <- entry[2]
      y2 <- entry[2] + (entry[3] - 1)
      shift <- entry[1] - entry[2]

      i <- 1
      while (i <= length(ranges)) {
        if (is.null(ranges[[i]])) {
          next
        }
        x1 <- ranges[[i]][1]
        x2 <- ranges[[i]][2]
        if (intersect(x1, x2, y1, y2)) {
          res <- split_ranges(x1, x2, y1, y2)
          ranges <- c(ranges, res$leftovers)
          ranges[[i]] <- NULL
          for (new_range in res$ready_to_transform) {
            new_ranges <- c(new_ranges, list(c(new_range[1] + shift,
                                               new_range[2] + shift)))
          }
        } else {
          i <- i + 1
        }
      }
    }
    for (r in seq_along(ranges)) {
      if (!is.null(ranges[[r]])) {
        new_ranges <- c(new_ranges, list(ranges[[r]]))
      }
    }
    ranges <- new_ranges
  }
  new_ranges
}

part1 <- function(d) {
  min(unlist(lapply(d$seeds, seed_to_loc, d)))
}

part2 <- function(d) {
  res <- list()
  for (i in seq(1, length(d$seeds), by = 2)) {
    res <- c(res, seed_to_loc_range(
      list(c(d$seeds[i], d$seeds[i] + (d$seeds[i + 1] - 1))), d))
  }
  min(unlist(res))
}

d <- parse_input("../inputs/input_5.txt")
c(part1(d), part2(d))
