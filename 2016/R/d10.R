d <- readLines("../inputs/input_10.txt")

vals <- read.csv(text = gsub(" goes to bot ", ",", gsub("value ", "", 
  d[grepl("value", d)])), header = FALSE, col.names = c("v1", "b"))
vals$v2 <- NA
dups <- vals[duplicated(vals$b), ]
vals$v2[match(dups$b, vals$b)] <- dups$v1
vals <- vals[!duplicated(vals$b), ]

assign <- read.csv(text = gsub("bot ", "", gsub(" and high to bot ", ",", 
  gsub(" gives low to bot ", ",", 
       d[grepl("low to bot", d) & grepl("high to bot", d)]))),
  header = FALSE, col.names = c("src", "lo_to", "hi_to"))

output <- read.csv(text = gsub("output ", "O,", gsub("bot ", "B,", 
  gsub(" gives low to ", ",", gsub(" and high to ", ",", d[grepl("output", d)]
  )))), header = FALSE, col.names = c("x", "bot", "lo", "lo_to", "hi", "hi_to"))

all_bots <- unique(c(vals$b, output$lo_to[output$lo == 'B'], 
  output$hi_to[output$hi == 'B'], assign$src, assign$lo_to, assign$hi_to))

vals <- rbind(vals, data.frame(v1 = NA, v2 = NA, 
                               b = all_bots[!all_bots %in% vals$b]))

outs <- data.frame(n = unique(c(output$lo_to[output$lo == 'O'],
                                output$hi_to[output$hi == 'O'])), v = NA)


while (nrow(vals) > 0) {
  ready <- which(!is.na(vals$v1) & !is.na(vals$v2))[1]
  res <- sort(c(vals$v1[ready], vals$v2[ready]))
  ass <- assign[assign$src == vals$b[ready], ]
  if (nrow(ass) == 1) {
    asslo <- which(vals$b == ass$lo_to)
    asshi <- which(vals$b == ass$hi_to)
  
    if (is.na(vals$v1[asslo])) {
      vals$v1[asslo] <- res[1]
    } else {
      vals$v2[asslo] <- res[1]
    }
  
    if (is.na(vals$v1[asshi])) {
      vals$v1[asshi] <- res[2]
    } else {
      vals$v2[asshi] <- res[2]
    }
  }
  
  out <- output[output$bot == vals$b[ready], ]
  if (nrow(out) == 1) {
    if (out$lo == "O") {
      outs$v[outs$n == out$lo_to] <- res[1]
    } else {
      if (is.na(vals$v1[out$lo_to])) {
        vals$v1[vals$b == out$lo_to] <- res[1]
      } else {
        vals$v2[vals$b == out$lo_to] <- res[1]
      }
    }
    
    if (out$hi == "O") {
      outs$v[outs$n == out$hi_to] <- res[2]
    } else {
      if (is.na(vals$v1[vals$b == out$hi_to])) {
        vals$v1[vals$b == out$hi_to] <- res[2]
      } else {
        vals$v2[vals$b == out$hi_to] <- res[2]
      }
    }
  }
  if (identical(sort(c(vals$v1[ready], vals$v2[ready])), c(17L, 61L))) {
    cat(sprintf("%s  ", vals$b[ready]))
  }
  vals <- vals[-ready, ]
}

message(prod(outs$v[outs$n %in% c(0,1,2)]))
