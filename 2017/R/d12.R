advent12a <- function(input, output_no_groups = FALSE) {
  groups <- list()
  for (line in input) {
    line <- gsub(",", " ", line)
    line <- gsub("<-> ","", line)
    bits <- as.numeric(unlist(strsplit(line, "\\s+")))
    found <- FALSE
    for (g in seq_len(length(groups))) {
      group <- groups[[g]]
      if (any(bits %in% group)) {
        groups[[g]] <- unique(c(group, bits))
        found <- TRUE
        break
      }
    }
    if (!found) {
      groups <- c(groups, list(unique(bits)))
    }
  }

  # Join groups where there is overlap...

  changes <- 1
  while (changes == 1) {
    changes <- 0
    g1 <- 1
    while (g1 < length(groups)) {
      group1 <- groups[[g1]]
      g2 <- g1 + 1
      while (g2 <= length(groups)) {
        group2 <- groups[[g2]]
        if (any(group1 %in% group2) || any(group2 %in% group1)) {
          groups[[g1]] <- sort(unique(c(group1, group2)))
          group1 <- groups[[g1]]
          groups[[g2]] <- NULL
          changes <- 1
        } else {
          g2 <- g2 + 1
        }
      }
      g1 <- g1 + 1
    }
  }

  res <- length(groups)
  if (!output_no_groups) {
    for (group in groups) {
      if (0 %in% group) {
        res <- length(group)
        break;
      }
    }
  }
  res
}

advent12b <- function(input) {
  advent12a(input, TRUE)
}

input <- readLines("../inputs/input_12.txt")
c(advent12a(input), advent12b(input))
