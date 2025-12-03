# Run the script with -vis to produce a npg

vis <- function(d) {
  if (!("statnet" %in% installed.packages())) {
    install.packages("statnet", repos = "https://cloud.r-project.org/")
  }

  library(statnet)
  d <- rbind(data.frame(from = d$eqs$from, to = d$eqs$left),
             data.frame(from = d$eqs$from, to = d$eqs$right))
  starts <- unique(d$from[substr(d$from, 3, 3) == "A"])
  d$start <- d$from %in% starts
  ends <- unique(d$from[substr(d$from, 3, 3) == "Z"])
  d$end <- d$from %in% ends
  d$group <- 0
  for (i in seq_along(starts)) {
    fill <- starts[i]
    x <- 1
    y <- 1
    while (x <= y) {
      node <- fill[x]
      d$group[d$from == node] <- i
      x <- x + 1
      links <- unique(d$to[d$from == node])
      for (link in links) {
        if (!link %in% fill) {
          y <- y + 1
          fill <- c(fill, link)
        }
      }
    }
  }
  nodes <- unique(d$from)
  matr <- matrix(0, nrow = length(nodes), ncol = length(nodes))
  for (i in seq_len(nrow(d))) {
    matr[which(nodes == d$from[i]), which(nodes == d$to[i])] <- 1
  }
  colnames(matr) <- nodes
  rownames(matr) <- nodes
  net <- network(matr, directed = TRUE)
  shape <- rep(4, nrow(d))
  shape[which(d$start)] <- 50
  shape[which(d$end)]  <- 3
  size <- rep(1, nrow(d))
  size[which(d$start)] <- 2
  size[which(d$end)] <- 2

  col <- c("red", "green", "blue", "yellow", "purple", "brown")[d$group]

  layout <- list(niter = 10000,
                 max.delta   = nrow(d),
                 area        = 1.7 * nrow(d) ^ 2,
                 cool.exp    = 3,
                 repulse.rad = 0.375 * nrow(d) ^ 3
  )

  png(file = "wes-input.png", width = 600, height = 600)

  plot.network(net,
               vertex.col = col,
               vertex.cex = size,
               vertex.sides = shape,
               edge.lwd = 0.005, edge.col = "black",
               arrowhead.cex = 0.75,
               mode = "fruchtermanreingold", layout.par = layout)
  dev.off()
}

parse_input <- function(f) {
  x <- readLines(f)
  dir <- strsplit(x[1], "")[[1]]
  x <- x[3:length(x)]
  eqs <- data.frame(from = unlist(lapply(x, substring, 1, 3)),
                    left = unlist(lapply(x, substring, 8, 10)),
                    right = unlist(lapply(x, substring, 13, 15)))
  eqs$lefti <- match(eqs$left, eqs$from)
  eqs$righti <- match(eqs$right, eqs$from)
  eqs$endz <- substr(eqs$from, 3, 3) == "Z"
  list(dir = dir, eqs = eqs)
}


part1 <- function(d) {
  i <- which(d$eqs$from == "AAA")
  pos <- 1
  steps <- 0
  at <- "AAA"
  while (at != "ZZZ") {
    if (d$dir[pos] == "L") {
      at <- d$eqs$left[i]
      i <- d$eqs$lefti[i]
    } else {
      at <- d$eqs$right[i]
      i <- d$eqs$righti[i]
    }
    pos <- pos + 1
    if (pos > length(d$dir)) {
      pos <- 1
    }
    steps <- steps + 1
  }
  steps
}

lcm <- function(x, y) {
  vals <- (2:x) * y
  vals[vals %% x == 0][1]
}

part2 <- function(d, silly_test = FALSE) {
  df <- data.frame()
  i <- which(substr(d$eqs$from, 3, 3) == "A")
  pos <- 1
  steps <- 0
  dir_len <- length(d$dir)
  at <- d$eqs$from[i]
  while (TRUE) {
    if (silly_test) {
      if (all(d$eqs$endz[i])) {
        break
      }
    }
    if (d$dir[pos] == "L") {
      at <- d$eq$left[i]
      i <- d$eq$lefti[i]
    } else {
      at <- d$eqs$right[i]
      i <- d$eqs$righti[i]
    }
    if (!silly_test) {
      if (any(d$eq$endz[i])) {
        for (j in which(d$eq$endz[i])) {

          df <- rbind(df, data.frame(j = j, at = at[j], steps = steps))
          tab <- table(df$j)
          if ((length(tab) == length(i)) && (min(as.integer(tab)) >= 2))  {
            x <- lcm(unique(diff(df$steps[df$j == 1])),
                     unique(diff(df$steps[df$j == 2])))
            for (rest in 3:length(i)) {
              x <- lcm(unique(diff(df$steps[df$j == rest])), x)
            }
            return(as.character(x))
          }
        }
      }
    }
    pos <- 1 + (pos %% dir_len)
    steps <- steps + 1
  }
  steps
}

d <- parse_input("../inputs/input_8.txt")
c(part1(d), part2(d))

args <- commandArgs(trailingOnly = TRUE)
if (toupper(args[1]) %in% "-VIS") vis(d)
