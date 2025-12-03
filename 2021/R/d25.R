read_input <- function(f) {
  d <- lapply(strsplit(readLines(f), ""),
            function(x) {
              as.integer(gsub("\\.", 0, gsub(">", 1, gsub("v", 2, x))))
            })
  wid <- length(d[[1]])
  d <- matrix(unlist(d), ncol = wid, byrow = TRUE)
  d
}

print <- function(d) {
  ch <- c(".", ">", "v")
  for (j in seq_len(nrow(d))) {
    message(paste0(ch[1 + d[j, ]]))
  }
}

part1 <- function(d) {
  wid <- ncol(d)
  hei <- nrow(d)
  
  count <- 0
  while (TRUE) {
    dold <- d
    move <- FALSE
    east <- dold[, wid] == 1 & dold[, 1] == 0
    if (any(east)) {
      move <- TRUE
      d[east, wid] <- 0
      d[east, 1] <- 1
    }
  
    for (i in (wid-1):1) {
      east <- (dold[, i] == 1) & (dold[, i + 1] == 0)
      if (any(east)) {
        move <- TRUE
        d[east, i] <- 0
        d[east, i + 1] <- 1
      }
    }
    
    dold <- d
    south <- dold[hei, ] == 2 & dold[1, ] == 0
    if (any(south)) {
      move <- TRUE
      d[hei, south] <- 0
      d[1, south] <- 2
    }
  
    for (j in 1:(hei-1)) {
      south <- (dold[j, ] == 2) & (dold[j + 1, ] == 0)
      if (any(south)) {
        move <- TRUE
        d[j, south] <- 0
        d[j + 1, south] <- 2
      }
    }
    
    # Include non-moving step...
    count <- count + 1
    if (!move) break
  }
  count
}

part2 <- function() {
  0
}

d <- read_input("../inputs/input_25.txt")
c(part1(d), part2())