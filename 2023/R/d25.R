make_mat <- function(d) {
  matr <- matrix(0, nrow = length(d$nodes), ncol = length(d$nodes))
  for (i in seq_along(d$nodes)) {
    from <- d$nodes[i]
    if (from %in% names(d$links)) {
      neigh <- d$links[[from]]
      matr[i, match(neigh, d$nodes)] <- 1
    }
  }
  matr
}

vis <- function(d, matr, file = "wes-input.png", px = 2000, py = 2000) {
  if (!("statnet" %in% installed.packages())) {
    install.packages("statnet", repos = "https://cloud.r-project.org/")
  }

  library(statnet)

  colnames(matr) <- d$nodes
  rownames(matr) <- d$nodes
  net <- network(matr, directed = TRUE)
  png(file = file, width = px, height = py)
  layout <- list(niter = 10000,
                 max.delta   = length(d$nodes),
                 area        = 1.7 * length(d$nodes) ^ 2,
                 cool.exp    = 3,
                 repulse.rad = 0.375 * length(d$nodes) ^ 3)
  plot.network(net,
                 edge.lwd = 0.005, edge.col = "black",
                 arrowhead.cex = 1,
                 #displaylabels = TRUE, boxed.labels = FALSE,
                 label = network.vertex.names(net),
                 mode = "fruchtermanreingold", layout.par = layout)
  dev.off()
}

parse_input <- function(f) {
  nodes <- c()
  links <- list()
  for (line in readLines(f)) {
    lh <- strsplit(line, ": ")[[1]]
    rh <- strsplit(lh[2], " ")[[1]]
    nodes <- unique(c(nodes, lh[1], rh))
    links[[lh[1]]] <- rh
  }
  list(nodes = nodes, links = links)
}

part1 <- function(d) {
  matr <- make_mat(d)
  group_no <- rep(0, length(d$nodes))
  queue <- d$nodes[1]
  i <- 1
  n <- 1
  while (i <= n) {
    current <- queue[[i]]
    index <- which(d$nodes == current)
    i <- i + 1
    group_no[index] <- 1
    neighs <- unique(c(which(matr[index, ] > 0), which(matr[, index] > 0)))

    for (neigh in neighs) {
      if (group_no[neigh] == 0) {
        n <- n + 1
        queue[[n]] <- d$nodes[neigh]
      }
    }
  }
  sum(group_no == 0) * sum(group_no == 1)
}

d <- parse_input("../inputs/input_25.txt")

# I visualised it. vis(d, matr)

d$links$pmn <- d$links$pmn[d$links$pmn != "kdc"]
d$links$hvm <- d$links$hvm[d$links$hvm != "grd"]
d$links$jmn <- d$links$hvm[d$links$jmn != "zfk"]
part1(d)
