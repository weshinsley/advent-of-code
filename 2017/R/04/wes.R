test <- function(x,y) { if (x==y) "PASS" else "FAIL" }

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


test(valid_4a("aa bb cc dd ee"), TRUE)
test(valid_4a("aa bb cc dd aa"), FALSE)
test(valid_4a("aa bb cc dd aaa"), TRUE)

passbook <- readLines("input.txt")
advent4a(passbook)

test(valid_4b("abcde fghij"), TRUE)
test(valid_4b("abcde xyz ecdab"), FALSE)
test(valid_4b("a ab abc abd abf abj"), TRUE)
test(valid_4b("iiii oiii ooii oooi oooo"), TRUE)
test(valid_4b("oiii ioii iioi iiio"), FALSE)
advent4b(passbook)
