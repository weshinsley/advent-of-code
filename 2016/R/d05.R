code <- readLines("../inputs/input_5.txt")
found <- 1
start <- 0
s1 <- rep("_", 8)
s2 <- s1

cat(paste(paste(s1, collapse = ""), paste(s2, collapse = ""), "\r"))

while ("_" %in% s2) {
  codes <- paste0(code, start:(start+999999))
  md5s <- unlist(lapply(codes, function(x) 
    substring(digest::digest(x, algo = "md5", serialize = FALSE), 1, 7)))
  matches <- which(substring(md5s,1,5) == "00000")
  for (m in matches) {
    if (found <= 8) {
      s1[found] <- substring(md5s[m], 6, 6)
      found <- found + 1
    }
    index <- substring(md5s[m], 6, 6)
    if (index %in% c("0","1","2","3","4","5","6","7")) {
      i <- as.integer(index) + 1
      s2[i] <- ifelse(s2[i] == "_", substring(md5s[m], 7, 7), s2[i])
    }
    cat(paste(paste(s1, collapse = ""), paste(s2, collapse = ""), "\r"))
  }
  start <- start + 1000000
}
cat("\n")
