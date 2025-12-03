package d25;

import d09.wes_computer;

public class puzzle {
  void solve(wes_computer wc) {
    while (true) {
      wc.run();
      while (wc.output_available()) wes_computer.printch(wc.read_output());
      String command = System.console().readLine("-->");
      if (command.equals("quit")) break;
      else if (command.equals("restart")) wc.reset();
      else {
        command += ((char)10);
        wc.add_input(wes_computer.toLongs(command));
      }
    }
  }

  public static void main(String[] args) throws Exception {
    System.out.println("Day 25 - The Last Int Computer.");
    System.out.println("-------------------------------");
    System.out.println("Extra commands for convenience:");
    System.out.println("  quit");
    System.out.println("  restart");
    puzzle W = new puzzle();
    W.solve(wes_computer.wc_from_input("../inputs/input_25.txt"));

  }
}
