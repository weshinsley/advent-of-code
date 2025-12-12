parse_file <- function(f = "../inputs/input_2.txt") {
  d <- lapply(strsplit(strsplit(readLines(f), ",")[[1]], "-"), as.numeric)
  for (i in seq_along(d)) { # Normalise digit lengths
    if (nchari(d[[i]][1]) != nchari(d[[i]][2])) {
      j <- length(d) + 1L
      d[[j]] <- c(0,0)
      end1 <- as.integer(gsub("[0-8]", "9", as.character(d[[i]][1])))
      d[[j]][1] <- end1 + 1L
      d[[j]][2] <- d[[i]][2] 
      d[[i]][2] <- end1
    }
  }
  d
}

nchari <- function(x) {
  len <- 0
  while (x > 0) {
    x <- x %/% 10
    len <- len + 1
  }
  len
}

tenp <- as.integer(10L ^ (1L:9L))

construct_invalid <- function(a, b, block_size, target_size = nchar(b),
                              reps = target_size %/% block_size) {
  first <- max(1L, a %/% tenp[target_size - block_size] - 1L)
  last <- max(1L, b %/% tenp[target_size - block_size] + 1L)
  nums <- unlist(lapply(first:last, function(x) {
    sum(x * c(1, tenp[seq(block_size, by = block_size, length.out = reps - 1)]))
  }))
  nums[(nums >= a) & (nums <= b)]
}

part1 <- function(d) {
  sum(unique(unlist(lapply(d, function(x) {
    if (nchari(x[1]) %% 2 == 0) {
      unique(construct_invalid(x[1], x[2], nchari(x[1]) %/% 2))
    } else 0
  }))))
}

part2 <- function(d) {
  p2 <- list(0, 1, 1, 1:2, 1, 1:3, 1, c(1, 2, 4), c(1, 3), c(1, 2, 5))
  sum(unique(unlist(lapply(d, function(x) {
    if (nchari(x[1]) > 1) {
      unlist(lapply(p2[[nchari(x[1])]], function(y) {
        unique(construct_invalid(x[1], x[2], y))
      }))
    } else 0
  }))))
}

d <- parse_file()
c(part1(d), part2(d))

