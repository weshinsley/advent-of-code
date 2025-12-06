bigXor <- function(a, b) {
  aleft <- a %/% 2^31
  aright <- a %% 2^31
  bleft <- b %/% 2^31
  bright <- b %% 2^31
  (bitwXor(aleft, bleft) * 2^31) + bitwXor(aright, bright)
}
