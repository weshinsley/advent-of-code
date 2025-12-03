package d19;

import d09.wes_computer;

public class puzzle {
 
  boolean get_pix(wes_computer wc, int x, int y) {
    return wc.reset().add_input(x).add_input(y).run().read_output() == 1;
  }
  
  public int solve1(wes_computer wc) {
    int count=0;
    for (int y=0; y<50; y++) {
      for (int x=0; x<50; x++) {
        if (get_pix(wc,x,y)) count++;
      }
    }
    return count;
  }
  
  public int solve2(wes_computer wc) {
    int right=0;
    int y=50;
    while (!get_pix(wc, right, y)) right++;
    while (get_pix(wc, right,y)) right++;
    right--;
    while (true) {
      y++;
      while (get_pix(wc, right,y)) right++;
      right--;
      if ((get_pix(wc, right-99, y)) && (get_pix(wc, right-99, y+99)) && (get_pix(wc, right, y+99))) {
        return ((right-99) * 10000) + y;
      }
    }
  }
  
  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    wes_computer wc = wes_computer.wc_from_input("../inputs/input_19.txt");
    System.out.println("Part 1: "+W.solve1(wc));
    System.out.println("Part 2: "+W.solve2(wc));
    
    
  }
}