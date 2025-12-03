package d09;

public class puzzle {
  
  String run(String f, long[] prog, long[] input) throws Exception {
    wes_computer wc;
    if (f!=null) wc = wes_computer.wc_from_input(f).add_input(input);
    else wc = new wes_computer(prog, input, false);
    wc.run();
    StringBuilder res = new StringBuilder();
    while (wc.output_available()) res.append(wc.read_output()+",");
    return res.toString();
  }
  
  String run(long[] prog) throws Exception { return run(null, prog, null); }
  
  void test() throws Exception {
    if (!run(new long[] {109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99}).equals("109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99,")) System.out.println("Test 1.1 fails");
    if (!run(new long[] {1102,34915192L,34915192L,7,4,7,99,0}).equals("1219070632396864,")) System.out.println("Test 1.2 fails");
    if (!run(new long[] {104,1125899906842624L,99}).equals("1125899906842624,")) System.out.println("Test 1.3 fails");
  }
  
  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    W.test();
    System.out.println("Part 1 : "+W.run("../inputs/input_9.txt", null, new long[] {1}));
    System.out.println("Part 2 : "+W.run("../inputs/input_9.txt", null, new long[] {2}));
    
  }
}
