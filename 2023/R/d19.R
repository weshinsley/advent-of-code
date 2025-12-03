parse_input <- function(f) {
  d <- readLines(f)
  workflows <- d[1:(which(d == "") - 1)]
  ratings <- d[(which(d == "") + 1):length(d)]
  ratings <- read.csv(text = gsub("[{=xmas}]", "", ratings), header = FALSE,
                      col.names = c("x", "m", "a", "s"))
  code <- c()
  for (w in workflows) {
    code <- c(code, interp1(w))
  }
  for (w in workflows) {
    code <- c(code, interp2(w))
  }
  tf <- tempfile()
  write(code, tf)
  source(tf)
  ratings
}

interp1 <- function(s) {
  code <- ""
  s <- strsplit(s, "\\{")[[1]]
  fname <- s[[1]]
  code <- sprintf("d19a_%s <- function(x, m, a, s) {", fname)
  s <- strsplit(substring(s[[2]], 1, nchar(s[[2]]) - 1), ",")[[1]]
  for (cond in s) {
    if (cond == "A") {
      code <- c(code, "  return(TRUE)")
    } else if (cond == "R") {
      code <- c(code, "  return(FALSE)")
    } else if (grepl(":", cond)) {
      bits <- strsplit(cond, ":")[[1]]
      bits[1] <- gsub("<", " < ", bits[1])
      bits[1] <- gsub(">", " > ", bits[1])

      code <- c(code, sprintf("  if (%s) { return(%s) }", bits[1],
                                 if (bits[2] == "A") "TRUE"
                                 else if (bits[2] == "R") "FALSE"
                                 else sprintf("d19a_%s(x, m, a, s)", bits[2])))
    } else {
      code <- c(code, sprintf("  return (d19a_%s(x, m, a, s))", cond))
    }
  }
  c(code, "}")
}

interp2 <- function(s) {
  code <- ""
  s <- strsplit(s, "\\{")[[1]]
  fname <- s[[1]]
  score <- "(1+(x2-x1))*(1+(m2-m1))*(1+(a2-a1))*(1+(s2-s1))"
  fcall <- c("x1, x2, m1, m2, a1, a2, s1, s2")
  code <- c(
    sprintf("d19b_%s <- function(x1, x2, m1, m2, a1, a2, s1, s2) {", fname),
            "  total <- 0")

  s <- strsplit(substring(s[[2]], 1, nchar(s[[2]]) - 1), ",")[[1]]
  for (cond in s) {
    if (cond == "A") {
      code <- c(code, sprintf("  total <- total + %s", score))
    } else if (grepl(":", cond)) {
      bits <- strsplit(cond, ":")[[1]]
      if (grepl("<", bits[1])) {
        comp <- strsplit(bits[1], "<")[[1]]
        if (bits[2] == "A") {
          score2 <- gsub(
            sprintf("%s2", comp[1]),
            sprintf("min(%s2, %s)", comp[1], as.numeric(comp[2]) - 1), score)
          code <- c(code, sprintf("  total <- total + %s", score2))

        } else if (bits[2] != "R") {
          fcall2 <- gsub(
            sprintf("%s2", comp[1]),
            sprintf("min(%s2, %s)", comp[1], as.numeric(comp[2]) - 1), fcall)
          code <- c(code, sprintf("  total <- total + d19b_%s(%s)",
                    bits[2], fcall2))
        }
        code <- c(code,
          sprintf("  %s1 <- max(%s1, %s)", comp[1], comp[1], comp[2]))

      } else if (grepl(">", bits[1])) {
        comp <- strsplit(bits[1], ">")[[1]]
        if (bits[2] == "A") {
          score2 <- gsub(
            sprintf("%s1", comp[1]),
            sprintf("max(%s1, %s)", comp[1], as.numeric(comp[2]) + 1), score)

          code <- c(code,  sprintf("  total <- total + %s", score2))

        } else if (bits[2] != "R") {
          fcall2 <- gsub(
            sprintf("%s1", comp[1]),
            sprintf("max(%s1, %s)", comp[1], as.numeric(comp[2]) + 1), fcall)
          code <- c(code, sprintf("  total <- total + d19b_%s(%s)",
                    bits[2], fcall2))
        }
        code <- c(code,
                  sprintf("  %s2 <- min(%s2, %s)", comp[1], comp[1], comp[2]))

      }
    } else if (cond != "R") {
      code <- c(code, sprintf("  total <- total + d19b_%s(%s)", cond, fcall))
    }
  }
  c(code, "  total", "}")
}

part1 <- function(d, p2 = FALSE) {
  tot <- 0
  for (i in seq_len(nrow(d))) {
    if (d19a_in(d$x[i], d$m[i], d$a[i], d$s[i])) {
      tot <- tot + (d$x[i] + d$m[i] + d$a[i] + d$s[i])
    }
  }
  tot
}

part2 <- function(d) {
  format(d19b_in(1, 4000, 1, 4000, 1, 4000, 1, 4000), digits = 14)
}

d <- parse_input("../inputs/input_19.txt")
c(part1(d), part2(d))
