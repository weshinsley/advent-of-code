package d03;

import java.io.BufferedReader;
import java.io.FileReader;

public class puzzle {
  
  char[][] wire_dir = new char[2][];
  int[][] wire_steps = new int[2][];
  int minx = Integer.MAX_VALUE, miny = Integer.MAX_VALUE;
  
  void readWire(String s, int wire_n) {
    String[] bits = s.split(",");
    wire_dir[wire_n] = new char[bits.length];
    wire_steps[wire_n] = new int[bits.length];
    for (int i =0; i < bits.length; i++) {
      wire_dir[wire_n][i] = bits[i].charAt(0);
      wire_steps[wire_n][i] = Integer.parseInt(bits[i].substring(1));
    }
  }
  
  int[][] getMap() {
    int maxx = 0, maxy = 0, x, y;
    for (int w = 0; w <= 1; w++) {
      x=0; 
      y=0;
      for (int i=0; i<wire_dir[w].length; i++) {
        if (wire_dir[w][i] == 'U') y -= wire_steps[w][i];
        else if (wire_dir[w][i] == 'D') y += wire_steps[w][i];
        else if (wire_dir[w][i] == 'L') x -= wire_steps[w][i];
        else if (wire_dir[w][i] == 'R') x += wire_steps[w][i];
        if (x < minx) minx = x;
        if (x > maxx) maxx = x;
        if (y < miny) miny = y;
        if (y > maxy) maxy = y;
      }
    }
    return new int[(maxy - miny) + 1][(maxx - minx) + 1];
  }
  
  int[] solve() {
    int[][] map = getMap();
    int best_dist = Integer.MAX_VALUE;
    int best_steps = Integer.MAX_VALUE;
    map[-miny][-minx] = Integer.MAX_VALUE / 2;
    int x,y,dx,dy;
    int[] steps = new int[2];  
    
    for (int w=0; w<=1; w++) {
      x = -minx;
      y = -miny;
          
      for (int i=0; i<wire_dir[w].length; i++) {
        dx = (wire_dir[w][i] == 'R') ? 1 : (wire_dir[w][i] == 'L') ? -1 : 0;
        dy = (wire_dir[w][i] == 'D') ? 1 : (wire_dir[w][i] == 'U') ? -1 : 0;
        for (int s=0; s<wire_steps[w][i]; s++) {
          steps[w]++;
          x+=dx;
          y+=dy;
          if (w==0) {
            if (map[y][x] == 0) map[y][x] = steps[w];
          } else {
            if (map[y][x] > 0) {
              int dist = Math.abs(x + minx) + Math.abs(y + miny);
              if (dist< best_dist) best_dist = dist;
              if ((map[y][x] + steps[w]) < best_steps) {
                best_steps = (map[y][x] + steps[w]);
              }
            }
          }
        }
      }
    }
    return new int[] {best_dist, best_steps};  
    
  }
  
  void readInput(String s) throws Exception {
    BufferedReader br = new BufferedReader(new FileReader(s));
    readWire(br.readLine(),0);
    readWire(br.readLine(),1);
    br.close();
  }
  
  
  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    W.readInput("../inputs/input_3.txt");
    int[] res = W.solve();
    System.out.println("Part 1: "+res[0]);
    System.out.println("Part 2: "+res[1]);
  }
}
