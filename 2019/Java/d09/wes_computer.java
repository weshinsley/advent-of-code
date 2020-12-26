package d09;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayDeque;
import java.util.ArrayList;

public class wes_computer {
  static final int OP_ADD = 1;    // ADD X1 X2 DEST
  static final int OP_MUL = 2;    // MUL X1 X2 DEST
  static final int OP_STORE = 3;  // STORE <input> DEST
  static final int OP_OUTPUT = 4; // PRINT X1
  static final int OP_JTRUE = 5;  // JTRUE V1 V2 : (if V1!=0 GOTO V2)
  static final int OP_JFALSE = 6; // JFALSE V1 V2: (if V1==0 GOTO V2)
  static final int OP_LT = 7;     // (V1 < V2) -> V3 = 1 ELSE V3 = 0
  static final int OP_EQ = 8;     // (V1 == V2) -> V3 = 1 ELSE V3 = 0
  static final int OP_ADJRB = 9;  // Adjust the relative base...
  static final int OP_END = 99;
  static final String[] OP_NAME = new String[] {"_", "ADD   ", "MUL   ", "STORE ", "OUT   ", "JTRUE ", "JFALSE", "LT    ", "EQ    "};

  static final int MODE_POS = 0;
  static final int MODE_IMM = 1;
  static final int MODE_REL = 2;

  static final int MAX_ARGS = 3;

  public static final byte CONTINUE = 1;
  public static final byte WAIT_INPUT = 2;
  public static final byte HALT = 3;

  private int ip;
  private int relative_base;
  private ArrayDeque<Long> input_stream;
  private ArrayDeque<Long> output_buffer;
  private long[] prog0;
  private ArrayList<Long> prog;
  private boolean verbose;
  private byte status;

  public static wes_computer wc_from_input(String s) throws Exception {
    BufferedReader br = new BufferedReader(new FileReader(s));
    String[] bits = br.readLine().split(",");
    long[] input = new long[bits.length];
    for (int i = 0; i < bits.length; i++) input[i] = Long.parseLong(bits[i]);
    br.close();
    return new wes_computer(input);
  }

  public static long[] toLongs(String msg) {
    long[] lmsg = new long[msg.length()];
    for (int i=0; i<msg.length(); i++) {
      if (msg.charAt(i)=='!') lmsg[i]=10;
      else lmsg[i]=(long) msg.charAt(i);
    } return lmsg;
  }

  public static void printch(long lch) {
    char ch = (char) lch;
    if (ch==10) System.out.println();
    else System.out.print(ch);
  }

  public wes_computer(long[] _prog0, long[] input, boolean _verbose) {
    input_stream = new ArrayDeque<Long>();
    output_buffer = new ArrayDeque<Long>();
    prog = new ArrayList<Long>();
    prog0 = new long[_prog0.length];
    for (int i=0; i<_prog0.length; i++) {
      prog.add(_prog0[i]);
      prog0[i] = _prog0[i];
    }
    add_input(input);
    verbose=_verbose;
    ip=0;
    relative_base=0;
    status = CONTINUE;
  }

  public wes_computer(long[] _prog0) {
    this(_prog0, null, false);
  }

  public long peek(long addr) {
    while (addr >= prog.size()) prog.add(0L);
    return prog.get((int)addr);
  }

  public long peek(long addr, int mode) {
    if (mode == MODE_POS) return peek(peek(addr));
    else if (mode == MODE_IMM) return peek(addr);
    else if (mode == MODE_REL) return peek(peek(addr) + relative_base);
    else { System.out.println("Unknown address mode"); return -1;}
  }

  public wes_computer poke(long addr, long val) {
    while (addr >= prog.size()) prog.add(0L);
    prog.set((int)addr, val);
    return this;
  }

  wes_computer poke(long addr, long val, int mode) {
    addr = peek(addr);
    if (mode==MODE_REL) addr += relative_base;
    if (mode==MODE_IMM) System.out.println("Error - immediate mode assign");
    return poke(addr, val);
  }

  public byte get_status() { return status; }

  public wes_computer add_input(long[] input) {
    if (input!=null) for (int i=0; i<input.length; i++) input_stream.addLast(input[i]);
    return this;
  }

  public int input_queue_size() {
    return input_stream.size();
  }

  public wes_computer add_input(String msg) {
    return add_input(toLongs(msg));
  }

  public wes_computer add_input(long i) {
    input_stream.add(i);
    return this;
  }

  public long read_output() {
    return output_buffer.removeFirst();
  }

  public boolean output_available() {
    return output_buffer.size()>0;
  }

  public wes_computer reset(boolean clear_input, boolean clear_output) {
    prog.clear();
    for (int i=0; i<prog0.length; i++) prog.add(prog0[i]);
    ip=0;
    relative_base=0;
    if (clear_input) input_stream.clear();
    if (clear_output) output_buffer.clear();
    status = CONTINUE;
    return this;
  }

  public wes_computer reset() { return reset(true, true); }

  private int process_math4(int _ip, int op, int[] mode, boolean _verbose) {
    if (_verbose) System.out.println(_ip+": "+OP_NAME[op]+"    "+peek(_ip)+"  "+peek(_ip+1)+"  "+peek(_ip+2)+"  "+peek(_ip+3)+"  rb = "+relative_base);
         if (op == OP_ADD) poke(_ip+3, peek(_ip+1, mode[0]) + peek(_ip+2, mode[1]), mode[2]);
    else if (op == OP_MUL) poke(_ip+3, peek(_ip+1, mode[0]) * peek(_ip+2, mode[1]), mode[2]);
    else if (op == OP_LT)  poke(_ip+3, (peek(_ip+1, mode[0]) < peek(_ip+2, mode[1])?1:0), mode[2]);
    else if (op == OP_EQ)  poke(_ip+3, (peek(_ip+1, mode[0]) == peek(_ip+2, mode[1])?1:0), mode[2]);
    return ip+4;
  }

  private int process_jump(int _ip, int op, int[] mode, boolean _verbose) {
    if (_verbose) System.out.println(_ip+": JTRUE  "+peek(_ip)+"  "+peek(_ip+1)+"   "+peek(_ip+2)+"  rb = "+relative_base);
    long val = peek(_ip+1, mode[0]);
    long dest = peek(_ip+2, mode[1]);

    if (op == OP_JTRUE) return (int) ((val != 0) ? dest : _ip+3);
    else /*if (op == OP_JFALSE)*/ return (int) ((val ==0) ? dest : _ip+3);
  }

  public wes_computer run() {
    status = CONTINUE;
    while(status == CONTINUE) status = exec();
    return this;
  }

  byte exec() {
    int[] mode = new int[MAX_ARGS];
    int opcode = prog.get(ip).intValue();
    int op = opcode % 100;
    opcode /= 100;
    for (int j=0; j<MAX_ARGS; j++) {
      mode[j] = opcode % 10;
      opcode /= 10;
    }

    if ((op == OP_ADD) || (op == OP_MUL) || (op == OP_EQ) || (op == OP_LT)) {
      ip = process_math4(ip, op, mode, verbose);

    } else if ((op == OP_JTRUE) || (op == OP_JFALSE)) {
      ip = process_jump(ip, op, mode, verbose);

    } else if (op == OP_STORE) {
      if (verbose) System.out.println(ip+": STORE    "+peek(ip)+"  "+peek(ip+1)+"  input stream = "+input_stream.getFirst()+"  rb = "+relative_base);
      if (input_stream.size() == 0) return WAIT_INPUT;
      long val = input_stream.removeFirst();
      poke(ip + 1, val, mode[0]);
      ip+=2;

    } else if (op == OP_OUTPUT) {
      if (verbose) System.out.println(ip+": OUTPUT    "+peek(ip)+"  "+peek(ip+1)+"  rb = "+relative_base);
      long val = peek(ip+1, mode[0]);
      output_buffer.addLast(val);
      if (verbose) System.out.println("INTO OUTPUT BUFFER: "+val);
      ip+=2;

    } else if (op == OP_ADJRB) {
      if (verbose) System.out.println(ip+": ADJ_RB    "+peek(ip)+"   "+peek(ip+1)+"   old_rb = "+relative_base);
      long val1 = peek(ip+1, mode[0]);
      relative_base += val1;
      ip+=2;

    } else if (op == OP_END) return HALT;

    return CONTINUE;
  }
}
