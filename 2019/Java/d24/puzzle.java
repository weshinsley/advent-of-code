package d24;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.HashSet;

public class puzzle {
  long[] pow2 = new long[] {1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768,
                         65536,131072,262144,524288,1048576,2097152,4194304,8388608,16777216L};

 long toLong(String s) {
   long total=0;
   for (int i=0; i<25; i++) {
     total+=(s.charAt(i)=='#')?pow2[i]:0;
   }
   return total;
 }

 long readInput(String f) throws Exception {
    BufferedReader br = new BufferedReader(new FileReader(f));
    int val = 0;
    long total = 0;
    for (int j=0; j<5; j++) {
      String s = br.readLine();
      for (int i=0; i<5; i++) {
        total+=(s.charAt(i)=='#')?pow2[val]:0;
        val++;
      }
    }
    br.close();
    return total;
  }

  long update1(long d) {
    long d2 = d;
    for (int i=0; i<25; i++) {
      int neighbours=0;
      int y = i/5;
      int x = i%5;
      boolean current = (d & pow2[i])>0;
      if (x>0) neighbours += ((d & pow2[i-1])>0)?1:0;
      if (x<4) neighbours += ((d & pow2[i+1])>0)?1:0;
      if (y>0) neighbours += ((d & pow2[i-5])>0)?1:0;
      if (y<4) neighbours += ((d & pow2[i+5])>0)?1:0;

      if ((current) && (neighbours!=1)) d2 -= pow2[i];
      else if ((!current) && ((neighbours==1) || (neighbours==2))) d2 += pow2[i];
    }
    return d2;
  }

  long solve1(long state) {
    HashSet<Long> history = new HashSet<Long>();
    while (!history.contains(state)) {
      history.add(state);
      state = update1(state);
    }
    return state;
  }

  /********************************/

  /* I suspect working these out with code would be a bit tangly, and there are only
   * 25 cells... so I drew a big picture, and for each cell 0-24, these are the
   * neighbours on the same, next, and previous recursive level.
   */

  static int[][] neighbour_same_level = new int[][] {{1,5},{0,6,2},{1,7,3},{2,8,4},{3,9},
                                             {0,6,10},{1,5,7,11},{2,6,8},{3,7,9,13},{4,8,14},
                                             {5,11,15},{6,10,16},{},{8,14,18},{9,13,19},
                                             {10,16,20},{11,15,17,21},{16,18,22},{13,17,19,23},{14,18,24},
                                             {15,21},{16,20,22},{17,21,23},{18,22,24},{19,23}};

  static int[][] neighbour_next_level = new int[][] {{},{},{},{},{},
                                              {},{},{0,1,2,3,4},{},{},
                                              {},{0,5,10,15,20},{},{4,9,14,19,24},{},
                                              {},{},{20,21,22,23,24},{},{},
                                              {},{},{},{},{}};

  static int[][] neighbour_prev_level = new int[][] {{7,11},{7},{7},{7},{7,13},
                                              {11},{},{},{},{13},
                                              {11},{},{},{},{13},
                                              {11},{},{},{},{13},
                                              {11,17},{17},{17},{17},{13,17}};

  int max_lev;
  int min_lev;

  long[] update2(long[] d) {
    long[] d2 = new long[d.length];
    for (int i=0; i<d.length; i++) d2[i]=d[i];
    for (int lev=min_lev; lev<=max_lev; lev++) {
      for (int i=0; i<25; i++) {
        int neighbours=0;
        for (int j=0; j<neighbour_same_level[i].length; j++)
          neighbours += (d[lev] & pow2[neighbour_same_level[i][j]]) > 0 ? 1 : 0;
        for (int j=0; j<neighbour_next_level[i].length; j++)
          neighbours += (d[lev + 1] & pow2[neighbour_next_level[i][j]]) > 0 ? 1 : 0;
        for (int j=0; j<neighbour_prev_level[i].length; j++)
          neighbours += (d[lev - 1] & pow2[neighbour_prev_level[i][j]]) > 0 ? 1 : 0;

        boolean current = (d[lev] & pow2[i])>0;

        if ((current) && (neighbours!=1)) d2[lev] -= pow2[i];
        else if ((!current) && ((neighbours==1) || (neighbours==2))) {
          d2[lev] += pow2[i];
          max_lev = Math.max(max_lev,  lev + 1);
          min_lev = Math.min(min_lev,  lev - 1);
        }
      }
    }
    return d2;
  }

  long solve2(long state, int iters) {
    long[] world = new long[iters * 2];
    max_lev = iters+1;
    min_lev = iters-1;
    world[iters] = state;
    for (int i=0; i<iters; i++) {
      world = update2(world);
    }
    int count=0;
    for (int i=min_lev; i<=max_lev; i++) {
      for (int j=0; j<25; j++) {
        if ((world[i] & pow2[j]) > 0) count++;
      }
    }
    return count;
  }

  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    System.out.println("Part 1 : "+W.solve1(W.readInput("../inputs/input_24.txt")));
    System.out.println("Part 2 : "+W.solve2(W.readInput("../inputs/input_24.txt"),200));
  }
}
