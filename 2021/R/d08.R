part1 <- function(d) {
  sum(c(nchar(d[[12]]), nchar(d[[13]]), 
        nchar(d[[14]]), nchar(d[[15]])) %in% c(2,3,4,7))
}

chdiff <- function(a, b) {
  if (nchar(b) > nchar(a)) {
    return(setdiff(strsplit(b, "")[[1]], strsplit(a, "")[[1]]))
  }
  setdiff(strsplit(a, "")[[1]], strsplit(b, "")[[1]])
}

sortch <- function(a) {
  paste0(sort(strsplit(a, "")[[1]]), collapse = "")
}

part2 <- function(d) {
  t <- 0
  
  for (i in seq_len(nrow(d))) {
    row <- unlist(lapply(as.character(d[i, ]), sortch))
    res <- row[12:15]
    row <- row[1:10]
    map <- list()
    for (i in 0:9) map[[as.character(i)]] <- NA
    
    map[["1"]] <- row[nchar(row) == 2]
    seg_1a <- substring(map[["1"]], 1, 1)
    seg_1b <- substring(map[["1"]], 2, 2)
    map[["4"]] <- row[nchar(row) == 4]
    map[["7"]] <- row[nchar(row) == 3]
    map[["8"]] <- row[nchar(row) == 7]
  
    # 3 contains all of 1
    map[["3"]] <- row[nchar(row) == 5]
    map[["5"]] <- map[["3"]]
    map[["2"]] <- map[["3"]]
    map[["3"]] <- map[["3"]][which(grepl(seg_1a, map[["3"]]) & 
                                   grepl(seg_1b, map[["3"]]))]
    
    # 6 doesn't contain all of 1
    map[["6"]] <- row[nchar(row) == 6]
    map[["9"]] <- map[["6"]]
    map[["0"]] <- map[["6"]]
    map[["6"]] <- map[["6"]][c(which(!grepl(seg_1a, map[["6"]])), 
                               which(!grepl(seg_1b, map[["6"]])))]

    # diff between 5 and 9 should be one segment
    
    map[["5"]] <- map[["5"]][map[["5"]] != map[["3"]]]
    map[["9"]] <- map[["9"]][map[["9"]] != map[["6"]]]
    
    for (x in 1:4) {
      d5 <- ifelse(x <= 2, 1, 2)
      d9 <- ifelse(x %% 2 == 0, 1, 2)
      if (length(chdiff(map[["5"]][d5], map[["9"]][d9])) == 1) {
        map[["5"]] <- map[["5"]][d5]
        map[["9"]] <- map[["9"]][d9]
        break
      }
    }
    
    map[["0"]] <- map[["0"]][!map[["0"]] %in% c(map[["6"]], map[["9"]])]
    map[["2"]] <- map[["2"]][!map[["2"]] %in% c(map[["3"]], map[["5"]])]
    
    map <- unlist(map)
    res <- as.integer(paste(names(map)[match(res, map)], collapse = ""))
    
    t <- t + res
  }
  t
}

d <- read.csv("../inputs/input_8.txt", sep = " ", header = FALSE)
c(part1(d), part2(d))
