package d18;

import java.io.File;
import java.nio.file.Files;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class wes {
  
  long calc_flat(StringBuffer s, boolean part2) {
    if (part2) {
      while (s.indexOf("+") >= 0) {
        Pattern word = Pattern.compile("[0-9]+ [+] [0-9]+");
        Matcher match = word.matcher(s);
        if (match.find()) {
          String[] bits = s.substring(match.start(), match.end()).split("\\s\\+\\s");
          long val = Long.parseLong(bits[0]) + Long.parseLong(bits[1]);
          s.replace(match.start(), match.end(), String.valueOf(val));
        }
      }
    }
    String[] bits = s.toString().split("\\s+");
    long val = Long.parseLong(bits[0]);
    int i=1;
    while (i<bits.length) {
      long val2 = Long.parseLong(bits[i+1]);
      val = (bits[i].equals("+"))? val + val2 : val * val2;
      i+=2;
    }
    return val;
  }
  
  StringBuffer rewrite(StringBuffer s, boolean part2) {
    if (s.indexOf("(") == -1) return new StringBuffer(String.valueOf(calc_flat(s, part2)));
    else {
      int from = s.indexOf("(");
      int to = from + 1;
      int bracket_count = 1;
      while (bracket_count > 0) {
        char ch = s.charAt(to++);
        if (ch == '(') bracket_count++;
        else if (ch == ')') bracket_count--;
      }
      String exp = s.substring(from + 1, to - 1);
      String res = rewrite(new StringBuffer(exp), part2).toString();
      s.replace(from, to, res);
      return rewrite(s, part2);
    }
  }
  
  long solve1(String w, boolean part2) {
    return Long.parseLong(rewrite(new StringBuffer(w), part2).toString());
  }
  
  long solve(List<String> w, boolean part2) {
    long val=0;
    for (int i=0; i<w.size(); i++)
      val+=solve1(w.get(i), part2);
    return val;
  }
  
  void stop_if_not(long res, int expec, String test) {
    if (res != expec) {
      System.out.println("Test " + test + " failure - expected " + expec + ", got " + res);
      System.exit(-1);
    }
  }

  void run() throws Exception {
    stop_if_not(solve1("1 + 2 * 3 + 4 * 5 + 6", false), 71, "P1 T1");
    stop_if_not(solve1("1 + (2 * 3) + (4 * (5 + 6))", false), 51, "P1 T2");
    stop_if_not(solve1("2 * 3 + (4 * 5)", false), 26, "P1 T3");
    stop_if_not(solve1("5 + (8 * 3 + 9 + 3 * 4 * 3)", false), 437, "P1 T4");
    stop_if_not(solve1("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", false), 12240, "P1 T5");
    stop_if_not(solve1("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", false), 13632, "P1 T6");
    stop_if_not(solve1("1 + 2 * 3 + 4 * 5 + 6", true), 231, "P2 T1");
    stop_if_not(solve1("1 + (2 * 3) + (4 * (5 + 6))", true), 51, "P2 T2");
    stop_if_not(solve1("2 * 3 + (4 * 5)", true), 46, "P2 T3");
    stop_if_not(solve1("5 + (8 * 3 + 9 + 3 * 4 * 3)", true), 1445, "P2 T4");
    stop_if_not(solve1("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", true), 669060, "P2 T5");
    stop_if_not(solve1("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", true), 23340, "P2 T6");

    List<String> wes = Files.readAllLines(new File("d18/wes-input.txt").toPath());
    System.out.println("Advent of Code 2020 - Day 18\n----------------------------");
    System.out.println("Part 1: " + solve(wes, false));
    System.out.println("Part 2: " + solve(wes, true));
  }

  public static void main(String[] args) throws Exception {
    new wes().run();
  }
}
