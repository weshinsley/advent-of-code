vis <- function(d) {
  if (!("statnet" %in% installed.packages())) {
    install.packages("statnet", repos = "https://cloud.r-project.org/")
  }

  library(statnet)

  rx_parent <- which(unlist(lapply(d, function(x) "rx" %in% x$dests)))
  key4 <- names(d[[names(rx_parent)]]$mem)

  nodes <- unique(c(names(d), unlist(lapply(d, `[[`, "dests"))))
  matr <- matrix(0, nrow = length(nodes), ncol = length(nodes))
  for (i in seq_along(d)) {
    for (j in seq_along(d[[i]]$dests)) {
      matr[which(nodes == names(d)[i]), which(nodes == d[[i]]$dests[j])] <- 1
    }
  }
  colnames(matr) <- nodes
  rownames(matr) <- nodes
  net <- network(matr, directed = TRUE)
  size <- rep(1, length(nodes))
  size[which(nodes %in% key4)] <- 2
  size[which(nodes %in% c("rx", "broadcaster"))] <- 3
  shape <- rep(99, length(d))
  shape[nodes == "rx"] <- 3
  shape[nodes == "broadcaster"] <- 4
  cols <- rep("green", length(d))
  cols[nodes == "rx"] <- "red"
  cols[nodes == "broadcaster"] <- "blue"

  layout <- list(niter = 10000,
                 max.delta   = length(d),
                 area        = 1.7 * length(d) ^ 2,
                 cool.exp    = 3,
                 repulse.rad = 0.375 * length(d) ^ 3
  )

  png(file = "wes-input.png", width = 600, height = 600)

  plot.network(net,
               vertex.col = cols,
               vertex.cex = size,
               vertex.sides = shape,
               edge.lwd = 0.005, edge.col = "black",
               arrowhead.cex = 1,
               mode = "fruchtermanreingold", layout.par = layout)
  dev.off()
}


parse_input <- function(f) {
  res <- list()
  lines <- readLines(f)
  i <- 1
  for (x in lines) {
    x <- strsplit(x, " -> ")[[1]]
    dests <- strsplit(x[2], ", ")[[1]]
    name <- x[1]
    flip <- substring(name, 1, 1) == "%"
    conj <- substring(name, 1, 1) == "&"
    if (substring(name, 1, 1) %in% c("%", "&")) {
      name <- substring(name, 2, nchar(name))
    }
    res[[name]] <- list(name = name, dests = dests,
                        flip = flip, conj = conj, state = 0,
                        incoming = -1, mem = list())
  }
  for (i in seq_along(res)) {
    dests <- res[[i]]$dests
    for (dest in dests) {
      if (dest %in% names(res)) {
        if (res[[dest]]$conj) {
          res[[dest]]$mem[[res[[i]]$name]] <- 0
        }
      }
    }
  }
  res
}

button <- function(d, no = 1, p2 = FALSE) {
  if (p2) {
    rx_parent <- which(unlist(lapply(d, function(x) "rx" %in% x$dests)))
    periods <- d[[names(rx_parent)]]$mem
  }
  total <- 0
  hi <- 0
  lo <- 0
  cycle <- 0
  b <- d[["broadcaster"]]
  while (cycle < no) {
    cycle <- cycle + 1
    lo <- lo + 1
    n <- 0
    queue <- list()
    for (dest in b$dests) {
      n <- n + 1
      queue[[n]] <- list(dest, 0, "broadcaster")
      lo <- lo + 1
    }
    i <- 1
    while (i <= n) {
      pulse <- queue[[i]]
      i <- i + 1
      recv_name <- pulse[[1]][1]
      incoming_pulse <- pulse[[2]][1]
      pulse_src <- pulse[[3]][1]
      if (p2) {
        if (incoming_pulse == 0) {
          if (recv_name %in% names(periods)) {
            if (periods[[recv_name]] == 0) {
              periods[[recv_name]] <- cycle
              res <- prod(as.numeric(periods))
              if (res > 0) {
                return(format(res, digits = 14))
              }
            }
          }
        }
      }

      if (!recv_name %in% names(d)) {
        next
      }

      recv <- d[[recv_name]]
      if (recv$flip && (incoming_pulse == 0)) {
        d[[recv_name]]$state <- 1 - d[[recv_name]]$state
        for (dest in recv$dests) {
          n <- n + 1
          queue[[n]] <- list(dest, d[[recv_name]]$state, recv_name)
          lo <- lo + (d[[recv_name]]$state == 0)
          hi <- hi + (d[[recv_name]]$state == 1)
        }
      } else if (recv$conj) {
        d[[recv_name]]$mem[[pulse_src]] <- incoming_pulse
        vals <- sum(as.integer(unlist(d[[recv_name]]$mem)))
        if (vals == length(d[[recv_name]]$mem)) {
          for (dest in recv$dests) {
            n <- n + 1
            queue[[n]] <- list(dest, 0, recv_name)
            lo <- lo + 1
          }
        } else {
          for (dest in recv$dests) {
            n <- n + 1
            queue[[n]] <- list(dest, 1, recv_name)
            hi <- hi + 1
          }
        }
      }
    }
  }
  list(d = d, lo = lo, hi = hi, total = lo * hi)
}

part1 <- function(d) {
  d <- button(d, 1000, FALSE)
  format(d$total, digits = 14)

}

part2 <- function(d) {
  button(d, 99999, TRUE)
}

d <- parse_input("../inputs/input_20.txt")
c(part1(d), part2(d))

args <- commandArgs(trailingOnly = TRUE)
if (toupper(args[1]) %in% "-VIS") vis(d)
