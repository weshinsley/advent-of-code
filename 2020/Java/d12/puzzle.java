package d12;

import java.awt.Point;
import java.io.File;
import java.nio.file.Files;
import java.util.List;

public class puzzle {
  
  void move_news(char dir, Point p, int dist) {
    if (dir=='E') p.x+=dist;
    else if (dir=='W') p.x-=dist;
    else if (dir=='N') p.y-=dist;
    else if (dir=='S') p.y+=dist;
  }
  
  void rotate(char dir, int angle, Point p) {
    for (int j = 0; j < angle / 90; j++) {
      int swap = p.y;
      p.y = (dir == 'R') ? p.x: -p.x;
      p.x = (dir == 'R') ? -swap: swap;
    }
  }
  
  int solve1(List<String> d) {
   int[] dx = new int[] {0,1,0,-1};
   int[] dy = new int[] {-1,0,1,0};
   int current_dir = 1;
   Point ship = new Point(0,0);
   for (int i=0; i<d.size(); i++) {
     int dist = Integer.parseInt(d.get(i).substring(1));
     char dir = d.get(i).charAt(0);
     if (dir=='L') current_dir = (current_dir + 3 * (dist/90)) % 4;
     else if (dir=='R') current_dir = (current_dir + 1 * (dist/90)) % 4;
     else if (dir=='F') ship.translate(dist * dx[current_dir], dist * dy[current_dir]);
     else move_news(dir, ship, dist);
   }
   return Math.abs(ship.x)+Math.abs(ship.y);
  }
  
  int solve2(List<String> d) {
    Point wp = new Point(10, -1);
    Point ship = new Point(0, 0);
    for (int i=0; i<d.size(); i++) {
      int dist = Integer.parseInt(d.get(i).substring(1));
      char dir = d.get(i).charAt(0);
      if ((dir == 'L') || (dir == 'R')) rotate(dir, dist, wp);
      else if (dir == 'F') ship.translate(wp.x * dist, wp.y * dist);
      else move_news(dir, wp, dist);
    }
    return Math.abs(ship.x)+Math.abs(ship.y);
   }

  void run() throws Exception {
    List<String> w  = Files.readAllLines(new File("../inputs/input_12.txt").toPath());
    System.out.println("Advent of Code 2020 - Day 12\n----------------------------");
    System.out.println("Part 1: " + solve1(w));
    System.out.println("Part 2: " + solve2(w));
  }

  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
