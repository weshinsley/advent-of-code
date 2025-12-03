package d24;
import java.util.ArrayList;
import java.util.HashSet;

public class puzzle {
  // To-do - read this from input instead of hard-coding!
  static int[] line5 = new int[] {1, 1, 1, 1, 26, 26, 1, 1 ,26, 26, 1 ,26, 26, 26};
  static int[] line6 = new int[] {10, 11, 14, 13, -6, -14, 14, 13, -8, -15, 10, -11, -13, -4};
  static int[] line16 = new int[] {1, 9, 12, 6, 9, 15, 7, 12, 15, 3, 6, 2, 10, 12};

  static int nextz(int z, int w, int depth) {
    int x = z % 26;
    z /= line5[depth];
    x += line6[depth];
    x = (x != w) ? 1 : 0;
    int y = (25 * x) + 1;         // y is either 26 or 1
    z *= y;
    y = (w + line16[depth]) * x;
    return z+y;
  }
  
  static ArrayList<ArrayList<HashSet<Integer>>> cache;
  
  static void init() {
    cache = new ArrayList<ArrayList<HashSet<Integer>>>();
    for (int i=0; i<14; i++) {
      cache.add(new ArrayList<HashSet<Integer>>());
      for (int j=0; j<10; j++) {
        cache.get(i).add(new HashSet<Integer>());
      }
    }
  }
  
  static int[] track_input = new int[] {1,1,1,1,1,1,1,1,1,1,1,1,1,1};
  static int w1 = 1;
  static int w2 = 10;
  static int wd = 1;
  
  static void solve_recurse(int depth, int z) throws Exception {
    if (depth == 14) {
      if (z == 0) {
        for (int i=0; i<14; i++) System.out.print(track_input[i]);
        throw new Exception("All done");
      }
    } else {
      for (int w = w1; w != w2; w += wd) {
        track_input[depth] = w;
        if (!cache.get(depth).get(w).contains(z)) {
          int res = nextz(z, w, depth);
          cache.get(depth).get(w).add(z);
          solve_recurse(depth + 1, res);
          
        }
      }
    }
  }
 
  public static void part1() {
    init();
    w1 = 9;
    w2 = 0;
    wd = -1;
    try {
      solve_recurse(0, 0);
    } catch (Exception e) {}
  }
  
  public static void part2() {
    init();
    w1 = 1;
    w2 = 10;
    wd = 1;
    try {
      solve_recurse(0, 0);
    } catch (Exception e) {}
  }


  public static void main(String[] args) {
   System.out.print("Part 1: ");
   long time = System.currentTimeMillis();
   part1();
   time = System.currentTimeMillis() - time;
   System.out.println("  ( "+ time+" ms)");
   
   System.out.print("Part 2: ");
   time = System.currentTimeMillis();
   part2();
   time = System.currentTimeMillis() - time;
   System.out.println("  ( "+ time+" ms)");
   
  }
}
