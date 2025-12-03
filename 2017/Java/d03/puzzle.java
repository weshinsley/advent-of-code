package d03;

import java.util.Arrays;
import java.util.HashMap;

import tools.Utils;

public class puzzle {
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

  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    int input = Integer.parseInt(Utils.readLines("../inputs/input_3.txt").get(0));
    System.out.println(w.solve(input, false));
    System.out.println(w.solve(input,  true));
   }
}
