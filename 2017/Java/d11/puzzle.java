package d11;
import tools.Utils;

public class puzzle {
  
  int dist(int x, int y) {
    x = Math.abs(x);
    y = Math.abs(y);
    int steps = Math.min(x, y);
    x -= steps;
    y -= steps;
    if (y > 0) steps += y / 2;
    if (x > 0) steps += x;
    return steps;
  }
  
  int[] solve(String[] path) {
    int x = 0;
    int y = 0;
    int maxx = 0;
    int maxy = 0;
    for (int i = 0; i < path.length; i++) {
      if (path[i].equals("n")) y -= 2;
      else if (path[i].equals("ne")) { y -= 1; x += 1; }
      else if (path[i].equals("se")) { y += 1; x += 1; }
      else if (path[i].equals("s"))    y += 2;
      else if (path[i].equals("sw")) { y += 1; x -= 1; }
      else if (path[i].equals("nw")) { y -= 1; x -= 1; }
      maxx = Math.max(maxx, Math.abs(x));
      maxy = Math.max(maxy, Math.abs(y));
    }
    
    return new int[] {dist(x, y), dist(maxx, maxy) }; 
    
  }
  public void test() throws Exception {
    Utils.test(solve(new String[] {"ne", "ne", "ne"})[0], 3);
    Utils.test(solve(new String[] {"ne", "ne", "sw", "sw"})[0], 0);
    Utils.test(solve(new String[] {"ne", "ne", "s",  "s"})[0], 2);
    Utils.test(solve(new String[] {"se", "sw", "se", "sw", "sw"})[0], 3);
  }

  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.test();
    String[] input = Utils.readLines("../inputs/input_11.txt").get(0).split(",");
    int[] res = w.solve(input);
    System.out.println(res[0]);
    System.out.println(res[1]);
  }
}
