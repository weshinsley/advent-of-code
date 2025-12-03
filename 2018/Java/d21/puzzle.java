package d21;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;

import tools.WesUtils;

public class puzzle {
  final static ArrayList<String> ops = new ArrayList<String>(Arrays.asList(new String[] {
      "addr", "addi", "mulr", "muli", "banr", "bani", "borr", "bori", "setr", "seti", "gtir", "gtri", "gtrr", "eqir", "eqri", "eqrr"}));
  
  int no_regs = 6;
  int ip_reg = 0;
  int[] regs;
  int[][] program;
    
  void parseInput(ArrayList<String> input) {
    program = new int[input.size() - 1][no_regs];
    int p = 0;
    for (int i = 0; i<input.size(); i++) {
      String[] bits = input.get(i).split("\\s+");
      if (bits[0].equals("#ip")) ip_reg = Integer.parseInt(bits[1]);
      else {
        program[p][0] = ops.indexOf(bits[0]);
        program[p][1] = Integer.parseInt(bits[1]);
        program[p][2] = Integer.parseInt(bits[2]);
        program[p][3] = Integer.parseInt(bits[3]);
        p++;
      }
    }
  }
  
  void exec(int[] reg, int X, int A, int B, int C) {
    switch(X) {
      case 0: reg[C] = reg[A] + reg[B];               break; // ADDR
      case 1: reg[C] = reg[A] + B;                    break; // ADDI
      case 2: reg[C] = reg[A] * reg[B];               break; // MULR
      case 3: reg[C] = reg[A] * B;                    break; // MULI
      case 4: reg[C] = reg[A] & reg[B];               break; // BANR
      case 5: reg[C] = reg[A] & B;                    break; // BANI
      case 6: reg[C] = reg[A] | reg[B];               break; // BORR
      case 7: reg[C] = reg[A] | B;                    break; // BORI
      case 8: reg[C] = reg[A];                        break; // SETR
      case 9: reg[C] = A;                             break; // SETI
      case 10: reg[C] = (A > reg[B])? 1 : 0;          break; // GTIR
      case 11: reg[C] = (reg[A] > B)? 1 : 0;          break; // GTRI
      case 12: reg[C] = (reg[A] > reg[B])? 1 : 0;     break; // GTRR
      case 13: reg[C] = (A == reg[B])? 1 : 0;         break; // EQIR
      case 14: reg[C] = (reg[A] == B)? 1 : 0;         break; // EQRI
      case 15: reg[C] = (reg[A] == reg[B]) ? 1 : 0;          // EQRR
    }
  }

  int advent21a() {
    regs = new int[no_regs];
    while (regs[ip_reg] < program.length) {
      if (regs[ip_reg]==28) {
        System.out.print("Reached Line 28: ");
        System.out.print(ops.get(program[regs[ip_reg]][0]) + " " + program[regs[ip_reg]][1]+" "+program[regs[ip_reg]][2]+" "+program[regs[ip_reg]][3]+" -> ");
        System.out.print("Reg ["+((program[regs[ip_reg]][1]==0)?program[regs[ip_reg]][2]:program[regs[ip_reg]][1])+"] = ");
        if (program[regs[ip_reg]][1]==0) return regs[program[regs[ip_reg]][2]];
        else return regs[program[regs[ip_reg]][1]];
      }
      exec(regs, program[regs[ip_reg]][0], program[regs[ip_reg]][1], program[regs[ip_reg]][2], program[regs[ip_reg]][3]);
      regs[ip_reg] = regs[ip_reg] + 1;
    }
    return -1;
  }
  
  int advent21b() {
    int y=0;
    HashSet<Integer> mem = new HashSet<Integer>();
    regs = new int[no_regs];
    long z=0;
    
    while (regs[ip_reg] < program.length) {
      z++;
      if (regs[ip_reg]==28) {
        int x;
        if (program[regs[ip_reg]][1]==0) x = regs[program[regs[ip_reg]][2]];
        else x = (regs[program[regs[ip_reg]][1]]);
        if (mem.contains(x)) {
          System.out.print(x+" repeated after " + mem.size() + " results, "+z+" instructions" + " - previous val was ");
          return y;
        }
        mem.add(x);
        y=x;
      }
        
      exec(regs, program[regs[ip_reg]][0], program[regs[ip_reg]][1], program[regs[ip_reg]][2], program[regs[ip_reg]][3]);
      regs[ip_reg] = regs[ip_reg] + 1;
    }
    return regs[0];
  }
  
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.parseInput(WesUtils.readLines("../inputs/input_21.txt"));
    System.out.println(w.advent21a());
    long time = -System.currentTimeMillis();
    System.out.println(w.advent21b());
    time += System.currentTimeMillis();
    System.out.println("Part b took "+time+" ms");
  }
}
