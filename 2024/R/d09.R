parse_file <- function(f = readLines("../inputs/input_9.txt")) {
  d <- as.integer(strsplit(f, "")[[1]])
  df <- data.frame(size = d, 
                   id = floor(seq(from = 0, length.out = length(d) , by = 0.5)))
  df$id[seq(2, to = nrow(df), by = 2)] <- NA
  df$start <- c(1, 1 + cumsum(df$size[1:(nrow(df) - 1)]))
  disk <- rep(NA, sum(d))
  for (x in which(!is.na(df$id))) {
    disk[(df$start[x]):(df$start[x] + df$size[x] - 1)] <- df$id[x]
  } 
  list(disk = disk, df = df[is.na(df$id) & df$size > 0, c("size", "start")])
}

part1 <- function(d) {
  i <- match(NA, d)
  j <- length(d)
  while (j > i) {
    d[i] <- d[j]
    d[j] <- NA
    while (is.na(d[j])) j <- j - 1
    while (!is.na(d[i])) i <- i + 1
  }
  sum(d * (seq_along(d) - 1), na.rm = TRUE)
}

part2 <- function(d) {
  id <- max(d$disk, na.rm = TRUE)
  yend <- length(d$disk)
  while (id >= 0) {
    ystart <- yend
    while ((ystart > 1) && d$disk[ystart - 1] %in% d$disk[yend]) {
      ystart <- ystart - 1
    }
    len <- yend - ystart
    df_index <- which(d$df$size >= (len + 1))[1]
    if (!is.na(df_index)) {
      slot <- d$df$start[df_index]
      i <- d$df$start[df_index]
      d$disk[slot:(slot + len)] <- id
      d$disk[(ystart:yend)] <- NA
      if (d$df$size[df_index] == (len + 1)) {
        d$df$size[df_index] <- -1
      } else {
        d$df$size[df_index] <- d$df$size[df_index] - (len + 1)
        d$df$start[df_index] <- d$df$start[df_index] + (len + 1)
      }
    }
    id <- id - 1
    if (id >= 0) {
      while (!d$disk[yend] %in% id) {
        yend <- yend - 1
      }
    }
  }
  sum(d$disk * (seq_along(d$disk) - 1), na.rm = TRUE)
}

dig <- options()$digits
options(digits = 16)

d <- parse_file()
c(part1(d$disk), part2(d))
options(digits = dig)
