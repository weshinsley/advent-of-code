package d19;

import java.util.ArrayList;
import java.util.Arrays;

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
  
  int[] exec(int[] before, int X, int A, int B, int C) {
    int[] result = new int[regs.length];
    for (int i = 0; i < no_regs; i++) result[i] = before[i];
    
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
  
  int advent19a() {
    regs = new int[no_regs];
    while (regs[ip_reg] < program.length) {
      regs = exec(regs, program[regs[ip_reg]][0], program[regs[ip_reg]][1], program[regs[ip_reg]][2], program[regs[ip_reg]][3]);
      regs[ip_reg] = regs[ip_reg] + 1;
    }
    return regs[0];
  }
  
  int advent19b() {
    // I worked this part out on paper; lines 17-25 initialise for (a), and additionally, 27-35 initialise for (b).
    // The result is that a "big number" is put in a register on line 33. Which register it is varies between
    // inputs, so I detect the write destination first.
    //
    // Then the loop on lines 1-15 essentially says, for each (outer loop) number "i" between 1 and the destination inclusive,
    // is there a number "j" such that i*j = the big number? If so, t = t + j.
    //
    // Hence, it is summing all the numbers that divide into big_num, in the range 1..big_num inclusive.
        
    int dest_reg = program[33][3];
    regs = new int[no_regs];
    regs[0] = 1;
    while (regs[ip_reg] !=1) {
      regs = exec(regs, program[regs[ip_reg]][0], program[regs[ip_reg]][1], program[regs[ip_reg]][2], program[regs[ip_reg]][3]);
      regs[ip_reg] = regs[ip_reg] + 1;
    }
    int big_num = regs[dest_reg];
    int j = big_num + 1;
    for (int x = 2; x<(int)(big_num / 2); x++) {
      if ((big_num % x) == 0) j = j + x;
    }
    return j;
  }
  
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.parseInput(WesUtils.readLines("../inputs/input_19.txt"));
    System.out.println(w.advent19a());
    System.out.println(w.advent19b());
  }
}
