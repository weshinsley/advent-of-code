df_png <- function(d, name, frame, w, h) {
   png(sprintf("%s%d.png", name, frame), 100, 100, units = "px", bg = "black")
   par(mar = c(0, 0, 0, 0))
   plot(x = NA, y = NA, ann = FALSE, axes = FALSE, xaxt = "n" ,yaxt = "n", xlim = c(0, 100), ylim = c(0, 100))
   text(d$px, 103 - d$py, ".", cex = 1.25, col = "green")
   dev.off()
 }
 
 df_grid_print <- function(d, w, h, ch = "#") {
  m <- matrix(" ", ncol = w, nrow = h)
  for (i in seq_len(nrow(d))) {
    m[(d$py[i] + 1), (d$px[i] + 1)] <- ch
  }  
  for (j in 1:h) {
    cat(paste0(m[j, ], collapse = ""), "\n")
  }
  cat("\n")
 }
 
 matrix_plot <- function(m, scale, fname, ch = "#") {
   png(fname, ncol(m) * scale, nrow(m) * scale, 
       units = "px", bg = "black")
   par(mar = c(0, 0, 0, 0))
   plot(x = NA, y = NA, ann = FALSE, axes = FALSE, xaxt = "n" ,yaxt = "n", 
        xlim = c(0, ncol(m) * scale), ylim = c(0, nrow(m) * scale))
   pix <- which(m >= 0, arr.ind = TRUE)
   for (p in seq_len(nrow(pix))) {
     rect(pix[p, 1] * scale, pix[p, 2] * scale, 
          (pix[p, 1] + 1) * scale, (pix[p, 2] + 1) * scale, col = "blue")
   }
   dev.off()
 }
 