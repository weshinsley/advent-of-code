package d16;

import java.util.ArrayList;

import tools.WesUtils;

public class puzzle {
  
  int[] exec(int[] before, int X, int A, int B, int C) {
    int[] result = new int[4];
    for (int i=0; i<4; i++) result[i]=before[i];
    
         if (X == 0) result[C] = before[A] + before[B];                 // ADDR
    else if (X == 1) result[C] = before[A] + B;                         // ADDI
    else if (X == 2) result[C] = before[A] * before[B];                 // MULR
    else if (X == 3) result[C] = before[A] * B;                         // MULI
    else if (X == 4) result[C] = before[A] & before[B];                 // BANR
    else if (X == 5) result[C] = before[A] & B;                         // BANI
    else if (X == 6) result[C] = before[A] | before[B];                 // BORR
    else if (X == 7) result[C] = before[A] | B;                         // BORI
    else if (X == 8) result[C] = before[A];                             // SETR
    else if (X == 9) result[C] = A;                                     // SETI
    else if (X == 10) result[C] = (A > before[B])? 1 : 0;               // GTIR
    else if (X == 11) result[C] = (before[A] > B)? 1 : 0;               // GTRI
    else if (X == 12) result[C] = (before[A] > before[B])? 1 : 0;       // GTRR
    else if (X == 13) result[C] = (A == before[B])? 1 : 0;              // EQIR
    else if (X == 14) result[C] = (before[A] == B)? 1 : 0;              // EQRI
    else if (X == 15) result[C] = (before[A] == before[B]) ? 1 : 0;     // EQRR
    return result;
  }
  
  ArrayList<int[]> before = new ArrayList<int[]>();
  ArrayList<int[]> after = new ArrayList<int[]>();
  ArrayList<int[]> code = new ArrayList<int[]>();
  ArrayList<int[]> program = new ArrayList<int[]>();
  
  void parseInput(ArrayList<String> input) {
    int i=0;
    String s = input.get(i);
    while (s.startsWith("Before: [")) {
      int[] b = new int[4];
      int[] c = new int[4];
      int[] r = new int[4];
      String[] bits = s.substring(9, s.indexOf("]")).split(",\\s*");
      for (int j=0; j<bits.length; j++) b[j] = Integer.parseInt(bits[j]);
      s = input.get(++i);
      
      bits = s.split("\\s+");
      for (int j=0; j<bits.length; j++) c[j] = Integer.parseInt(bits[j]);
      s = input.get(++i);
      
      bits = s.substring(9, s.indexOf("]")).split(",\\s*");
      for (int j=0; j<bits.length; j++) r[j] = Integer.parseInt(bits[j]);
      i+=2;
      s = input.get(i);
      before.add(b);
      after.add(r);
      code.add(c);
    }
    i+=2;
    while (i<input.size()) {
      s = input.get(i);
      String[] bits = s.split("\\s+");
      int[] line = new int[4];
      for (int j=0; j<bits.length; j++) line[j] = Integer.parseInt(bits[j]);
      program.add(line);
      i++;
    }
  }
  
  int advent16a() {
    int samples = 0;
    for (int i=0; i<before.size(); i++) {
      int[] c = code.get(i);
      int[] r = after.get(i);
      int success = 0;
      for (int test=0; test<=15; test++) {
        int[] r2= exec(before.get(i), test, c[1], c[2], c[3]);
        if ((r[0] == r2[0]) && (r[1] == r2[1]) && (r[2] == r2[2]) && (r[3]== r2[3])) success++;
      }
      if (success >= 3) samples++;
    }
    return samples;
  }
  
  int advent16b() {
    int[] code_translate = new int[16];
    for (int i=0; i<16; i++) code_translate[i] = -1;
    
    ArrayList<ArrayList<Integer>> options = new ArrayList<ArrayList<Integer>>();
    for (int i=0; i<=15; i++) {
      ArrayList<Integer> list = new ArrayList<Integer>();
      for (int j=0; j<=15; j++) list.add(j);
      options.add(list);
    }
    int unknown=16;
    while (unknown>0) {  
      for (int i=0; i<=15; i++) {
        ArrayList<Integer> opts = options.get(i);
        if (opts.size()>=1) {
          for (int j=0; j<before.size(); j++) {
            int[] c = code.get(j);
            if (c[0]==i) {
              int[] r = after.get(j);
              int op=0;
              while (op < opts.size()) {
                int[] r2 = exec(before.get(j), opts.get(op), c[1], c[2], c[3]);
                if ((r[0] != r2[0]) || (r[1] != r2[1]) || (r[2] != r2[2]) || (r[3] != r2[3])) opts.remove(op);
                else op++;
              }
              if (opts.size()==1) {
                code_translate[i] = opts.get(0);
                for (int k=0; k<=15; k++) {
                  if ((i!=k) && (options.get(k).indexOf(code_translate[i])>=0)) {
                    options.get(k).remove(Integer.valueOf(code_translate[i]));
                  }
                }
                unknown--;
                opts.clear();
              }
              break;
            }
          }
        }
      }
    }
    
    int[] regs = new int[4];
    for (int i=0; i<program.size(); i++) {
      int[] line = program.get(i);
      regs = exec(regs, code_translate[line[0]], line[1], line[2], line[3]);
    }
    return regs[0];
  }

  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.parseInput(WesUtils.readLines("../inputs/input_16.txt"));
    System.out.println(w.advent16a());
    System.out.println(w.advent16b());
  }
}
