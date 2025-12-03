get_input <- function(f) {  as.integer(unlist(lapply(strsplit(f, ""), function(x) {
    strsplit(stringr::str_pad(R.utils::intToBin(strtoi(x, 16)), 4, "left", "0"), "")
  })))
}

stopifnot(identical(get_input("D2FE28"), 
          as.integer(c(1,1,0,1,0,0,1,0,1,1,1,1,1,1,1,0,0,0,1,0,1,0,0,0))))

ops <- c(`+`, `*`, min, max, NA, `>`, `<`, `==`)  

calc <- function(d, i = 1) {
  version <- (d[i] * 4) + (d[i + 1] * 2) + d[i + 2]
  version_sum <- version
  type <- (d[i+3] * 4) + (d[i + 4] * 2) + d[i + 5]
  i <- i + 6
  val <- 0
  if (type == 4) {
    val <- 0
    repeat {
      val <- (val * 16) + strtoi(paste(d[(i+1):(i+4)], collapse = ""), 
                                 base = 2)
      i <- i + 5
      if (d[i - 5] == 0) break
    }

  } else {
    lenid <- d[i]
    if (lenid == 0) {
      lenpacks <- strtoi(paste0(d[(i+1):(i+15)], collapse = ""), base  = 2)
      i <- i + 16
      end <- i + lenpacks
      j <- 1
      while (i != end) {
        res <- calc(d, i)
        version_sum <- version_sum + res[1]
        i <- res[2]
        val <- if (j == 1) res[3] else as.numeric(ops[[type + 1]](val, res[3]))
        j <- j + 1
      }

    } else {
      nopacks <- strtoi(paste0(d[(i+1):(i+11)], collapse = ""), base = 2)
      i <- i + 12
      for (j in seq_len(nopacks)) {
        res <- calc(d, i)
        version_sum <- version_sum + res[1]
        i <- res[2]
        val <- if (j == 1) res[3] else as.numeric(ops[[type + 1]](val, res[3]))
      }
    }
  }
  c(version_sum, i, val)
}

part1 <- function(res) { res[1] }
part2 <- function(res) { res[3] }

options(digits=14)
res <- calc(get_input(readLines("../inputs/input_16.txt")))
c(part1(res), part2(res))
