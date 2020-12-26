package d05;

import d09.wes_computer;

public class wes {
 
  long run(wes_computer wc, long input) {
    wc.add_input(input).run();
    String s = "";
    while (wc.output_available()) s += wc.read_output();
    return Long.parseLong(s);
  }
  
  void expect_equal(long[] prog, long input, long expected_out, int test_no) {
    if (run(new wes_computer(prog), input) != expected_out) 
      System.out.println("Test failure, line "+test_no);
  }
  
  void test() {
    expect_equal(new long[] {3,9,8,9,10,9,4,9,99,-1,8}, 7, 0, 1);
    expect_equal(new long[] {3,9,8,9,10,9,4,9,99,-1,8}, 8, 1, 2);
    expect_equal(new long[] {3,9,8,9,10,9,4,9,99,-1,8}, 9, 0, 3);
    expect_equal(new long[] {3,9,7,9,10,9,4,9,99,-1,8}, 7, 1, 4);
    expect_equal(new long[] {3,9,7,9,10,9,4,9,99,-1,8}, 8, 0, 5);
    expect_equal(new long[] {3,9,7,9,10,9,4,9,99,-1,8}, 9, 0, 6);
    expect_equal(new long[] {3,3,1108,-1,8,3,4,3,99}, 7, 0, 7);
    expect_equal(new long[] {3,3,1108,-1,8,3,4,3,99}, 8, 1, 8);
    expect_equal(new long[] {3,3,1108,-1,8,3,4,3,99}, 9, 0, 9);
    expect_equal(new long[] {3,3,1107,-1,8,3,4,3,99}, 7, 1, 10);
    expect_equal(new long[] {3,3,1107,-1,8,3,4,3,99}, 8, 0, 11);
    expect_equal(new long[] {3,3,1107,-1,8,3,4,3,99}, 9, 0, 12);
    expect_equal(new long[] {3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9}, 0, 0, 13);
    expect_equal(new long[] {3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9}, 1, 1, 14);
    expect_equal(new long[] {3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9}, 2, 1, 15);
    expect_equal(new long[] {3,3,1105,-1,9,1101,0,0,12,4,12,99,1}, 0, 0, 16);
    expect_equal(new long[] {3,3,1105,-1,9,1101,0,0,12,4,12,99,1}, 1, 1, 17);
    expect_equal(new long[] {3,3,1105,-1,9,1101,0,0,12,4,12,99,1}, 2, 1, 18);
    
    long[] prog = new long[] {3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,
                              0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,
                              4,20,1105,1,46,98,99};
    
    expect_equal(prog, 7, 999, 19);
    expect_equal(prog, 8, 1000, 20);
    expect_equal(prog, 9, 1001, 21);
    
  }
  public static void main(String[] args) throws Exception {
    wes W = new wes();
    W.test();
    System.out.println("Part 1: "+W.run(wes_computer.wc_from_input("d05/wes-input.txt"), 1));
    System.out.println("Part 2: "+W.run(wes_computer.wc_from_input("d05/wes-input.txt"), 5));

  }
}
