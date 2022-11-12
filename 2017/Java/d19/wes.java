package d19;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.HashMap;

import tools.Utils;

public class wes {
  int[] dx = new int[] {0, 1, 0, -1};
  int[] dy = new int[] {-1, 0, 1, 0};
  byte NORTH = 0;
  byte EAST = 1;
  byte SOUTH = 2;
  byte WEST = 3;

  String[] solve(ArrayList<String> map) {
    int x = map.get(0).indexOf("|");
    int y = 0;
    int steps = 0;
    String path = "";
    byte dir = SOUTH;
    char ch = map.get(y).charAt(x);
    while (ch!=' ') {
      steps++;
      y += dy[dir];
      x += dx[dir];
      ch = map.get(y).charAt(x);
      if ((ch == '|') || (ch == '-')) continue;
      if ((ch >= 'A') && (ch <= 'Z')) {
        path += ch;
        continue;
      }
      if (ch == '+') {
        if ((dir == NORTH) || (dir == SOUTH)) {
          dir = (map.get(y).charAt(x - 1) != ' ') ? WEST : EAST;
        } else {
          dir = (map.get(y - 1).charAt(x) != ' ') ? NORTH : SOUTH;
        }
      }
    }
    return new String[] {path, String.valueOf(steps)};
  }

  void test() throws Exception {
    ArrayList<String> input = Utils.readLines("../R/19/example.txt");
    String[] res = solve(input);
    Utils.test(res[0],  "ABCDEF");
    Utils.test(res[1],  "38");
  }

  public static void main(String[] args) throws Exception {
    wes w = new wes();
    w.test();
    ArrayList<String> input = Utils.readLines("../R/19/input.txt");
    String[] res = w.solve(input);
    System.out.println(res[0] + "\n" + res[1]);
  }
}
