d <- unlist(lapply(strsplit(readLines("../AtariBasic/d01/INPUT.TXT"), ", ")[[1]], 
    function(x) c(ifelse(substr(x, 1, 1) == "R", 1, -1),
                  rep(0, as.integer(substring(x, 2)) - 1))))

dir <- (cumsum(d) %% 4 + 1)
x <- cumsum(c(0, 1, 0, -1)[dir])
y <- cumsum(c(-1, 0, 1, 0)[dir])
dist <- abs(x) + abs(y)
comb <- paste0(x, "\r", y)
c(dist[length(d)], dist[which(duplicated(comb))[1]])


