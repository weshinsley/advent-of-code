package d15;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.LinkedList;

public class puzzle {
  
  static int[][] read_matrix(String f, boolean part2) throws Exception {
    BufferedReader br = new BufferedReader(new FileReader(new File(f)));
    String s = br.readLine();
    int size = s.length();
    int[][] M;
    if (part2) M = new int[size * 5][size * 5];
    else M = new int[size][size];
    int j=0;
    while (s!= null) {
      for (int i=0; i<s.length(); i++) {
        int val = Integer.parseInt(""+s.charAt(i));
        M[i][j] = val;
        if (part2) {
          for (int ii = 0; ii <= 4; ii++) {
            for (int jj = 0; jj <= 4; jj++) {
              if ((ii!=0) || (jj!=0)) {
                int val2 = val + ii + jj;
                while (val2 > 9) val2 = val2 - 9;
                M[i+(ii * size)][j+(jj * size)] = val2;
              }
            }
          }
        }
      }
      j++;
      s = br.readLine();
    }
    br.close();
    return M;
  }
  
  static int solve(int[][] grid) {
    int best = Integer.MAX_VALUE;
    int[] dx = new int[] {1,0,-1,0};
    int[] dy = new int[] {0,1,0,-1};
    int size = grid.length;
    int[][] dist = new int[size][size];
    for (int i=0; i<size; i++)
      for (int j=0; j<size; j++) 
        dist[i][j] = Integer.MAX_VALUE;
    dist[0][0] = 0;
    LinkedList<Integer> Q = new LinkedList<Integer>();
    Q.add(0);
    Q.add(0);
    Q.add(0);
    while (Q.size() > 0) {
      int x = Q.pop();
      int y = Q.pop();
      int d = Q.pop();
      for (int dir = 0; dir < 4; dir++) {
        int nx = x + dx[dir];
        int ny = y + dy[dir];
        if ((nx < 0) || (ny < 0) || (nx >= size) || (ny >= size)) 
          continue;
        int nd = d + grid[nx][ny];
        if ((nd < dist[nx][ny]) && (nd + (size - nx) + (size-ny) < best)) {
          dist[nx][ny] = nd;
          if ((nx == size - 1) && (ny == size - 1)) {
            best = nd;
          } else {
            Q.add(nx);
            Q.add(ny);
            Q.add(nd);
          }
        }
      }
    }
    return best;    
  }
  
  static void exec(String msg, String file, boolean part2) throws Exception {
    long t = System.currentTimeMillis();
    int[][] matrix = read_matrix(file, part2);
    int res = solve(matrix);
    long t2 = System.currentTimeMillis();
    System.out.print(msg + " "+res+" in "+(t2-t)+" ms\t");
    System.out.println();
  }
  
  public static void main(String[] args) throws Exception {
    System.out.println("Advent of code 2021 - Day 15\n");
    exec("PART 1: ", "../inputs/input_15.txt", false);
    exec("PART 2: ", "../inputs/input_15.txt", true);
  }
}
