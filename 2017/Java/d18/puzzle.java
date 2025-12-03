package d18;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.HashMap;

import tools.Utils;

public class puzzle {
  static byte ADD = 1;
  static byte JGZ = 2;
  static byte MOD = 3;
  static byte MUL = 4;
  static byte RCV = 5;
  static byte SET = 6;
  static byte SND = 7;
  String[] names = new String[] {"", "ADD", "JGZ", "MOD", "MUL", "RCV", "SET", "SND"};

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
    int blocked = 0;
    long result;
    int[] line_instrs;
    long last_sound = 0;
    long sends = 0;
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
      result = Integer.MIN_VALUE;
      for (int i=0; i<input.size(); i++) {
        String[] s = input.get(i).split("\\s+");
        if (s[0].equals("add")) add(ADD, s[1], s[2], i);
        else if (s[0].equals("mul")) add(MUL, s[1], s[2], i);
        else if (s[0].equals("mod")) add(MOD, s[1], s[2], i);
        else if (s[0].equals("jgz")) add(JGZ, s[1], s[2], i);
        else if (s[0].equals("snd")) add(SND, s[1], "0", i);
        else if (s[0].equals("set")) add(SET, s[1], s[2], i);
        else if (s[0].equals("rcv")) add(RCV, s[1], "0", i);
        else System.out.println("ERROR!");
      }
    }

    int execute(int line, ArrayDeque<Long> outgoing, ArrayDeque<Long> incoming) {
      //System.out.println(line+". "+names[line_instrs[line]]+" "+line_arg1[line].print(regs)+" "+line_arg2[line].print(regs));

      if (line_instrs[line] == ADD) {
        line_arg1[line].set(line_arg1[line].get(regs) + line_arg2[line++].get(regs), regs);
      } else if (line_instrs[line] == MUL) {
        line_arg1[line].set(line_arg1[line].get(regs) * line_arg2[line++].get(regs), regs);
      } else if (line_instrs[line] == MOD) {
        line_arg1[line].set(line_arg1[line].get(regs) % line_arg2[line++].get(regs), regs);
      } else if (line_instrs[line] == SET) {
        line_arg1[line].set(line_arg2[line++].get(regs), regs);
      } else if (line_instrs[line] == JGZ) {
        if (line_arg1[line++].get(regs) > 0) line += (line_arg2[line-1].get(regs) - 1);
      } else if (line_instrs[line] == SND) {
        if (outgoing == null) {
          last_sound = line_arg1[line++].get(regs);
        } else {
          outgoing.add(line_arg1[line++].get(regs));
          sends++;
        }

      } else if (line_instrs[line] == RCV) {
        if (incoming == null) {
          if (line_arg1[line++].get(regs) != 0) {
            result = last_sound;
          }
        } else {
          if (incoming.size() == 0) {
            blocked++;
          } else {
            blocked = 0;
            long val = incoming.pop();
            line_arg1[line++].set(val, regs);
          }
        }
      } else System.out.println("ERROR!");
      return line;
    }

    long run(ArrayDeque<Long> outgoing, ArrayDeque<Long> incoming) {
      if (outgoing == null) {
        while (result == Integer.MIN_VALUE) pc = execute(pc, null, null);
        return result;
      } else {
        do {
          pc = execute(pc, outgoing, incoming);
        } while (blocked == 0);
        return 0;
      }
    }

  }

  long part1(ArrayList<String> input) {
    Computer c = new Computer(input);
    return c.run(null, null);
  }

  long part2(ArrayList<String> input) {
    Computer c0 = new Computer(input);
    c0.regs.put('p', 0L);
    Computer c1 = new Computer(input);
    c1.regs.put('p', 1L);
    ArrayDeque<Long> q0to1 = new ArrayDeque<Long>();
    ArrayDeque<Long> q1to0 = new ArrayDeque<Long>();
    do {
      c0.run(q0to1, q1to0);
      c1.run(q1to0, q0to1);
    } while ((c0.blocked < 2) && (c1.blocked < 2));
    return c1.sends;
  }

  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    ArrayList<String> input = Utils.readLines("../inputs/input_18.txt");
    System.out.println(w.part1(input));
    System.out.println(w.part2(input));
  }
}
