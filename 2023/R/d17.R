parse_input <- function(f) {
  d <- readLines(f)
  matrix(as.integer(strsplit(paste0(d, collapse = ""), "")[[1]]),
         nrow = length(d), ncol = nchar(d[[1]]), byrow = TRUE)
}

go <- function(d, min_steps, max_steps, wid = ncol(d), hei = nrow(d)) {
  visited <- array(FALSE, c(wid, hei, 4L, max_steps + 1L))
  pq_capacity <- 100000
  dx <- c(1L, 0L, -1L, 0L)
  dy <- c(0L, 1L, 0L, -1L)
  i <- 1L
  pq_x <- rep(-1L, pq_capacity)
  pq_y <- rep(-1L, pq_capacity)
  pq_d <- rep(-1L, pq_capacity)
  pq_h <- rep(-1L, pq_capacity)
  pq_s <- rep(-1L, pq_capacity)
  pq_n <- rep(-1L, pq_capacity)

  # Initialise with first states - top-left, no steps or heat.

  pq_x[1L] <- 1L
  pq_y[1L] <- 1L
  pq_d[1L] <- 1L
  pq_s[1L] <- 0L
  pq_h[1L] <- 0L
  pq_n[1L] <- -1L

  next_slot <- 2L

  while(i != -1L)  {

    if (visited[pq_x[i], pq_y[i], pq_d[i], 1L + pq_s[i]]) {
      i <- pq_n[i]
      next
    }

    visited[pq_x[i], pq_y[i], pq_d[i], 1L + pq_s[i]] <- TRUE

    # Got there?

    if (pq_x[i] == wid && pq_y[i] == hei && pq_s[i] >= min_steps) {
      return(pq_h[i])
    }

    # Explore going straight on.

    if (pq_s[i] < max_steps - 1L) {
      nx <- pq_x[i] + dx[pq_d[i]]
      ny <- pq_y[i] + dy[pq_d[i]]
      if (nx >= 1L && nx <= wid && ny >= 1L && ny <= hei) {
        nh <- pq_h[i] + d[ny, nx]
        if (!visited[nx, ny, pq_d[i], 2L + pq_s[i]]) {
          prev <- i
          while (TRUE) {
            if (pq_n[prev] == -1L) {
              pq_n[prev] <- next_slot
              pq_x[next_slot] <- nx
              pq_y[next_slot] <- ny
              pq_d[next_slot] <- pq_d[i]
              pq_s[next_slot] <- 1L + pq_s[i]
              pq_h[next_slot] <- nh
              pq_n[next_slot] <- -1L
              next_slot <- next_slot + 1L
              break
            }
            nxtp <- pq_n[prev]
            if (pq_h[nxtp] < nh) {
              prev <- nxtp
              next
            }
            pq_n[prev] <- next_slot
            pq_x[next_slot] <- nx
            pq_y[next_slot] <- ny
            pq_d[next_slot] <- pq_d[i]
            pq_s[next_slot] <- 1L + pq_s[i]
            pq_h[next_slot] <- nh
            pq_n[next_slot] <- nxtp
            next_slot <- next_slot + 1L
            break
          }
        }
      }
    }

    # Explore turning left/right

    nd <- pq_d[i]
    if (pq_s[i] >= min_steps) {
      for (x in c(1L, 2L)) {
        nd <- nd + x
        if (nd > 4L) nd <- nd - 4L
        nx <- pq_x[i] + dx[nd]
        ny <- pq_y[i] + dy[nd]

        if (nx >= 1L && nx <= wid && ny >= 1L && ny <= hei) {
          nh <- pq_h[i] + d[ny, nx]
          if (!visited[nx, ny, nd, 1L]) {
            prev <- i
            while (TRUE) {
              if (pq_n[prev] == -1L) {
                pq_n[prev] <- next_slot
                pq_x[next_slot] <- nx
                pq_y[next_slot] <- ny
                pq_s[next_slot] <- 0L
                pq_h[next_slot] <- nh
                pq_d[next_slot] <- nd
                pq_n[next_slot] <- -1L
                next_slot <- next_slot + 1L
                break
              }
              nxtp <- pq_n[prev]
              if (pq_h[nxtp] < nh) {
                prev <- nxtp
                next
              }
              pq_n[prev] <- next_slot
              pq_x[next_slot] <- nx
              pq_y[next_slot] <- ny
              pq_d[next_slot] <- nd
              pq_s[next_slot] <- 0L
              pq_h[next_slot] <- nh
              pq_n[next_slot] <- nxtp
              next_slot <- next_slot + 1L
              break
            }
          }
        }
      }
    }
    i <- pq_n[i]
  }
  9999
}

part1 <- function(d) {
  go(d, 0L, 3L)
}

part2 <- function(d) {
  go(d, 3L, 10L)
}

test <- function() {
  d <- parse_input("../inputs/d17-test.txt")
  stopifnot(part1(d) == 102)
  stopifnot(part2(d) == 94)
  d <- parse_input("../inputs/d17-test2.txt")
  stopifnot(part2(d) == 71)
}

test()
d <- parse_input("../inputs/d17-input.txt")
part1(d)
part2(d)
