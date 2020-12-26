test <- function(x,y) { if (x==y) "PASS" else "FAIL" }

advent1a <- function(s) {
  v1 <- as.numeric(strsplit(s,"")[[1]])
  v2 <- c(0, v1)
  v1[length(v1)+1] <- v1[1]
  sum(v1 * as.numeric(v1==v2))
}

advent1b <- function(s) {
  v1 <- as.numeric(strsplit(s,"")[[1]])
  v2 <- c(v1[(1+(length(v1)/2)):length(v1)] ,
          v1[1:(length(v1)/2)])
  
  sum(v1 * as.numeric(v1==v2))
  
}

s1 <- readLines("input.txt")

test(advent1a("1122"),3)
test(advent1a("1111"),4)
test(advent1a("1234"),0)
test(advent1a("91212129"),9)

advent1a(s1)

test(advent1b("1212"),6)
test(advent1b("1221"),0)
test(advent1b("123425"),4)
test(advent1b("123123"),12)
test(advent1b("12131415"),4)

advent1b(s1)
