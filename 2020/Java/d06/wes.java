package d06;

import java.io.BufferedReader;
import java.io.FileReader;

public class wes {

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

  void stop_if_not(long res, long expec, String test) {
    if (res != expec) {
      System.out.println("Test " + test + " failure - expected " + expec + ", got " + res);
      System.exit(-1);
    }
  }

  void run() throws Exception {
    int[] res = solve("d06/test_11_6.txt");
    stop_if_not(res[0], 11, "Test Part 1");
    stop_if_not(res[1], 6, "Test Part 2");
    
    System.out.println("Advent of Code 2020 - Day 06\n----------------------------");
    res = solve("d06/wes-input.txt");
    System.out.println("Part 1: " + res[0]);
    System.out.println("Part 2: " + res[1]);
  }

  public static void main(String[] args) throws Exception {
    new wes().run();
  }
}
