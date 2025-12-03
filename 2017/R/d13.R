advent13a <- function(df, delay = 0, catch_zero_sev = FALSE) {
  df$direction <- 1
  df$pos <- 1
  p_depth <- -1
  max_depth <- 1 + max(df$depth)
  severity <- 0
  ptime <- 0

  while (p_depth < max_depth) {
    if (ptime >= delay) {
      p_depth <- p_depth + 1
    }
    ptime <- ptime + 1

    scanner <- df[df$depth == p_depth,]
    if (nrow(scanner) != 0) {
      if (scanner$pos == 1) {
        severity <- severity + (scanner$depth * scanner$range)
        if (catch_zero_sev) {
          severity <- 1
          p_depth <- max_depth
        }
      }
    }
    for (s in seq_len(nrow(df))) {
      df$pos[s] <- df$pos[s] + df$direction[s]
      if ((df$pos[s] == 1) || (df$pos[s] == df$range[s])) {
        df$direction[s] <- (-df$direction[s])
      }
    }
  }
  severity
}

advent13b_faster <- function(df, delay, max_depth) {
  sev <- 0
  for (i in 0:max_depth) {
    range <- df$range[df$depth == i]
    if (length(range) > 0) {
      if (((delay + i) %% ((range * 2) - 2)) == 0) {
        sev <- 999
        break
      }
    }
  }
  sev
}

advent13b <- function(input) {
  delay <- -1
  severity <- 999
  max_depth <- 1 + max(input$depth)
  while (severity > 0) {
    delay <- delay + 1
    severity <- advent13b_faster(input, delay, max_depth)
  }
  delay
}

input <- read.csv("../inputs/input_13.txt", sep = ":", stringsAsFactors = FALSE, header = FALSE)
names(input) <- c("depth","range")

c(advent13a(input), advent13b(input))
