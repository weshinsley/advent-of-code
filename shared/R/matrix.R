pad_matrix <- function(m, pad_size, with) {
   m2 <- matrix(with, nrow = nrow(m) + (2 * pad_size), 
                      ncol = ncol(m) + (2 * pad_size))
  m2[(1 + pad_size):(nrow(m) + pad_size), 
     (1 + pad_size):(ncol(m) + pad_size)] <- m
  m2
}

strings_to_int_matrix <- function(d) {
  nrow <- length(d)
  matrix(as.integer(unlist(lapply(d, function(x) strsplit(x, "")[[1]]))),
         nrow = nrow, byrow = TRUE)
}

strings_to_char_matrix <- function(d) {
  nrow <- length(d)
  matrix(unlist(lapply(d, function(x) strsplit(x, "")[[1]])),
         nrow = nrow, byrow = TRUE)
}

strings_to_matrix_df <- function(d, keep = NULL, ignore = NULL) {
  d <- strings_to_char_matrix(d)
  chars <- names(table(unique(d)))
  if (!is.null(keep)) {
    chars <- chars[chars %in% keep]
  } 
  if (!is.null(ignore)) {
    chars <- chars[!chars %in% ignore]
  }
  df <- NULL
  for (ch in chars) {
    pos <- which(d == ch, arr.ind = TRUE)
    df <- rbind(df, data.frame(ch = ch, x = as.integer(pos[, 2]), 
                               y = as.integer(pos[, 1])))
  }
  df
}
