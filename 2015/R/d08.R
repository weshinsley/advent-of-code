d <- lapply(readLines("../inputs/input_8.txt"), function(x) {
  x <- gsub("\\\\", "/", x)
  substring(x, 2, nchar(x) - 1)
})

c(
sum(unlist(lapply(d, nchar))) + (2 * length(d)) - 
  sum(unlist(lapply(d, function(x) {
    x <- gsub("//", "1", x)
    x <- gsub("/x..", "1", x)
    x <- gsub("/\"", "1", x)
    nchar(x)
  }))),

-(sum(unlist(lapply(d, nchar)))) + (4 * length(d)) + 
  sum(unlist(lapply(d, function(x) {
    x <- gsub("/\"", "4444", x)
    x <- gsub("//", "4444", x)
    x <- gsub("/x..", "55555", x)
    nchar(x)
  })))
)
