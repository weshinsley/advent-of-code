test <- function(x,y) { if (x==y) "PASS" else "FAIL" }

numericable <- function(s) {
  (!is.na(suppressWarnings(as.numeric(s))))
}

get_val <- function(var, reg_values, reg_names) {
  x <- 0
  if (numericable(var)) {
    x <- as.numeric(var)
  } else {
    x <- reg_values[reg_names == var]
  }
  x
}

execute_maths <- function(reg_names, reg_values, line, line_no) {
  x <- get_val(line[2], reg_values, reg_names)
  y <- get_val(line[3], reg_values, reg_names)
  if (line[1] == 'set') {
    reg_values[reg_names == line[2]] <- y
  } else if (line[1] == 'add') {
    reg_values[reg_names == line[2]] <- x + y
  } else if (line[1] == 'mul') {
    reg_values[reg_names == line[2]] <- x * y
  } else if (line[1] == 'mod') {
    reg_values[reg_names == line[2]] <- x %% y
  } else if ((line[1] == 'jgz') && ( x > 0)) {
    line_no <- (line_no + y) - 1
  }

  c(line_no, reg_values)
}

init_regs <- function(code) {
  reg_names <- NULL
  for (line in code) {
    line <- unlist(strsplit(line," "))

    if (!numericable(line[2])) {
      if (!(line[2] %in% reg_names)) {
        reg_names <- c(reg_names, line[2])
      }
    }
    if (!numericable(line[3])) {
      if (!(line[3] %in% reg_names)) {
        reg_names <- c(reg_names, line[3])
      }
    }
  }
  sort(reg_names)
}

advent18a <- function(code) {
  last_sound <- 0
  reg_names <- init_regs(code)
  reg_values <- rep(0, length(reg_names))
  line_no <- 1

  while ((line_no>=1) && (line_no<=length(code))) {
    line <- unlist(strsplit(code[line_no]," "))
    if (line[1] %in% c('snd','rcv')) {

      x <- get_val(line[2], reg_values, reg_names)

      if (line[1] == 'snd') {
        last_sound <- x

      } else if ((line[1] == 'rcv') && (x!=0)) {
        line_no <- -999
      }

    } else {
      res <- execute_maths(reg_names, reg_values, line, line_no)
      line_no <- res[1]
      reg_values <- res[2:length(res)]
    }
    line_no <- line_no + 1
  }
  last_sound
}

advent18b <- function(code) {
  reg_names <- init_regs(code)
  reg_values <- list(rep(0, length(reg_names)), rep(0, length(reg_names)))
  reg_values[[1]][which(reg_names=="p")] <- 0
  reg_values[[2]][which(reg_names=="p")] <- 1
  msg_queues <- list(NULL,NULL)
  line_no <- c(1,1)
  deadlock <- c(FALSE, FALSE)
  terminated <- c(FALSE, FALSE)
  instance <- 1
  snd_counter <- c(0, 0)

  while ((sum(deadlock)<2) && (sum(terminated)<2)) {
    if ((line_no[instance]<1) || (line_no[instance]>length(code))) {
      terminated[instance] <- TRUE
    }

    if (!terminated[instance]) {
      line <- unlist(strsplit(code[line_no[instance]]," "))

      if (line[1] %in% c('snd','rcv')) {
        x <- get_val(line[2], reg_values[[instance]], reg_names)

        if (line[1] == 'snd') {
          msg_queues[[3-instance]] <- c(msg_queues[[3-instance]],x)
          snd_counter[instance] <- snd_counter[instance] + 1

        } else if (line[1] == 'rcv') {
          lgth <- length(msg_queues[[instance]])
          if (lgth>=1) {
            deadlock[instance] <- FALSE
            reg_values[[instance]][reg_names == line[2]] <- msg_queues[[instance]][1]
            if (lgth == 1) {
              msg_queues[instance] <- list(NULL)
            } else {
              msg_queues[[instance]] <- msg_queues[[instance]][2:lgth]
            }
          } else {
            line_no[instance] <- line_no[instance] - 1
            deadlock[instance] <- TRUE
          }
        }

      } else {
        res <- execute_maths(reg_names, reg_values[[instance]], line, line_no[instance])
        line_no[instance] <- res[1]
        reg_values[[instance]] <- res[2:length(res)]
      }
      line_no[instance] <- line_no[instance] + 1
    }
    if (!terminated[3-instance]) {
      instance <- (3 - instance)
    }
  }
  snd_counter[2]
}

code <- readLines("../inputs/input_18.txt")
c(advent18a(code), advent18b(code))
