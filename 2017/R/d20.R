parse <- function(input) {
  data <- data.frame()
  for (line in input) {
    line <- as.numeric(unlist(strsplit(gsub("p|v|a|=|<|>| |","",line),",")))
    data <- rbind(data, data.frame(
      id = nrow(data),
      px = line[1], py = line[2], pz = line[3],
      vx = line[4], vy = line[5], vz = line[6],
      ax = line[7], ay = line[8], az = line[9], stringsAsFactors=FALSE))
  }
  data
}

advent20a <- function(data, n, remove_collisions = FALSE) {

  for (tick in seq_len(n)) {
    data$vx <- data$vx + data$ax
    data$vy <- data$vy + data$ay
    data$vz <- data$vz + data$az
    data$px <- data$px + data$vx
    data$py <- data$py + data$vy
    data$pz <- data$pz + data$vz

    if (remove_collisions) {
      for (i in seq_len(nrow(data))) {
        data$hash[i] <- paste(data$px[i], data$py[i], data$pz[i], sep="#")
      }

      i <- 1
      while (i < nrow(data)) {
        dups <- which(data$hash == data$hash[i])
        if (length(dups)>1) {
          data <- data[data$hash != data$hash[i],]
        } else {
          i <- i + 1
        }
      }
    }

  }

  if (!remove_collisions) {
    data$dist <- abs(data$px) + abs(data$py) + abs(data$pz)
    res <- data$id[which(data$dist == min(data$dist))]
  } else {
    res <- nrow(data)
  }
  res
}

advent20b <- function(data, n) {
  advent20a(data, n, remove_collisions = TRUE)
}

data <- parse(readLines("../inputs/input_20.txt"))
c(advent20a(data,10000), advent20b(data,100))
