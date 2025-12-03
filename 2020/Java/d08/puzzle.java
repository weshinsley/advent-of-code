package d08;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class puzzle {

  static final ArrayList<String> cmds = new ArrayList<String>(Arrays.asList(new String[] { "nop", "acc", "jmp" }));
  static final byte NOP = 0;
  static final byte ACC = 1;
  static final byte JMP = 2;
  static final byte READY = 0;
  static final byte INF_LOOP = 1;
  static final byte FINISHED = 2;

  class Code {
    byte type;
    int arg;

    Code(String line) {
      String[] bits = line.split("\\s+");
      type = (byte) cmds.indexOf(bits[0]);
      arg = Integer.parseInt(bits[1]);
    }

    void flip() {
      type = (byte) ((type != ACC) ? (JMP - type) : ACC);
    }

    void run(Computer c) {
      c.acc += (type == ACC) ? arg : 0;
      c.line += (type == JMP) ? arg : 1;
    }
  }

  class Computer {
    ArrayList<Code> program = new ArrayList<Code>();
    int line = 0;
    int acc = 0;
    byte state = READY;
    Set<Integer> line_history = new HashSet<Integer>();

    void reset() {
      line = 0;
      acc = 0;
      line_history.clear();
      state = READY;
    }

    int run() {
      while (state == READY) {
        if (line_history.contains(line)) {
          state = INF_LOOP;
        } else if (line >= program.size()) {
          state = FINISHED;
        } else {
          line_history.add(line);
          program.get(line).run(this);
        }
      }
      return acc;
    }
  }

  Computer read_input(String f) throws Exception {
    Computer c = new Computer();
    BufferedReader br = new BufferedReader(new FileReader(f));
    String s = br.readLine();
    while (s != null) {
      c.program.add(new Code(s));
      s = br.readLine();
    }
    br.close();
    return c;
  }

  int solve2(Computer wes) {
    for (int i = 0; i < wes.program.size(); i++) {
      wes.reset();
      wes.program.get(i).flip();
      int res = wes.run();
      if (wes.state == FINISHED) {
        return res;
      }
      wes.program.get(i).flip();
    }
    return -1;
  }

  void run() throws Exception {
    Computer w = read_input("../inputs/input_8.txt");
    System.out.println("Advent of Code 2020 - Day 08\n----------------------------");
    System.out.println("Part 1: " + w.run());
    System.out.println("Part 2: " + solve2(w));
  }

  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
