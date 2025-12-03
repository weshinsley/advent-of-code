package d06;

import java.io.BufferedReader;
import java.io.FileReader;

public class puzzle {

  int[] process(int[] res, String g) {
    String[] bits = g.split("\n");
    res[1] += 26;
    for (char ch = 'a'; ch <= 'z'; ch++) {
      res[0] += (g.indexOf(ch) >= 0) ? 1 : 0;
      for (int j = 0; j < bits.length; j++) {
        if (bits[j].indexOf(ch) == -1) {
          res[1]--;
          break;
        }
      }
    }
    return res;
  }

  int[] solve(String f) throws Exception {
    int[] res = new int[2];
    BufferedReader br = new BufferedReader(new FileReader(f));
    String s = br.readLine();
    String group = "";
    while (s != null) {
      if (s.equals("")) {
        res = process(res, group);
        group = "";
      } else
        group += s + "\n";
      s = br.readLine();
    }
    if (!group.equals(""))
      res = process(res, group);
    br.close();
    return res;
  }

  void run() throws Exception {
    System.out.println("Advent of Code 2020 - Day 06\n----------------------------");
    int[] res = solve("../inputs/input_6.txt");
    System.out.println("Part 1: " + res[0]);
    System.out.println("Part 2: " + res[1]);
  }

  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
