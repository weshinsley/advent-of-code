package d17;

import java.io.File;
import java.nio.file.Files;
import java.util.HashSet;
import java.util.List;

public class puzzle {

  class State {
    HashSet<String> map = new HashSet<String>();
    int minx = 0, miny = 0, minz = 0, minw = 0;
    int maxx = 0, maxy = 0, maxz = 0, maxw = 0;

    void update_range(int x, int y, int z, int w) {
      minx = Math.min(minx, x); maxx = Math.max(maxx, x);
      miny = Math.min(miny, y); maxy = Math.max(maxy, y);
      minz = Math.min(minz, z); maxz = Math.max(maxz, z);
      minw = Math.min(minw, w); maxw = Math.max(maxw, w);
    }
  }

  State read_input(String f, boolean part2) throws Exception {
    State S = new State();
    List<String> lines = Files.readAllLines(new File(f).toPath());
    for (int j=0; j<lines.size(); j++) {
      for (int i=0; i<lines.size(); i++) {
        if (lines.get(j).charAt(i) == '#') {
          S.update_range(i, j, 0, 0);
          S.map.add(""+i+","+j+","+0+(part2?",0":""));
        }
      }
    }
    return S;
  }

  int solve(String f, boolean part2) throws Exception {
    State S = read_input(f, part2);
    for (int n = 0; n < 6; n++) {
      State S2 = new State();
      for (int x = S.minx - 1; x <= S.maxx + 1; x++)
        for (int y = S.miny - 1; y <= S.maxy + 1; y++)
          for (int z = S.minz - 1; z <= S.maxz + 1; z++)
            for (int w = (part2?(S.minw - 1):0); w <= (part2?(S.maxw + 1):0); w++) {
              boolean full = S.map.contains(x+","+y+","+z+(part2?","+w:""));
              int neighbours = 0;
              for (int xx = x - 1; xx <= x + 1; xx++)
                for (int yy = y - 1; yy <= y + 1; yy++)
                  for (int zz = z - 1; zz <= z + 1; zz++)
                    for (int ww = (part2?w-1:0); ww <= (part2?w+1:0); ww++) {
                      if ((xx!=x) || (yy!=y) || (zz!=z) || (ww!=w)) {
                        if (S.map.contains(xx+","+yy+","+zz+(part2?","+ww:""))) neighbours++;
                        if (neighbours > 3) {
                          xx = x + 1;
                          yy = y + 1;
                          zz = z + 1;
                          ww = w + 1;
                        }
                      }
                    }

             if (((full) && ((neighbours==2) || (neighbours==3))) ||
               ((!full) && (neighbours==3))) {
               S2.map.add(x+","+y+","+z+(part2 ? "," + w : ""));
               S2.update_range(x,  y, z,  w);
             }
           }

      S.map.clear();
      S = S2;
    }
    return S.map.size();
  }

  void run() throws Exception {
    System.out.println("Advent of Code 2020 - Day 17\n----------------------------");
    System.out.println("Part 1: " + solve("../inputs/input_17.txt", false));
    System.out.println("Part 2: " + solve("../inputs/input_17.txt", true));
  }

  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
