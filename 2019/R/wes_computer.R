library(R6)

ZVec <- R6Class(
  classname = "ZVec",
  private = list(
    mainvec = NULL,
    zeroelement = NULL
  ),
  
  public = list(
    initialize = function(content) {
      private$zeroelement <- content[1]
      private$mainvec <- content[2:length(content)]
    },
    
    print = function(...) {
      print(c(private$zeroelement, private$mainvec))
      invisible(self)
    },
    
    copy = function() {
      ZVec$new(c(private$zeroelement, private$mainvec))
    },
    
    at = function(x) {
      if (x == 0) {
        return(private$zeroelement)
      } else {
        return(private$mainvec[x])
      }
    },
    
    set = function(addr, val) {
      self$ensure_space(addr)
      if (addr == 0) {
        private$zeroelement <- val
      } else {
        private$mainvec[addr] <- val
      }
    },
    
    size = function() {
      length(private$zeroelement) + length(private$mainvec)
    },
    
    ensure_space = function(len) {
      extra <- 1 + (len - self$size())
      if (extra > 0) {
        private$mainvec <- c(private$mainvec, rep(0, extra))
      }
      invisible(self)
    }
  )
)

IntComputer <- R6Class(
  classname = "IntComputer", 
  
  private = list(
    ip = 0L,
    relative_base = 0L,
    input_stream = NULL,
    output_buffer = NULL,
    program = NULL,
    backup_program = NULL,
    status = 0L,
    
    OP_ADD    = 1L,   # ADD X1 X2 DEST
    OP_MUL    = 2L,   # MUL X1 X2 DEST
    OP_STORE  = 3L,   # STORE <input> DEST
    OP_OUTPUT = 4L,   # PRINT X1 to <output>
    OP_JTRUE  = 5L,   # JTRUE V1 V2 : (if V1!=0 GOTO V2)
    OP_JFALSE = 6L,   # JFALSE V1 V2: (if V1==0 GOTO V2)
    OP_LT     = 7L,   # (V1 < V2) -> V3 = 1 ELSE V3 = 0
    OP_EQ     = 8L,   # (V1 == V2) -> V3 = 1 ELSE V3 = 0
    OP_ADJRB  = 9L,   # Adjust the relative base...
    OP_END    = 99L,
    OP_NAME   = c("ADD", "MUL", "STO", "OUT", "JT", "JF", "LT", "EQ", "ARB"),
    
    MODE_POS = 0L,
    MODE_IMM = 1L,
    MODE_REL = 2L,
    
    peek2 = function(addr) {
      private$program$ensure_space(addr)
      return(private$program$at(addr))
    },
    
    poke2 = function(addr, value) {
      if (is.na(value)) message("POKE NA")
      private$program$set(addr, value)
      invisible(self)
    },
    
    process_math4 = function(ip, op, mode, verbose=FASLE) {
      thing1 <- self$peek(ip + 1, mode[1])
      thing2 <- self$peek(ip + 2, mode[2])
      dest <- ip + 3
      
      if (verbose)
        message(sprintf("%d:\t%s\t%d\t%d\t%d\t%d\tmode = %d%d%d\trb = %d",
                        private$ip, private$OP_NAME[op], 
                        self$peek(private$ip), self$peek(private$ip + 1), self$peek(private$ip + 2),
                        self$peek(private$ip + 3), mode[1], mode[2], mode[3],
                        private$relative_base)) 
      
           if (op == private$OP_ADD)  self$poke(dest, thing1 + thing2, mode[3])
      else if (op == private$OP_MUL)  self$poke(dest, thing1 * thing2, mode[3])
      else if (op == private$OP_LT)   self$poke(dest, as.numeric(thing1 < thing2), mode[3])
      else if (op == private$OP_EQ)   self$poke(dest, as.numeric(thing1 == thing2), mode[3])
      
      ip + 4 
    },
    
    process_jump = function(ip, op, mode, verbose = FALSE) {
      if (verbose) 
        message(sprintf("%d:\t%s\t%d\t%d\t%d\t\tmode = %d%d\trb = %d",
                        ip, private$OP_NAME[op], self$peek(ip), self$peek(ip+1),
                        self$peek(ip+2), mode[1], mode[2], 
                        private$relative_base))
      val <- self$peek(private$ip + 1, mode[1])
      dest <- self$peek(private$ip + 2, mode[2])
   
      if (op == private$OP_JTRUE) { 
        if (val !=0) return(dest)
        else return(private$ip + 3)
      
      } else if (op == private$OP_JFALSE) {
        if (val == 0) return(dest)
        else return(private$ip + 3)
      }
      
      dest
    },
    
    exec = function(verbose) {
      mode <- c(0,0,0)
      opcode <- as.numeric(private$program$at(private$ip))
      op <- opcode %% 100
      opcode <- as.integer(opcode / 100)
      mode[1] <- opcode %% 10
      opcode <- as.integer(opcode / 10)
      mode[2] <- opcode %% 10
      opcode <- as.integer(opcode / 10)
      mode[3] <- opcode %% 10

      if (op %in% c(private$OP_ADD, private$OP_MUL,
                    private$OP_EQ,  private$OP_LT)) {
        private$ip <- private$process_math4(private$ip, op, mode, verbose)
      
      } else if (op %in% c(private$OP_JTRUE, private$OP_JFALSE)) {
        private$ip <- private$process_jump(private$ip, op, mode, verbose)
      
      } else if (op == private$OP_STORE) {
        if (verbose)
          message(sprintf("%d:\t%s\t%d\t%d\t\t\tmode = %d\trb = %d",
                          private$ip, private$OP_NAME[op], 
                          self$peek(private$ip), self$peek(private$ip + 1), mode[1], 
                          private$relative_base)) 
        if (length(private$input_stream) == 0) {
          return(self$WAIT_INPUT)
        }
        
        val <- private$input_stream[1]
        private$input_stream <- private$input_stream[-1]
        self$poke(private$ip + 1, val, mode[1])
        private$ip <- private$ip + 2
      
      } else if (op == private$OP_OUTPUT) {
        if (verbose)
          message(sprintf("%d:\t%s\t%d\t%d\t\t\tmode = %d\trb = %d",
                          private$ip, private$OP_NAME[op], 
                          self$peek(private$ip), self$peek(private$ip+1), 
                          mode[1], private$relative_base)) 
        val <- self$peek(private$ip + 1, mode[1])
        private$output_buffer <- c(private$output_buffer, val)
        private$ip <- private$ip + 2
        
      } else if (op == private$OP_ADJRB) {
        if (verbose)
          message(sprintf("%d:\t%s\t%d\t%d\tmode = %d\trb = %d",
                          private$ip, private$OP_NAME[op], 
                          self$peek(private$ip), self$peek(private$ip + 1), 
                          mode[1], private$relative_base)) 
        
        val <- self$peek(private$ip + 1, mode[1])
        private$relative_base <- private$relative_base + val
        private$ip <- private$ip + 2
      
      } else if (op == private$OP_END) {
        if (verbose)
          message(sprintf("%d:\tHALT\t%d", private$ip, op))
        return(self$HALT)
      }
      self$CONTINUE
    }

  ),

  public = list(
    CONTINUE = 1L,
    WAIT_INPUT = 2L,
    HALT = 3L,
    
    initialize = function(file = NULL, program = NULL) {
      if ((is.null(file) + is.null(program)) != 1) {
        stop("Either file, or program must be non-null");
      }
      if (!is.null(file))
        private$program <- ZVec$new(as.numeric(unlist(strsplit(readLines(file), ","))))
      else 
        private$program <- ZVec$new(program)
      private$backup_program <- private$program$copy()
      self$reset()
      invisible(self)
    },
    
    peek = function(address, mode = private$MODE_IMM) {
      if (mode == private$MODE_POS) return(private$peek2(private$peek2(address)))
      else if (mode == private$MODE_IMM) return(private$peek2(address))
      else if (mode == private$MODE_REL) return(private$peek2(private$peek2(address) + 
                                                              private$relative_base))
    },
  
    poke = function(address, value, mode = NULL) {
      if (!is.null(mode)) {
        address <- private$peek2(address) 
        if (mode == private$MODE_REL) address <- address + private$relative_base
      }
      return(private$poke2(address, value))
    },

    get_status = function() {
      private$status
    },
    
    add_input = function(num) {
      private$input_stream <- c(private$input_stream, num)
      invisible(self)
    },
    
    input_size = function() {
      length(private$input_stream)
    },
    
    read_output = function() {
      val <- private$output_buffer[1]
      private$output_buffer <- private$output_buffer[-1]
      val
    },
    
    output_available = function() {
      length(private$output_buffer) > 0
    },
    
    reset = function(clear_input = TRUE, clear_output = TRUE) {
      private$program <- private$backup_program$copy()
      private$ip <- 0
      private$relative_base <- 0
      if (clear_input) private$input_stream <- NULL
      if (clear_output) private$output_buffer <- NULL
      private$status <- self$CONTINUE
      invisible(self)
    },
    
    run = function(verbose = FALSE) {
      private$status = self$CONTINUE
      while (self$get_status() == self$CONTINUE) {
        private$status <- private$exec(verbose)
      }
      invisible(self)
    },
    
    dump = function() {
      print(private$program)
    }
  )
)
