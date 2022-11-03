package d03;

import java.util.Arrays;
import java.util.HashMap;

import tools.Utils;

public class wes {
  int[] dx = new int[] {1,0,-1,0};
  int[] dy = new int[] {0,-1,0,1};

  public int solve(int input, boolean part2) {
    HashMap<String, Integer> map = new HashMap<String, Integer>();
    map.put("0,0", 1);
    // Step count = 1,1,2,2,3,3,4,4 etc
    int dir=0;
    int x=0;
    int y=0;
    int n=1;
    int steps = 1;
    int max_steps = 1;
    int total = 1;
    boolean first = true;
    while (true) {
      n++;
      x += dx[dir];
      y += dy[dir];
      total = 0;
      if (part2) {
        for (int ix=-1; ix<=1; ix++)
          for (int iy=-1; iy<=1; iy++)
            if (map.get((x+ix)+","+(y+iy)) != null) total+=map.get((x+ix)+","+(y+iy));
        map.put(x+","+y, total);
      }
      steps--;
      if (steps == 0) {
        if (!first) max_steps++;
        steps = max_steps;
        first = !first;
        dir = (dir + 1) % 4;
      }
      if ((!part2) && (n >= input)) return Math.abs(x) + Math.abs(y);      
      if ((part2) && (total >= input)) return total;
    }
  }

  public void test() throws Exception {
    Utils.test(solve(12, false), 3);
    Utils.test(solve(23, false), 2);
    Utils.test(solve(1024, false), 31);
    Utils.test(solve(800, true), 806);
    Utils.test(solve(746, true), 747);
  }

  public static void main(String[] args) throws Exception {
    wes w = new wes();
    w.test();
    int input = Integer.parseInt(Utils.readLines("../R/03/input.txt").get(0));
    System.out.println(w.solve(input, false));
    System.out.println(w.solve(input,  true));
   }
}
