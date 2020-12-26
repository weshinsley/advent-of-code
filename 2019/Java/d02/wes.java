package d02;

import java.io.BufferedReader;
import java.io.FileReader;

import d09.wes_computer;

public class wes {
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

  void expect_result(long[] in, int[] out, int n) {
    wes_computer test = new wes_computer(in);
    test.run();
    boolean pass=true;
    for (int i=0; i<out.length; i++) {
      if (out[i] != test.peek(i)) {
        pass = false;
        break;
      }
    }

    if (!pass) System.out.println("Test "+n+" failed");
  }

  void test() {
    expect_result(new long[] {1,9,10,3,2,3,11,0,99,30,40,50}, new int[] {3500,9,10,70,2,3,11,0,99,30,40,50},1);
    expect_result(new long[] {1,0,0,0,99}, new int[] {2,0,0,0,99},2);
    expect_result(new long[] {2,3,0,3,99}, new int[] {2,3,0,6,99},3);
    expect_result(new long[] {2,4,4,5,99,0}, new int[] {2,4,4,5,99,9801},4);
    expect_result(new long[] {1,1,1,4,99,5,6,0,99}, new int[] {30,1,1,4,2,5,6,0,99},5);
  }


  public static void main(String[] args) throws Exception {
    wes W = new wes();
    W.test();
    W.readInput("d02/wes-input.txt");

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
