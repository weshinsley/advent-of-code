package d11;

import java.io.File;
import java.nio.file.Files;
import java.util.Arrays;
import java.util.List;

public class puzzle {
  char[][] read_input(String f) throws Exception {
    List<String> as = Files.readAllLines(new File(f).toPath());
    char[][] grid = new char[as.size()][];
    for (int i = 0; i<as.size(); i++) {
      grid[i] = as.get(i).toCharArray();
    }
    return grid;
  }
  
  int count_dir(char[][] m, int i, int j, int dx, int dy, int part) {
    while ((i >= 0) && (j >= 0) && (j < m.length) && (i < m[0].length)) {
      if (m[j][i] == 'L') return 0;
      else if (m[j][i] =='#') return 1;
      if (part == 1) break;
      i += dx;
      j += dy;
    }
    return 0;
  }
  
  int[] update(char[][] m1, char[][] m2, int part) {
    int changes = 0, new_count = 0;
    for (int j = 0; j < m1.length; j++)
      for (int i = 0; i < m1[0].length; i++) {
        int count = 0;
        for (int dx = -1; dx <= 1; dx++)
          for (int dy = -1; dy <= 1; dy++)
            if ((dx != 0) || (dy != 0)) 
              count += count_dir(m1, i + dx, j + dy, dx, dy, part);
          
        if ((m1[j][i] == 'L') && (count == 0)) {
          m2[j][i] = '#';
          changes = 1;
        } else if ((m1[j][i] == '#') && (count >= 3 + part)) {
          m2[j][i] = 'L';
          changes = 1;
        } else m2[j][i] = m1[j][i];
        
        new_count += (m2[j][i] == '#') ? 1 : 0;
      }
    return new int[] {changes, new_count};
  }

  int solve(char[][] m1, int part) {
    boolean flip = true;
    char[][] m2 = Arrays.stream(m1).map(char[]::clone).toArray(char[][]::new);
    int[] res;
    do {
      res = update(flip?m1:m2, flip?m2:m1, part);
      flip = !flip;
    } while (res[0] == 1);
    return res[1];
  }

  void run() throws Exception {
    System.out.println("Advent of Code 2020 - Day 11\n----------------------------");
    System.out.println("Part 1: " + solve(read_input("../inputs/input_11.txt"), 1));
    System.out.println("Part 2: " + solve(read_input("../inputs/input_11.txt"), 2));
  }

  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
