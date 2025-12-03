package d11;

import java.util.ArrayList;

import d09.wes_computer;

public class puzzle {
  static int[] dx = new int[] {0,1,0,-1};
  static int[] dy = new int[] {-1,0,1,0};

  int solve(wes_computer wc, int start, boolean draw) {
    int robot_x = 0, robot_y = 0;
    int direction = 0;
    ArrayList<int[]> history = new ArrayList<int[]>();
    while (wc.get_status() != wes_computer.HALT) {
      int z=0;
      boolean found=false;
      for (z=0; z<history.size(); z++) {
        int[] point = history.get(z);
        if ((point[0] == robot_x) && (point[1] == robot_y)) {
          found = true;
          wc.add_input(point[2]);
          break;
        }
      }
      if (!found) {
        int pixel = 0;
        if (history.size() == 0) pixel = start;
        history.add(new int[] {robot_x, robot_y,pixel});
        wc.add_input(pixel);
        z = history.size()-1;
      }

      wc.run();
      if (wc.output_available()) {
        int col = (int) wc.read_output();
        history.set(z,  new int[] {robot_x, robot_y, col});
        int next = (int) wc.read_output();
        if (next == 0) direction = (direction + 3) %4;
        else if (next == 1) direction = (direction + 1) %4;
        robot_x += dx[direction];
        robot_y += dy[direction];
      }
    }

    if (draw) {
      int minx=0,miny=0,maxx=0,maxy=0;
      for (int i=0; i<history.size(); i++) {
        int[] point = history.get(i);
        minx=Math.min(point[0], minx);
        maxx=Math.max(point[0],  maxx);
        miny=Math.min(point[1], miny);
        maxy=Math.max(point[1], maxy);
      }

      StringBuffer[] sb = new StringBuffer[1+(maxy-miny)];
      for (int y=miny; y<=maxy; y++) {
        sb[y] = new StringBuffer();
        for (int x=minx; x<=maxx; x++) sb[y-miny].append(" ");
      }
      for (int i=0; i<history.size(); i++) {
        int[] point = history.get(i);
        if (point[2]==1) sb[point[1]-miny].setCharAt(point[0]-minx, '@');
      }
      for (int y=0; y<sb.length; y++) System.out.println(sb[y].toString());
    }
    return history.size();
  }

  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    System.out.println("Part 1 : "+W.solve(wes_computer.wc_from_input("../inputs/input_11.txt"), 0, false));
    System.out.println("Part 2 :\n");
    W.solve(wes_computer.wc_from_input("../inputs/input_11.txt"), 1, true);
  }
}
