pat2grid <- function(pat) {
  x <- unlist(strsplit(pat,"/"))
  lapply(x, function(x) unlist(strsplit(x,"")))
}

grid2pat <- function(g) {
  for (i in seq_len(length(g))) {
    g[[i]] <- paste(g[[i]], collapse="")
  }
  paste(unlist(g), collapse="/")
}

grid2patxy <- function(g, top, left, size) {
  s <- ""
  for (j in top:(top+size-1)) {
    for (i in left:(left+size-1)) {
      s <- paste0(s, g[[j]][i])
    }
    if (j < (top+size-1)) s <- paste0(s, "/")
  }
  s
}

patxy2grid <- function(g, top, left, pat) {
  pg <- pat2grid(pat)
  size <- length(pg)
  for (j in seq_len(size)) {
    for (i in seq_len(size)) {
      g[[top+(j-1)]][left+(i-1)] <- pg[[j]][i]
    }
  }
  g
}

new_grid <- function(size) {
  pat2grid(paste(rep(paste(rep(".",size),collapse=""),size),collapse="/"))
}

f <- function(p) {
  paste(rev(unlist(strsplit(p, "/"))), collapse="/")
}

r <- function(p) {
  x <- pat2grid(p)
  y <- x
  s <- length(x)
  for (i in seq_len(s)) {
    for (j in seq_len(s)) {
      y[[(s+1)-i]][j] <- x[[j]][i]
    }
  }
  grid2pat(y)
}

parse <- function(data) {
  d <- data.frame(stringsAsFactors=FALSE)
  for (i in seq_len(length(data))) {
    bits <- unlist(strsplit(data[i], " => "))
    d <- rbind(d, data.frame(
      from = c(bits[1], r(bits[1]), r(r(bits[1])), r(r(r(bits[1]))),
               f(bits[1]), r(f(bits[1])), r(r(f(bits[1]))), r(r(r(f(bits[1]))))),
        to = rep(bits[2],8), stringsAsFactors=FALSE))
  }
  d[!duplicated(d$from),]
}

advent21a <- function(book, iters) {
  pat <- ".#./..#/###"
  grid <- pat2grid(pat)

  while (iters > 0) {
    size <- length(grid)

    if (size %% 2 == 0) {
      step <- 2
    } else {
      step <- 3
    }

    g2 <- new_grid(size * (step+1) / step)
    for (x in seq(1, size, by = step)) {
      for (y in seq(1, size, by = step)) {
        pat <- grid2patxy(grid, x, y, step)
        new_pat <- book$to[book$from == pat]
        g2 <- patxy2grid(g2, 1 + (((x-1)*(step+1))/step),
                             1 + (((y-1)*(step+1))/step), new_pat)

      }
    }
    grid <- g2
    iters <- iters - 1
  }

  pat <- grid2pat(grid)
  sum(unlist(strsplit(pat, "")) == '#')

}

input <- readLines("../inputs/input_21.txt")
data <- parse(input)
c(advent21a(data, 5), advent21a(data, 18))
