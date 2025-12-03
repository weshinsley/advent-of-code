package d05;

import d09.wes_computer;

public class puzzle {
 
  long run(wes_computer wc, long input) {
    wc.add_input(input).run();
    String s = "";
    while (wc.output_available()) s += wc.read_output();
    return Long.parseLong(s);
  }

  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    System.out.println("Part 1: "+W.run(wes_computer.wc_from_input("../inputs/input_5.txt"), 1));
    System.out.println("Part 2: "+W.run(wes_computer.wc_from_input("../inputs/input_5.txt"), 5));

  }
}
