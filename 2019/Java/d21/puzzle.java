package d21;

import d09.wes_computer;

public class puzzle {
  wes_computer wc = null;

  long solve(boolean part1) {
    wc.reset();
    wc.run();
    while (wc.output_available()) { wc.read_output(); }

    // Part 1: if a hole is in any of A,B,C, then jump if position D is safe..
    // Part 2: additionally, E must be ground, since we'll land at D,
    //         and H must be ground, so I can walk forward once at D and then jump.
    //         The rest I think degrades into Part 1 again.

    wc.add_input("NOT C J\nNOT B T\nOR T J\nNOT A T\nOR T J\nAND D J\n"+
        ((part1)?"WALK\n":
                 "OR E T\nOR H T\nAND T J\nRUN\n"));
    wc.run();
    for (int i=0; i<13; i++) wc.read_output();
    return wc.read_output();
  }

  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    W.wc = wes_computer.wc_from_input("../inputs/input_21.txt");
    System.out.println("Part 1: "+W.solve(true));
    System.out.println("Part 2: "+W.solve(false));
  }
}