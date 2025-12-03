package d23;

import java.util.ArrayList;
import java.util.HashMap;

import tools.Utils;

public class puzzle {
  static byte JNZ = 1;
  static byte MUL = 2;
  static byte SET = 3;
  static byte SUB = 4;
  String[] names = new String[] {"", "JNZ", "MUL", "SET", "SUB"};

  class RegOrNum {
    char reg;
    long num;
    boolean is_reg;

    RegOrNum(String s, HashMap<Character, Long> regs) {
      try {
        num = Long.parseLong(s);
        is_reg = false;
      } catch (NumberFormatException e) {
        reg = s.charAt(0);
        if (!regs.containsKey(reg)) regs.put(reg,  0L);
        is_reg = true;
      }
    }

    long get(HashMap<Character, Long> regs) {
      if (is_reg) return regs.get(reg);
      else return num;
    }

    void set(long num, HashMap<Character, Long> regs) {
      regs.put(reg, num);
    }

    String print(HashMap<Character, Long> regs) {
      if (is_reg) return String.valueOf(reg)+"="+regs.get(reg);
      else return String.valueOf(num);
    }
  }

  class Computer {
    HashMap<Character, Long> regs = new HashMap<Character, Long>();
    int pc = 0;
    int count_mul = 0;
    int[] line_instrs;
    RegOrNum[] line_arg1;
    RegOrNum[] line_arg2;

    void add(int instr, String arg1, String arg2, int line) {
      line_instrs[line] = instr;
      line_arg1[line] = new RegOrNum(arg1, regs);
      line_arg2[line] = new RegOrNum(arg2, regs);
    }

    Computer(ArrayList<String> input) {
      line_instrs = new int[input.size()];
      line_arg1 = new RegOrNum[input.size()];
      line_arg2 = new RegOrNum[input.size()];
      count_mul = 0;
      for (int i=0; i<input.size(); i++) {
        String[] s = input.get(i).split("\\s+");
        if (s[0].equals("jnz")) add(JNZ, s[1], s[2], i);
        else if (s[0].equals("mul")) add(MUL, s[1], s[2], i);
        else if (s[0].equals("set")) add(SET, s[1], s[2], i);
        else if (s[0].equals("sub")) add(SUB, s[1], s[2], i);
        else System.out.println("ERROR!");
      }
    }

    int execute(int line) {
      //System.out.println(line+". "+names[line_instrs[line]]+" "+line_arg1[line].print(regs)+" "+line_arg2[line].print(regs));

      if (line_instrs[line] == MUL) {
        count_mul++;
        line_arg1[line].set(line_arg1[line].get(regs) * line_arg2[line++].get(regs), regs);
      } else if (line_instrs[line] == SET) {
        line_arg1[line].set(line_arg2[line++].get(regs), regs);
      } else if (line_instrs[line] == SUB) {
        line_arg1[line].set(line_arg1[line].get(regs) - line_arg2[line++].get(regs), regs);
      } else if (line_instrs[line] == JNZ) {
        if (line_arg1[line++].get(regs) != 0) line += (line_arg2[line-1].get(regs) - 1);
      } else System.out.println("ERROR!");
      return line;
    }
  }
  

  long solve(ArrayList<String> input, boolean part2) {
    Computer c = new Computer(input);
    if (part2) {
      c.regs.put('a',  1L);
    }
    while (c.pc < c.line_instrs.length) c.pc = c.execute(c.pc);
    if (!part2) return c.count_mul;
    else return c.regs.get('h');
  }
  
  long part2() {
    // See R code! Hardcoded for my input
    int h=0;
    for (int x=105700; x<122701; x+=17) {
      for (int i=2; i<x; i++) {
        if (x % i == 0) {
          h++;
          break;
        }
      }
    }
    return h;
  }
   
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    ArrayList<String> input = Utils.readLines("../inputs/input_23.txt");
    System.out.println(w.solve(input, false));
    System.out.println(w.part2());
  }
}
