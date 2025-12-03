d <- gsub(": ", "-", gsub(" or ", "-", readLines("../inputs/input_16.txt")))
rules <- data.table::rbindlist(lapply(strsplit(d[1:(which(d == "")[1]-1)], "-"),
  function(x) data.frame(type = x[1], f1 = x[2], t1 = x[3], f2 = x[4], t2 = x[5])))
mine <- read.csv(text = d[which(d == "")[1] + 2], header = FALSE)
others <- read.csv(text = paste(d[(which(d == "")[2] + 2):length(d)], sep  = "\n"),
                   header = FALSE)
ok <- c()
for (i in seq_len(nrow(rules))) {
  ok <- unique(c(ok, rules$f1[i]:rules$t1[i]))
  ok <- unique(c(ok, rules$f2[i]:rules$t2[i]))
}

found <- unique(as.integer(unlist(others)))
baddies <- sort(found[!found %in% ok])
keep <- NULL
count <- 0
for (i in seq_len(nrow(others))) {
  row <- as.integer(others[i,] )
  row <- row[row %in% baddies]
  if (length(row) > 0) {
    count <- count + sum(row)
  } else {
    keep <- rbind(keep, others[i, ])
  }
}

possible <- list()
for (i in seq_len(nrow(rules))) {
  possible[[i]] <- NA
  # Which columns could fit with this rule?
  for (j in seq_len(length(others))) {
    if (all(keep[[j]] %in% 
      c(rules$f1[i]:rules$t1[i], rules$f2[i]:rules$t2[i]))) {
      possible[[i]] <- c(possible[[i]], j)
      possible[[i]] <- possible[[i]][!is.na(possible[[i]])]
    }
  }
}

mapping <- rep(0, nrow(rules))
while (any(unlist(lapply(possible, length)) > 0)) {
  single <- which(lapply(possible, length) == 1)
  choice <- possible[[single]]
  mapping[single] <- choice
  for (i in seq_along(possible)) {
    possible[[i]] <- possible[[i]][possible[[i]] != choice]
  }
}

departures <- which(grepl("departure", rules$type))
c(count, prod(as.numeric(mine[mapping[departures]])))
