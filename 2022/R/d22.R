# Some constants to make things tidier below.

right <- 1
down <- 2
left <- 3
up <- 4

dx <- c(1, 0, -1, 0)
dy <- c(0, 1, 0, -1)

set <- 0
add <- 1
subf <- 2

#####################################################
# The orientation for the part 2 test in the spec:-
#
#       A
#     BCD
#       EF

test_ty <- data.frame(
  #       A^       B^    C^    F^     Bv      Cv    Ev   Fv
  xge = c(9,       1,    5,     13,    1,     5,     9,   13),
  xle = c(12,      4,    8,     16,    4,     9,    12,   16),
  ye =  c(0,       4,    4,      8,    9,     9,    13,   13),
  xop = c(subf, subf,  set,    set, subf,   set,  subf,  set),
  xv =  c(13,     13,    9,     12,   13,     9,    13,    1),
  yop = c(set,   set,  add,   subf,  set,  subf,   set, subf),
  yv  = c(5,       1,   -4,     21,   12,    17,     8,   21),
  ndi = c(down, down, down,   left,   up, right,    up, right)
)

test_tx <- data.frame(
  #         <-A,   A->  <-B     D->   <-E     F->
  xe =  c(    8,   13,    0,    13,     8,    17),
  yge = c(    1,    1,    5,     5,     9,     9),
  yle = c(    4,    4,    8,     8,    12,    12),
  xop = c(  add,  set, subf,  subf,  subf,   set),
  xv =  c(    4,   16,   21,    21,    17,    12),
  yop = c(  set, subf,  set,   set,   set,  subf),
  yv =  c(    5,   13,   12,     9,     8,    13),
  ndi = c( down, left,   up,  down,    up,  left)
)

########################################################
# Hard-coded for my map orientation:-
#          AB
#          C
#         DE
#         F


wes_trans_y <- data.frame(
  #       A^     B^    Bv     D^    Ev    Fv
  xge = c(51,   101,  101,     1,   51,     1),
  xle = c(100,  150,  150,    50,  100,    50),
  ye =  c(0,      0,   51,   100,  151,   201),
  xop = c(set,  add,  set,   set,  set,   add),
  xv =  c(1,   -100,  100,    51,   50,   100),
  yop = c(add,  set,  add,   add,  add,   set),
  yv  = c(100,  200,  -50,    50,  100,     1),
  ndi = c(right, up, left, right, left,  down)
)

wes_trans_x <- data.frame(
  #         <-A    B->   <-C    C->     <-D    E->    <-F      F->
  xe =  c(   50,   151,    50,  101,      0,   101,      0,    51),
  yge = c(    1,     1,    51,   51,    101,   101,    151,   151),
  yle = c(   50,    50,   100,  100,    150,   150,    200,   200),
  xop = c(  set,   set,   add,  add,    set,   set,    add,   add),
  xv =  c(    1,   100,   -50,   50,     51,   150,   -100,  -100),
  yop = c( subf,  subf,   set,  set,   subf,  subf,    set,   set),
  yv =  c(  151,   151,   101,   50,    151,   151,      1,   150),
  ndi = c(right,  left,  down,   up,  right,  left,   down,   up)
)

parse <- function(f) {
  d <- readLines(f)
  gap <- which(d == "")
  map <- strsplit(gsub(" ", "0", gsub("\\.", "1",
    gsub("#", "2", d[1:(gap - 1)], ""))), "")
  nc <- max(unlist(lapply(map, length)))
  for (i in seq_along(map)){
    x <- nc - length(map[[i]])
    if (x > 0) {
      map[[i]] <- c(map[[i]], rep("0", x))
    }
  }

  mat <- matrix(as.integer(unlist(map)), ncol = nc, byrow = TRUE)
  dir <- d[[gap + 1]]

  list(map = mat, inst = dir)
}

wrap3d <- function(x2, y2, dir, tx, ty) {

  within <- function(a, b, c) {
    if (length(b) > length(a)) {
      a <- rep(a, length(b))
    }
    (a >= b) & (a <= c)
  }

  if (dir %in% c(up, down)) {
    row <- ty[within(x2, ty$xge, ty$xle) & y2 == ty$ye, ]
    if (row$xop == set) x3 <- row$xv
    else if (row$xop == add) x3 <- x2 + row$xv
    else if (row$xop == subf) x3 <- row$xv - x2
    if (row$yop == set) y3 <- row$yv
    else if (row$yop == add) y3 <- x2 + row$yv
    else if (row$yop == subf) y3 <- row$yv - x2
    c(x3, y3, row$ndi)

  } else {
    row <- tx[within(y2, tx$yge, tx$yle) & x2 == tx$xe, ]
    if (row$xop == set) x3 <- row$xv
    else if (row$xop == add) x3 <- y2 + row$xv
    else if (row$xop == subf) x3 <- row$xv - y2
    if (row$yop == set) y3 <- row$yv
    else if (row$yop == add) y3 <- y2 + row$yv
    else if (row$yop == subf) y3 <- row$yv - y2
    c(x3, y3, row$ndi)
  }
}

test_wrap3d <- function() {
  tt <- function(x1, y1, dir1, x2, y2, dir2,
                 tx = wes_trans_x, ty = wes_trans_y) {
    if (length(y1) > length(x1)) x1 <- rep(x1, length(y1))
    if (length(y2) > length(x2)) x2 <- rep(x2, length(y2))
    if (length(x1) > length(y1)) y1 <- rep(y1, length(x1))
    if (length(x2) > length(y2)) y2 <- rep(y2, length(x2))

    for (i in seq_along(x1))
      stopifnot(identical(wrap3d(x1[i], y1[i], dir1, tx, ty),
                          c(x2[i], y2[i], dir2)))
  }

  tt(51:100, 0, up, 1, 151:200, right)       # Up from A -> left of F
  tt(101:150, 0, up, 1:50, 200, up)          # Up from B -> bottom of F
  tt(101:150, 51, down, 100, 51:100, left)   # Down from B -> Right of C
  tt(50, 1:50, left, 1, 150:101, right)      # Left from A => inv left of D
  tt(151, 1:50, right, 100, 150:101, left)   # Right  from B => inv right of E
  tt(50, 51:100, left, 1:50, 101, down)      # Left of C => top of D
  tt(101, 51:100, right, 101:150, 50, up)    # Right from C => bottom of B
  tt(1:50, 100, up, 51, 51:100, right)       # Up from D => Left of C
  tt(0, 101:150, left, 51, 50:1, right)      # Left from D => inv left of A
  tt(101, 101:150, right, 150, 50:1, left)   # Right from E => inv right of B
  tt(51:100, 151, down, 50, 151:200, left)   # Down from E => right of F
  tt(0, 151:200, left, 51:100, 1, down)      # Left from F => Top of A
  tt(51, 151:200, right, 51:100, 150, up)    # Right from F => bottom of E
  tt(1:50, 201, down, 101:150, 1, down)      # Down from F => top of B

  tt(9:12, 0, up, 4:1, 5, down, test_tx, test_ty)   # Up from A -> bottom of B
  tt(1:4, 4, up, 12:9, 1, down, test_tx, test_ty)   # Up from B -> bottom of A
  tt(5:8, 4, up, 9, 1:4, down, test_tx, test_ty)    # Up from C -> left of A
  tt(13:16, 8, up, 12, 8:5, left, test_tx, test_ty)  # Up from F -> right of D
  tt(1:4, 9, down, 12:9, 12, up, test_tx, test_ty)   # Down from B = bottom of E
  tt(5:8, 9, down, 9, 12:9, right, test_tx, test_ty) # Down from C = left of E
  tt(9:12, 13, down, 4:1, 8, up, test_tx, test_ty) # Down from E = bottom of B
  tt(13:16, 13, down, 1, 8:5, right, test_tx, test_ty) # Down from F = left of B
  tt(8, 1:4, left, 5:8, 5, down, test_tx, test_ty) # Left from A = top of C
  tt(13, 1:4, right, 16, 12:9, left, test_tx, test_ty) # Rgt from A = right of F
  tt(0, 5:8, left, 16:13, 12, up, test_tx, test_ty) # Left from B = bottom of F
  tt(13, 5:8, right, 16:13, 9, down, test_tx, test_ty) # Rgt from D = top of F
  tt(8, 9:12, left, 8:5, 8, up, test_tx, test_ty) # Left from E = bottom of C
  tt(17, 9:12, right, 12, 4:1, left, test_tx, test_ty) # Rgt from F = right of A

}

part1 <- function(d, part2 = FALSE, tx = NA, ty = NA) {
  x <- which(d$map[1, ] != 0)[1]
  y <- 1
  dir <- 1
  p <- 1
  nums <- TRUE
  while (p <= nchar(d$inst)) {
    if (nums) {
      p2 <- p
      while ((p2 <= nchar(d$inst)) &&
             (!substr(d$inst, p2, p2) %in% c("R", "L"))) p2 <- p2 + 1
      steps <- as.integer(substr(d$inst, p, p2 - 1))
      x2 <- x
      y2 <- y
      while (steps > 0) {
        steps <- steps - 1
        old_x2 <- x2
        old_y2 <- y2
        old_dir <- dir
        x2 <- x2 + dx[dir]
        y2 <- y2 + dy[dir]
        if ((x2 > ncol(d$map)) || (x2 == 0) ||
            (y2 > nrow(d$map)) || (y2 == 0) || (d$map[y2, x2] == 0)) {

          if (!part2) {
            if (dir == right) x2 <- which(d$map[y2, ] != 0)[1]
            else if (dir == down) y2 <- which(d$map[, x2] != 0)[1]
            else if (dir == left) x2 <- rev(which(d$map[y2, ] != 0))[1]
            else if (dir == up) y2 <- rev(which(d$map[, x2] != 0))[1]

          } else {
            res <- wrap3d(x2, y2, dir, tx, ty)
            x2 <- res[1]
            y2 <- res[2]
            dir <- res[3]
          }
        }
        if (d$map[y2, x2] != 1) {
          steps <- 0
          x2 <- old_x2
          y2 <- old_y2
          dir <- old_dir
        }
      }
      p <- p2
      nums <- FALSE
      x <- x2
      y <- y2

    } else {
      if (substr(d$inst, p, p) == "R") dir <- if (dir == 4) 1 else dir + 1
      else dir <- if (dir == 1) 4 else (dir - 1)

      p <- p + 1
      nums <- TRUE
    }
  }
  (1000 * y) + (4 * x) + (dir - 1)
}

part2 <- function(d, tx, ty) {
  part1(d, TRUE, tx, ty)
}

d <- parse("../inputs/input_22.txt")
c(part1(d), part2(d, wes_trans_x, wes_trans_y))
