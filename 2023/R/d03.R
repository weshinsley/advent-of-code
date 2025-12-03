digits <- as.character(0:9)
parse_file <- function(f) {

  parse_line <- function(s, y) {
    dfl <- data.frame()
    events <- which(s != ".")
    index <- 1

    while (index <= length(events)) {
      start <- events[index]
      if (!s[start] %in% digits) {
        dfl <- rbind(dfl, data.frame(x1 = start, x2 = start, y = y,
                                     val = 0, sym = s[start]))
        index <- index + 1
        next
      }
      x2 <- start
      if ((x2 < length(s)) && (s[x2 + 1] %in% digits)) {
        x2 <- x2 + 1
        index <- index + 1
      }
      if ((x2 < length(s)) && (s[x2 + 1] %in% digits)) {
        x2 <- x2 + 1
        index <- index + 1
      }

      dfl <- rbind(dfl, data.frame(
        x1 = start, x2 = x2, y = y,
        val = as.integer(paste0(s[start:x2], collapse = "")),
        sym = NA))
      index <- index + 1
    }
    dfl
  }

  d <- readLines(f)
  df <- data.frame()
  for (i in seq_along(d)) {
    df <- rbind(df, parse_line(strsplit(d[i], "")[[1]], i))
  }
  df
}

part1 <- function(d) {
  nums <- d[is.na(d$sym), ]
  syms <- d[!is.na(d$sym), ]
  tot <- 0
  for (i in seq_len(nrow(nums))) {
    num <- nums[i, ]
    num_xrange <- (num$x1 - 1):(num$x2 + 1)
    horiz <- ((syms$y == num$y) &
              ((syms$x1 %in% c(num$x1 - 1, num$x2 + 1))))
    if (any(horiz)) {
      tot <- tot + num$val
      next
    }
    vert <- ((syms$y %in% c(num$y - 1, num$y + 1)) & (syms$x1 %in% num_xrange))
    if (any(vert)) {
      tot <- tot + num$val
    }
  }
  tot
}

part2 <- function(d) {
  stars <- d[d$sym %in% "*", ]
  nums <- d[is.na(d$sym), ]
  tot <- 0
  for (i in seq_len(nrow(stars))) {
    star <- stars[i, ]
    star_xrange <- (star$x1 - 1):(star$x1 + 1)
    horiz <- ((nums$y == star$y) &
              ((nums$x2 == (star$x1 - 1)) | (nums$x1 == (star$x2 + 1))))
    vert <- ((nums$y %in% c(star$y - 1, star$y + 1)) &
               ((nums$x1 %in% star_xrange) | (nums$x2 %in% star_xrange)))
    touching <- nums[horiz | vert, ]
    if (nrow(touching) == 2) {
      tot <- tot + prod(touching$val)
    }
  }
  tot
}

d <- parse_file("../inputs/input_3.txt")
c(part1(d), part2(d))
