read_input <- function(f) {
  d <- readLines(f)
  blank <- which(d == "")
  instr <- data.table::rbindlist(lapply(
    gsub("fold along ", "", d[(blank+1):length(d)]),
      function(x) {
        row = strsplit(x, "=")[[1]]
        data.frame(axis = row[1], n = as.integer(row[2]))
      }))
  
  dots <- read.table(text = d[1:(blank - 1)], sep=",", 
    nrows = blank - 1, header= FALSE, col.names = c("x", "y"))
  list(dots, instr)
}

solve <- function(d, instr) {
  p1 <- NA
  for (i in seq_len(nrow(instr))) {
    row <- instr[i, ]
    indexes <- d[[row$axis]] > row$n
    d[[row$axis]][indexes] <- (row$n + row$n - d[[row$axis]][indexes])
    d <- unique(d)
    if (i == 1) p1 <- nrow(d)
  }
  
  list(p1, matrix(c(d$y, d$x), ncol = 2))
}

part1 <- function(res) { as.integer(res[[1]]) }
part2 <- function(res) { res[[2]] }

d <- read_input("../inputs/input_13.txt")
res <- solve(d[[1]], d[[2]])
plot(res[[2]][, 1], res[[2]][, 2], xlim = c(0,80))
c(part1(res), part2(res))
