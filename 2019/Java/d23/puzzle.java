package d23;

import d09.wes_computer;

public class puzzle {

  long solve(String f, boolean part1) throws Exception {
    long nat_x = -1, nat_y=-1, last_nat_y = -2;
    wes_computer[] wc = new wes_computer[50];
    for (int i=0; i<50; i++) {
      wc[i] = wes_computer.wc_from_input(f);
      wc[i].add_input(new long[] {i});
      wc[i].run();
    }

    while (true) {
      for (int i=0; i<50; i++) {
        if (wc[i].input_queue_size()==0) wc[i].add_input(-1);
        wc[i].run();
        while (wc[i].output_available()) {
          int to = (int) wc[i].read_output();
          long dx = wc[i].read_output();
          long dy = wc[i].read_output();
          if (to==255) {
            if (part1) return dy;
            else {
              nat_x = dx;
              nat_y = dy;

            }
          } else {
            wc[to].add_input(dx);
            wc[to].add_input(dy);
          }
        }
      }

      if (!part1) {
        int count_idle = 0;
        for (int i=0; i<50; i++) count_idle += (wc[i].input_queue_size()==0)?1:0;
        if (count_idle == 50) {
          wc[0].add_input(nat_x);
          wc[0].add_input(nat_y);
          if (nat_y == last_nat_y) return nat_y;
          last_nat_y = nat_y;

        }
      }
    }
  }
  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    System.out.println(W.solve("../inputs/input_23.txt", true));
    System.out.println(W.solve("../inputs/input_23.txt", false));
  }
}
