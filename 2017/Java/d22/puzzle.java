package d22;

import java.util.ArrayList;
import java.util.HashMap;

import tools.Utils;

public class puzzle {
  HashMap<Integer, HashMap<Integer, Character>> sparse = new HashMap<Integer, HashMap<Integer, Character>>();
  int size;

  final byte[] dx = new byte[] {0, 1, 0, -1};
  final byte[] dy = new byte[] {-1, 0, 1, 0};

  void parse(ArrayList<String> input) {
    for (int i : sparse.keySet()) {
      sparse.get(i).clear();
    }
    sparse.clear();
    size = input.size();
    for (int j = 0; j < input.size(); j++) {
      String s = input.get(j);
      HashMap<Integer, Character> row = null;
      for (int i = 0; i < s.length(); i++) {
        if (s.charAt(i) == '#') {
          if (row == null) {
            row = new HashMap<Integer, Character>();
            sparse.put(j, row);
          }
          row.put(i,  '#');
        }
      }
    }
  }

  int solve(int bursts, boolean part1) {
    int x = size/2;
    int y = x;
    int dir = 0;
    int inf = 0;
    for (int b=0; b<bursts; b++) {
      char status = '.';
      if (sparse.containsKey(y)) {
        if (sparse.get(y).containsKey(x)) {
          status = sparse.get(y).get(x);
        }
      }
      if (part1) {
        if (status == '#') {
          dir = (dir + 1) % 4;
          sparse.get(y).remove(x);
        } else {
          dir = (dir + 3) % 4;
          inf++;
          if (!sparse.containsKey(y)) {
            sparse.put(y, new HashMap<Integer, Character>());
          }
          sparse.get(y).put(x, '#');
        }
      } else {
        if (status == 'F') {
          sparse.get(y).remove(x);
          dir = (dir + 2) % 4;
        } else if (status == '#') {
          sparse.get(y).put(x,  'F');
          dir = (dir + 1) % 4;
        } else if (status == 'W') {
          sparse.get(y).put(x,  '#');
          inf++;
        } else {
          if (!sparse.containsKey(y)) {
            sparse.put(y, new HashMap<Integer, Character>());
          }
          sparse.get(y).put(x, 'W');
          dir = (dir + 3) % 4;
        }
      }
      x += dx[dir];
      y += dy[dir];
    }
    return inf;
  }

  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    ArrayList<String> input = Utils.readLines("../inputs/input_22.txt");
    w.parse(input);
    System.out.println(w.solve(10000, true));
    w.parse(input);
    System.out.println(w.solve(10000000, false));
  }
}
