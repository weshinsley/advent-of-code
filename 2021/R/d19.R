read_input <- function(f) {
  d <- readLines(f)
  starts <- which(grepl("--- scanner", d))
  blanks <- c(which(d == ""), length(d) + 1)
  beacons <- as.data.frame(data.table::rbindlist(lapply(seq_along(starts), function(i) {
    df <- read.csv(text = d[(starts[i]+1):(blanks[i]-1)], 
                   header = FALSE, col.names = c("x", "y", "z"))
    df$scanner = i
    df
  })))
  scanners <- rbind(data.frame(id = 1, x = 0, y = 0, z = 0, op = 0),
                    data.frame(id = 2:length(starts), x = NA, y = NA, z = NA, op = NA))
  
  list(beacons = beacons, scanners = scanners)
}

negx <- function(v) {
  v$x <- -v$x
  v
}

negy <- function(v) {
  v$y <- -v$y
  v
}

negz <- function(v) {
  v$z <- -v$z
  v
}

rename <- function(v, abc) {
  wx <- which(names(v) == "x")
  wy <- which(names(v) == "y")
  wz <- which(names(v) == "z")
  names(v)[wx] <- abc[1]
  names(v)[wy] <- abc[2]
  names(v)[wz] <- abc[3]
  v
}

zyx <- function(v) { rename(v, c("z", "y", "x")) }
zxy <- function(v) { rename(v, c("z", "x", "y")) }
yxz <- function(v) { rename(v, c("y", "x", "z")) }
yzx <- function(v) { rename(v, c("y", "z", "x")) }
xzy <- function(v) { rename(v, c("x", "z", "y")) }

sqwonk <- function(beacons, op) {
  if (op == 1) return(beacons)
  if (op == 2) return(negy(negz(beacons)))
  if (op == 3) return(negx(negz(beacons)))
  if (op == 4) return(negx(negy(beacons)))
  if (op == 5) return(xzy(negy(beacons)))
  if (op == 6) return(xzy(negz(beacons)))
  if (op == 7) return(xzy(negx(beacons)))
  if (op == 8) return(xzy(negx(negy(negz(beacons)))))
  if (op == 9) return(yzx(beacons))
  if (op == 10) return(yzx(negz(negx(beacons))))
  if (op == 11) return(yzx(negy(negx(beacons))))
  if (op == 12) return(yzx(negy(negz(beacons))))
  if (op == 13) return(yxz(negz(beacons)))
  if (op == 14) return(yxz(negx(beacons)))
  if (op == 15) return(yxz(negy(beacons)))
  if (op == 16) return(yxz(negy(negx(negz(beacons)))))
  if (op == 17) return(zxy(beacons))
  if (op == 18) return(zxy(negx(negy(beacons))))
  if (op == 19) return(zxy(negz(negy(beacons))))
  if (op == 20) return(zxy(negz(negx(beacons))))
  if (op == 21) return(zyx(negx(beacons)))
  if (op == 22) return(zyx(negy(beacons)))
  if (op == 23) return(zyx(negz(beacons)))
  if (op == 24) return(zyx(negx(negy(negz(beacons)))))
  NULL
}


orientate <- function(d, good, bad) {
  good_beacons <- d$beacons[d$beacons$scanner == good, ]
  bad_beacons <- d$beacons[d$beacons$scanner == bad, ]
  for (op in 1:24) {
    better_beacons <- sqwonk(bad_beacons, op)
    diffs <- unlist(lapply(seq_len(nrow(good_beacons)), function(i) {
      lapply(seq_len(nrow(better_beacons)), function(j) {
        paste0(good_beacons$x[i] - better_beacons$x[j], "#",
               good_beacons$y[i] - better_beacons$y[j], "#",
               good_beacons$z[i] - better_beacons$z[j])
    })}))
    
    diff <- sort(table(diffs), decreasing = TRUE)
    if (max(diff) >= 12) {
      offsets = as.integer(strsplit(names(diff)[1], "#")[[1]])
      better_beacons$x <- better_beacons$x + offsets[1]
      better_beacons$y <- better_beacons$y + offsets[2]
      better_beacons$z <- better_beacons$z + offsets[3]
      return(list(offsets = offsets, beacons = better_beacons))
    }
  }
  NULL
}
    
scan_scanners <- function(d) {
  hist <- new.env()
  while (any(is.na(d$scanners$x))) {
    unknown <- which(is.na(d$scanners$x))
    known <- which(!is.na(d$scanners$x))
    exit <- FALSE
    for (u in unknown) {
      if (exit) break
      for (k in known) {
        code <- paste0(u, "-", k)
        if (!exists(code, envir = hist)) {
          info <- orientate(d, k, u)
          if (!is.null(info)) {
            d$scanners$x[u] <- info$offsets[1]
            d$scanners$y[u] <- info$offsets[2]
            d$scanners$z[u] <- info$offsets[3]
            d$beacons <- rbind(d$beacons[d$beacons$scanner != u, ], info$beacons)
            exit <- TRUE
            break
          } else {
            assign(paste0(u,"-",k), 1, envir = hist)
          }
        }
      }
    }
  }
  d$beacons$scanner <- NULL
  d$beacons <- unique(d$beacons)
  d
}

part1 <- function(res) {
  nrow(res$beacons)
}

part2 <- function(res) {
  manhatten <- function(A, B) {
    abs(A$x - B$x) + abs(A$y - B$y) + abs(A$z - B$z)
  }
  
  md <- 0
  for (i in seq_len(nrow(res$scanners))) {
    for (j in seq_len(nrow(res$scanners))) {
      if (i != j) {
        md <- max(md, manhatten(res$scanners[i, ],
                                res$scanners[j, ]))
                      
      }
    }
  }
  md
}

d <- scan_scanners(read_input("../inputs/input_19.txt"))
c(part1(d), part2(d))
