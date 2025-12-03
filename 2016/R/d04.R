d <- data.table::rbindlist(lapply(readLines("../inputs/input_4.txt"), 
  function(x) {
    str <- substring(x, 1, rev(gregexpr("-", x)[[1]])[1])
    sec <- as.integer(substring(x, rev(gregexpr("-", x)[[1]])[1] + 1,
                               gregexpr("\\[", x)[[1]][1] - 1))
    chk <- gsub("]", "", strsplit(x, "\\[")[[1]][2])
    dec <- utf8ToInt(str) - 97
    dec[dec >= 0] <- (dec[dec >= 0] + sec) %% 26
    dec <- intToUtf8(dec + 97)
    data.frame(str = str, sec = sec, chk = chk, dec = dec)
  }
))

c(sum(unlist(lapply(seq_len(nrow(d)), function(x)
 ifelse(paste(names(sort(table(sort(
   strsplit(gsub("-", "", d$str[x]), "")[[1]])),
                      decreasing=TRUE)[1:5]), 
          collapse="") == d$chk[x], d$sec[x], 0)))),
 d$sec[grepl("northpole", d$dec)])
