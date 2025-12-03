package d07;

import d09.wes_computer;

public class puzzle {
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

  public static void main(String[] args) throws Exception {
    permute();
    puzzle W = new puzzle();
    for (int i=0; i<5; i++) W.amps[i] = wes_computer.wc_from_input("../inputs/input_7.txt");
    System.out.println("Part 1 : "+W.part1());
    System.out.println("Part 2 : "+W.part2());
  }
}
