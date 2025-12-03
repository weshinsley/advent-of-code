d <- read.csv(text = unlist(lapply(readLines("../inputs/input_6.txt"), 
  function(x) gsub(" through ", ",", gsub("turn off ", "off,", 
                gsub("turn on ", "on,", gsub("toggle ", "tog,", x)))))), 
                  header = FALSE, col.names = c("f","x1","y1","x2","y2"))
d[, c("x1", "x2", "y1", "y2")] <- d[, c("x1", "x2", "y1", "y2")] + 1

light <- function(d, tog, on, off) {
  m <- matrix(nrow = 1000, ncol = 1000, data = 0)
  for (i in seq_len(nrow(d))) {
    m[d$y1[i]:d$y2[i], d$x1[i]:d$x2[i]] <- 
      do.call(d$f[i], list(m[d$y1[i]:d$y2[i], d$x1[i]:d$x2[i]]))
  }
  sum(m)
}

c(light(d, function(x) (1 - x), function(x) 1, function(x) 0),
  light(d, function(x) (2 + x), function(x) (x + 1), function(x) pmax(0, x - 1)))
