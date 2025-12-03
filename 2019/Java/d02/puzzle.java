package d02;

import java.io.BufferedReader;
import java.io.FileReader;

import d09.wes_computer;

public class puzzle {
  long[] input;
  wes_computer wc;

  void readInput(String s) throws Exception{
    BufferedReader br = new BufferedReader(new FileReader(s));
    String[] bits = br.readLine().split(",");
    input = new long[bits.length];
    for (int i = 0; i < bits.length; i++) input[i] = Integer.parseInt(bits[i]);
    br.close();
    wc = new wes_computer(input);
  }

  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    W.readInput("../inputs/input_2.txt");

    System.out.println("Part 1: "+W.wc.reset().poke(1,12).poke(2,2).run().peek(0));

    for (int i = 0; i <= 99; i++) {
      for (int j = 0; j <= 99; j++) {
        if (W.wc.reset().poke(1, i).poke(2, j).run().peek(0) == 19690720) {
          System.out.println("Part 2: "+i+" and "+j+" - answer = "+String.valueOf((100 * i) + j));
        }
      }
    }
  }
}
