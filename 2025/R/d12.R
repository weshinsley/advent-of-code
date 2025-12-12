parse_file <- function(f = "../inputs/input_12.txt") {
  d <- readLines(f)
  spaces <- which(d == "")
  presents <- list()
  for (j in spaces) {
    presents [[j %/% 5]] <- 
      lapply(strsplit(gsub("#", 1, gsub("\\.", "0", d[(j- 3):(j-1)])), ""),
             as.integer)
  }
  sizes <- unlist(lapply(presents, function(x) sum(unlist(x))))
  d <- d[(1+spaces[length(spaces)]):length(d)]
  d <- gsub(":", "", gsub("x", " ", d))
  d <- read.csv(text = d, header = FALSE, sep = " ",
                col.names = c("w", "l", "p0", "p1", "p2", "p3", "p4", "p5"))
  list(presents = presents, sizes = sizes, regions = d)
}

fit <- function(reg, presents, sizes) {
  m <- matrix(0, ncol = reg$w, nrow = reg$l)
  total <- reg$w * reg$l
  pp <- c(reg$p0, reg$p1, reg$p2, reg$p3, reg$p4, reg$p5)
  needed <- sum(pp * sizes)
  if (needed > total) return(FALSE)
  TRUE
}

part1 <- function(d) {
  sum(unlist(lapply(seq_len(nrow(d$regions)), function(x) {
    fit(d$regions[x, ], d$presents, d$sizes)
  })))  
}

d <- parse_file()
part1(d)
