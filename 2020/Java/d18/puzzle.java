package d18;

import java.io.File;
import java.nio.file.Files;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class puzzle {
  
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

  void run() throws Exception {
    List<String> wes = Files.readAllLines(new File("../inputs/input_18.txt").toPath());
    System.out.println("Advent of Code 2020 - Day 18\n----------------------------");
    System.out.println("Part 1: " + solve(wes, false));
    System.out.println("Part 2: " + solve(wes, true));
  }

  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
