library(crayon)
library(data.table)

validate_byr <- function(d) {
  nchar(d) == 4 && between(as.numeric(d), 1920, 2002)
}

validate_iyr <- function(d) {
  nchar(d) == 4 && between(as.numeric(d), 2010, 2020)
}

validate_eyr <- function(d) {
  nchar(d) == 4 && between(as.numeric(d), 2020, 2030)
}

validate_hgt <- function(d) {
  (grepl("^[0-9]{2}in$", d) &&
    between(as.integer(substring(d, 1, 2)), 59, 76)) ||
  (grepl("^[0-9]{3}cm$", d) &&
    between(as.integer(substring(d, 1, 3)), 150, 193))
}

validate_hcl <- function(d) {
  grepl("^#[0-9a-f]{6}$", d)
}

validate_ecl <- function(d) {
  d %in% c("amb", "blu", "brn", "gry", "grn", "hzl", "oth")
}

validate_pid <- function(d) {
  grepl("^[0-9]{9}$", d)
}

load <- function(f) {
  lines <- strsplit(paste(readLines(f), collapse="\n"), "\n\n")[[1]]
  df <- rbindlist(fill = TRUE, lapply(lines, function(line) {
    line <- gsub("\\n", " ", line)
    bits <- strsplit(line, " ")[[1]]
    df <- as.data.frame(lapply(bits, function(bit) {
      kv <- strsplit(bit, ":")[[1]]
      row <- NULL
      row[[kv[1]]] <- kv[2]
      row
    }))
    df$cid <- NULL
    df$valid1 <- (length(df) == 7)
    df$valid2 <- df$valid1 && validate_byr(df$byr) && validate_iyr(df$iyr) &&
                              validate_eyr(df$eyr) && validate_hgt(df$hgt) && 
                              validate_hcl(df$hcl) && validate_ecl(df$ecl) && 
                              validate_pid(df$pid)
    df
  }))
  df
}

solve <- function(df, part) { 
  sum(df[[paste0("valid", part)]])
}

stopifnot(solve(load("test_part1_2.txt"), 1) == 2)
stopifnot(validate_byr("2002"))
stopifnot(!validate_byr("2003"))
stopifnot(validate_hgt("60in"))
stopifnot(validate_hgt("190cm"))
stopifnot(!validate_hgt("190in"))
stopifnot(!validate_hgt("190"))
stopifnot(validate_hcl("#123abc"))
stopifnot(!validate_hcl("#123abz"))
stopifnot(!validate_hcl("123abc"))
stopifnot(validate_ecl("brn"))
stopifnot(validate_pid("000000001"))
stopifnot(!validate_pid("0123456789"))
stopifnot(solve(load("test_part2_0.txt"), 2) == 0)
stopifnot(solve(load("test_part2_4.txt"), 2) == 4)


wes <- load("wes-input.txt")
cat(red("\nAdvent of Code 2020 - Day 04\n"))
cat(blue("----------------------------\n\n"))
cat("Part 1:", green(solve(wes, 1)), "\n")
cat("Part 2:", green(solve(wes, 2)), "\n")

