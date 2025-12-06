parse_file <- function(f = "../inputs/input_24.txt") {
  d <- readLines(f)
  sp <- which(d == "")
  vars <- strsplit(d[1:(sp - 1)], ": ")
  vars <- data.frame(k = unlist(lapply(vars, `[[`, 1)),
                     v = as.integer(unlist(lapply(vars, `[[`, 2))))
  cmds <- strsplit(d[(sp + 1):length(d)], " ")
  cmds <- data.frame(lhs = unlist(lapply(cmds, `[[`, 1)),
                     op = unlist(lapply(cmds, `[[`, 2)),
                     rhs = unlist(lapply(cmds, `[[`, 3)),
                     out = unlist(lapply(cmds, `[[`, 5)))
  swaps <- (substring(cmds$lhs, 1, 1) == "y" & substring(cmds$rhs, 1, 1) == "x")
  z <- cmds$lhs[swaps]
  cmds$lhs[swaps] <- cmds$rhs[swaps]
  cmds$rhs[swaps] <- z
  cmds <- cmds[order(cmds$lhs, cmds$op), ]
  all_vars <- unique(c(cmds$lhs, cmds$rhs, cmds$out))
  all_vars <- setdiff(all_vars, vars$k)
  vars <- rbind(vars, data.frame(k = all_vars, v = -1))
  vars <- vars[order(vars$k),]
  
  # put easy terms on the left)
  for (i in seq_len(nrow(cmds))) {
    rhs <- cmds$rhs[i]
    if (!substring(rhs, 1, 1) %in% c("x", "y")) {
      rule <- cmds[cmds$out == rhs,]
      if ((substring(rule$lhs, 1, 1) %in% c("x", "y")) &&
          (substring(rule$rhs, 1, 1) %in% c("x", "y"))) {
        x <- cmds$rhs[i]
        cmds$rhs[i] <- cmds$lhs[i]
        cmds$lhs[i] <- x
      }
    }
  }
  list(vars = vars, cmds = cmds)
}

run <- function(cmds, vars) {
  while (nrow(cmds) > 0) {
    i <- 1
    while (i <= nrow(cmds)) {
      line <- cmds[i, ]
      li <- which(vars$k == line$lhs)
      ri <- which(vars$k == line$rhs)
      oi <- which(vars$k == line$out)
      if ((vars$v[li] != -1) && (vars$v[ri] != -1)) {
        if (line$op == "AND") {
          vars$v[oi] <- bitwAnd(vars$v[li], vars$v[ri])
        } else if (line$op == "OR") {
          vars$v[oi] <- bitwOr(vars$v[li], vars$v[ri])
        } else if (line$op == "XOR") {
          vars$v[oi] <- bitwXor(vars$v[li], vars$v[ri])
        }
        cmds <- cmds[-i, ]
      } else {
        i <- i + 1
      }
    }
  }
  vars
}

getBinary <- function(vars, prefix, bin = FALSE) {
  i <- 0
  z <- 0
  pow <- 1
  bb <- ""
  while (TRUE) {
    zz <- i
    if (i < 10) zz <- paste0(prefix, 0, i) 
    else zz <- paste0(prefix, i)
    if (zz %in% vars$k) {
      val <- vars$v[vars$k == zz]
      bb <- paste0(val, bb)
      z <- z + pow * val
      i <- i + 1
      pow <- pow * 2
    } else break
  }
  if (bin) bb else z
}

part1 <- function(d) {
  vars <- run(d$cmds, d$vars)
  getBinary(vars, "z")
}

errors <- function(d) {
  vars <- run(d$cmds, d$vars)
  x <- getBinary(vars, "x", bin = TRUE)
  y <- getBinary(vars, "y", bin = TRUE)
  zbad <- getBinary(vars, "z", bin = TRUE)
  zgood <- ""
  carry <- 0
  for (i in rev(seq_len(nchar(x)))) {
    v <- as.integer(substring(x, i, i)) + as.integer(substring(y, i, i)) + carry
    carry <- (v >= 2)
    v <- v %% 2
    zgood <- paste0(v, zgood)
  }
  if (nchar(zgood) < nchar(zbad)) {
    zgood <- paste0(0, zgood)
  }
  j <- 0
  for (i in rev(seq_len(nchar(zgood)))) {
    if (substring(zgood, i, i) != substring(zbad, i, i)) {
      v <- nchar(zgood) - i
      if (v < 10) v <- paste0("0", v) 
      v <- paste0("z", v)
      message(sprintf("i = %d, g = %s, b = %s, %s = %s", i,
                      substring(zgood, i, i), substring(zbad, i, i), 
                      v, vars$v[vars$k == v]))
    }
  }
}


expand <- function(cmds, var, prefix = "") {
  cmd <- cmds[cmds$out == var,]
  message(sprintf("%s%s %s %s -> %s", prefix, cmd$lhs, cmd$op, cmd$rhs, cmd$out))
  prefix <- paste0("  ", prefix)
  if (!substring(cmd$lhs, 1, 1) %in% c("x", "y")) {
    expand(cmds, cmd$lhs, prefix)
  }
  if (!substring(cmd$rhs, 1, 1) %in% c("x", "y")) {
    expand(cmds, cmd$rhs, prefix)
  }
}

part2 <- function(d) {
  cmds <- d$cmds
  
  # errors(d)
  # expand(d, "z10")
  
  # x10 AND y10 -> z10
  # kck XOR x10 XOR y10 -> kck
  
  cmds$out[cmds$lhs == "kck" & cmds$op == "XOR" & cmds$rhs == "skm"] <- "z10"
  cmds$out[cmds$lhs == "x10" & cmds$op == "AND" & cmds$rhs == "y10"] <- "vcf"
  
  # errors(d)
  # expand(d, "z17")
  
  # qjg XOR jjf fhg
  # qjg AND jjf z17
  
  cmds$out[cmds$lhs == "qjg" & cmds$op == "XOR" & cmds$rhs == "jjf"] <- "z17"
  cmds$out[cmds$lhs == "qjg" & cmds$op == "AND" & cmds$rhs == "jjf"] <- "fhg"
  
  #   lhs  op rhs out
  # 54 x35 AND y35 dvb
  # 16 x35 XOR y35 fsq
  
  cmds$out[cmds$lhs == "x35" & cmds$op == "XOR" & cmds$rhs == "y35"] <- "dvb"
  cmds$out[cmds$lhs == "x35" & cmds$op == "AND" & cmds$rhs == "y35"] <- "fsq"

  #   lhs  op rhs out
  # 57  rvd OR wrj z39
  # 179 kmh XOR mnd tnc
  
  cmds$out[cmds$lhs == "rvd" & cmds$op == "OR" & cmds$rhs == "wrj"] <- "tnc"
  cmds$out[cmds$lhs == "kmh" & cmds$op == "XOR" & cmds$rhs == "mnd"] <- "z39"
  paste0(sort(c("z10", "vcf", "z17", "fhg", "dvb", "fsq", "tnc", "z39")), collapse=",")
}

part2b <- function(d) {
  z <- 2
  zn <- d$
  for (i in 2:45) {
    zn <- d$cmds[d$cmds$out == paste0("z", ifelse (i < 10, "0", ""), i, collapse = ""), ]    
  }
}

d <- parse_file()
c(part1(d), part2(d))
