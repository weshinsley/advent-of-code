valid_4a <- function(p) {
  bits <- unlist(strsplit(p, split = " "))
  sum(duplicated(bits)) == 0
}

advent4a <- function(passbook) {
  sum(unlist(lapply(passbook, valid_4a)))
}

sort_chars <- function(p) {
  paste0(sort(unlist(strsplit(p, ""))), collapse="")
}

valid_4b <- function(p) {
  bits <- unlist(strsplit(p, split = " "))
  bits <- unlist(lapply(bits, sort_chars))
  sum(duplicated(bits)) == 0
}

advent4b <- function(passbook) {
  sum(unlist(lapply(passbook, valid_4b)))
}

passbook <- readLines("../inputs/input_4.txt")
c(advent4a(passbook), advent4b(passbook))
