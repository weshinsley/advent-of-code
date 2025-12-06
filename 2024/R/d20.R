source("../../shared/R/matrix.R")
source("../../shared/R/paths.R")

parse_file <- function(f = "../inputs/input_20.txt") {
  strings_to_char_matrix(readLines(f))
}

get_visited <- function(d) {
  start <- rev(as.integer(which(d == "S", arr.ind = TRUE)))
  end <- rev(as.integer(which(d == "E", arr.ind = TRUE)))
  m <- matrix(Inf, nrow = nrow(d), ncol = ncol(d))
  m[d == "#"] <- (-1)
  vis <- shortest_path_bfs(m, start, end)$visited
}

solve <- function(vis, s = 2, test = FALSE, tot = 0) {
  manhat <- data.frame(x = 0, y = 0, dx = -s:s, dy = rep(-s:s, each = s + s + 1))
  manhat$dist <- abs(manhat$dx) + abs(manhat$dy)
  manhat <- manhat[manhat$dist > 0 & manhat$dist <= s, ]
  
  tab <- c()
  path <- which(vis != -1, arr.ind = TRUE)
  
  for (p in seq_len(nrow(path))) {
    j <- path[p, 1]
    i <- path[p, 2]
    manhat$x <- i + manhat$dx
    manhat$y <- j + manhat$dy
    manhat$vis <- NA
    pix <- which(manhat$x >= 1 & manhat$x <= ncol(vis) &
                 manhat$y >= 1 & manhat$y <= nrow(vis))
    manhat$vis[pix] <- vis[cbind(manhat$y[pix], manhat$x[pix])]
    pix <- pix[which(manhat$vis[pix] != -1)]
    saving <- (manhat$vis[pix] - vis[j, i]) - manhat$dist[pix]
    saving <- saving[saving > 0]
    if (test) {
      tab <- c(tab, saving)
    }
    tot <- tot + sum(saving >= 100)
  }
  list(res = tot, tab = table(tab))
}

part1 <- function(d, n = 2) { 
  solve(d, n, FALSE)$res
}

part2 <- function(d) {
  part1(d, 20)
}

d <- get_visited(parse_file())
c(part1(d), part2(d))
