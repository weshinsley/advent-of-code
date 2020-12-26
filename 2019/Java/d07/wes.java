package d07;

import d09.wes_computer;

public class wes {
  static long[][] phases;

  wes_computer[] amps = new wes_computer[5];

  long part1() {
    long max=0;
    for (int p=0; p<phases.length; p++) {
      long signal = 0;
      for (int a=0; a<=4; a++) {
        amps[a].reset(true,true);
        amps[a].add_input(new long[] {phases[p][a], signal});
        amps[a].run();
        signal = amps[a].read_output();
      }
      max = Math.max(max, signal);
    }
    return max;
  }

  long part2() {
    long max = 0;
    for (int p = 0; p < phases.length; p++) {
      for (int x = 0; x < 5; x++) {
        amps[x].reset(true,  true);
        amps[x].add_input(phases[p][x] + 5);
      }
      long signal = 0;
      while (amps[4].get_status() != wes_computer.HALT) {
        for (int x = 0; x < 5; x++) {
          amps[x].add_input(signal);
          amps[x].run();
          signal = amps[x].read_output();
        }
      }
      max = Math.max(max, signal);
    }
    return max;
  }

  // This function looks like a bit like half a spaceship.

  static void permute() {
    phases = new long[120][5];
    int p=0;
    for (int a=0; a<5; a++)
      for (int b=0; b<5; b++)
        if (a!=b) for (int c=0; c<5; c++)
          if ((a!=c) && (b!=c))
            for (int d=0; d<5; d++)
              if ((a!=d) && (b!=d) && (c!=d))
                for (int e=0; e<5; e++)
                  if ((a!=e) && (b!=e) && (c!=e) && (d!=e))
                    phases[p++] = new long[] {a,b,c,d,e};
  }

  long testpart(int part, long[] prog) {
    for (int i=0; i<5; i++) amps[i] = new wes_computer(prog);
    return (part==1)?part1():part2();
  }

  void test() throws Exception {
    if (testpart(1, new long[] {3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0}) != 43210) System.out.println("Test 1.1 failed");
    if (testpart(1, new long[] {3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0}) != 54321) System.out.println("Test 1.2 failed");
    if (testpart(1, new long[] {3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0}) != 65210) System.out.println("Test 1.3 failed");
    if (testpart(2, new long[] {3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5}) != 139629729) System.out.println("Test 2.1 failed");
    if (testpart(2, new long[] {3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,
        -5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,
        53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10}) != 18216) System.out.println("Test 2.2 failed");
  }

  public static void main(String[] args) throws Exception {
    permute();
    wes W = new wes();
    W.test();
    for (int i=0; i<5; i++) W.amps[i] = wes_computer.wc_from_input("d07/wes-input.txt");
    System.out.println("Part 1 : "+W.part1());
    System.out.println("Part 2 : "+W.part2());
  }
}
