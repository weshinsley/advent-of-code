parse_input <- function(f) {
  d <- unlist(lapply(readLines(f),
                     function(x) gsub(" ", "", gsub(" @ ", ",", x))))
  d <- read.csv(text = d, sep = ",", header = FALSE,
             col.names = c("px", "py", "pz", "vx", "vy", "vz"))
  d$grad_xy <- d$vy / d$vx
  d
}

intersect_xy <- function(px1, py1, grad1, px2, py2, grad2) {
  c1 <- py1 - (px1 * grad1)
  c2 <- py2 - (px2 * grad2)
  if ((grad1 == grad2) && (c1 != c2)) return(NA)
  x0 <- (c2 - c1) / (grad1 - grad2)
  y0 <- (grad1 * x0) + c1
  c(x0, y0)
}

in_past <- function(x0, x1, vx) {
  (((x0 < x1) && (vx > 0)) ||
  ((x0 > x1) && (vx < 0)))
}

part1 <- function(d, xy1 = 200000000000000,
                     xy2 = 400000000000000) {
  tot <- 0
  for (i in seq_len(nrow(d) - 1)) {
    p1 <- d[i, ]
    for (j in (i + 1):nrow(d)) {
      p2 <- d[j, ]
      ixy <- intersect_xy(p1$px, p1$py, p1$grad_xy,
                          p2$px, p2$py, p2$grad_xy)

      if (any(is.na(ixy))) {
        next
      }

      if ((ixy[1] >= xy1) && (ixy[1] <= xy2) &&
          (ixy[2] >= xy1) && (ixy[2] <= xy2)) {
        if (in_past(ixy[1], p1$px, p1$vx) || in_past(ixy[2], p1$py, p1$vy)) {
          next
        }
        if (in_past(ixy[1], p2$px, p2$vx) || in_past(ixy[2], p2$py, p2$vy)) {
          next
        }

        tot <- tot + 1
      }

    }
  }
  tot
}


part2 <- function(d, file) {
  file <- file.path(getwd(), file)
  system2("python", c("wes_p2.py", file), stdout = TRUE, stderr = TRUE)
}

d <- parse_input("../inputs/input_24.txt")
c(part1(d), part2(d, "../inputs/input_24.txt"))
