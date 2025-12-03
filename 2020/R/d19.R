d <- gsub("\\|", "#", readLines("../inputs/input_19.txt"))
strings <- d[((which(d == "") + 1):length(d))]
rules <- as.data.frame(data.table::rbindlist(
  lapply(strsplit(d[1:(which(d == "") - 1)], ": "), function(x) {
    n <- as.integer(x[1])
    r <- x[2]
    if (!grepl("#", r)) {
      return(data.frame(n = n, r1 = x[2], r2 = NA))
    } else {
      r <- strsplit(r, " # ")[[1]]
      return(data.frame(n = n, r1 = r[1], r2 = r[2]))
    }
  })))

rules <- rules[order(rules$n), ]

trans_built <- function(built, rule, no) {
  r <- ifelse(no == 1, rule$r1, rule$r2)
  if (is.na(r)) return(NA)
  if (grepl("\"", r)) {
    built <- paste0(built, substring(r, 2, 2))
  }
  built
}

trans_rq <- function(rq, rule, no) {
  r <- ifelse(no == 1, rule$r1, rule$r2)
  if (is.na(r)) return(NA)
  if (!grepl("\"",r)) {
    bits <- as.integer(strsplit(r, " ")[[1]])
    rq <- c(bits, rq)
  }
  rq
}

is_valid <- function(msg, built, rule_queue, rules) {
  #cat(built, " -> ", rule_queue, "\n")
  if (is.na(built)) return(FALSE)
  if ((length(rule_queue) == 1) && (is.na(rule_queue))) return(FALSE)
  if (length(rule_queue) > nchar(msg) - nchar(built)) return(FALSE)
  if ((identical(msg, built)) & (length(rule_queue) == 0)) return(TRUE)
  if (length(rule_queue) == 0) return(FALSE)
  if ((nchar(built) > 0) & 
      (!identical(substring(msg, 1, nchar(built)), built))) return(FALSE)
  
  rule <- rule_queue[1]
  rule_queue <- rule_queue[-1]
  res <- rules[rules$n == rule, ]
  return(is_valid(msg, trans_built(built, res, 1),
                       trans_rq(rule_queue, res, 1), rules) |
         is_valid(msg, trans_built(built, res, 2),
                       trans_rq(rule_queue, res, 2), rules))
}

p1 <- sum(unlist(lapply(strings, function(x) 
  is_valid(x, "", 0, rules))))

rules$r2[rules$n == 8] <- "42 8"
rules$r2[rules$n == 11] <- "42 11 31"

p2 <- sum(unlist(lapply(strings, function(x) 
  is_valid(x, "", 0, rules))))

c(p1, p2)
