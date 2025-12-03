d <- unlist(lapply(readLines("../inputs/input_19.txt"), function(x) {
  gsub("Rn", "<", gsub("Ar", ">", gsub("Y", ",", x)))}))

med <- d[length(d)]
rules <- read.csv(text = gsub(" => ", ";", d[1:(length(d)-2)]), header = FALSE,
                  sep = ";", col.names = c("from", "to"))

part1 <- function(med, rules) {
  length(unique(unlist(lapply(seq_len(nrow(rules)), function(x) {
    rule <- rules[x, ]
    
    locs <- as.data.frame(
      stringr::str_locate_all(med, paste0("(?=",rule$from,")"))[[1]])
    
    unlist(lapply(seq_len(nrow(locs)), function(y) {
      paste0(substring(med, 1, (locs$start[y] - 1)), rule$to, 
             substring(med, locs$start[y] + nchar(rule$from)), collapse = "")
    }))
  }))))
}

# Forms of rule:
# X => Y
# X => Y(Z1)
# X => Y(Z1,Z2)
# X => Y(Z1,Z2,Z3)
part2 <- function(med, rules) {
  
  trans <- function(m, rs) {
    res <- list(med = m, count = 0)
    i <- 1
    while (i <= nrow(rs)) {
      if (grepl(rs$to[i], m)) {
        x <- stringr::str_locate(m, rs$to[i])[[1]]
        res$med <- paste0(substring(m, 1, (x - 1)), rs$from[i], 
                          substring(m, x + nchar(rs$to[i])), collapse = "")
        i < length(rs)
        res$count <- 1
      }
      i <- i + 1
    }
    res
  } 
  
  rules <- split(rules, grepl("[,<]", rules$to))
  rules[[1]] <- rules[[1]][order(nchar(rules[[1]]$to), decreasing = TRUE), ]
  count <- 0
  while (med != "e") {
    x <- list()
    for (r in c(2, 1)) {
      x$count <- 1
      while (x$count > 0) {
        x <- trans(med, rules[[r]])
        med <- x$med
        count <- count + x$count
      }
    }
  }
  count
}

c(part1(med, rules), part2(med, rules))
