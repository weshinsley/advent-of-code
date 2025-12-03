package d02;

import java.util.ArrayList;
import tools.WesUtils;

public class puzzle {
  ArrayList<String> input;

  int advent2a() {
    char[] alphabet = new char[26];
    int lower_a = (int) 'a';
    int count2 = 0, count3 = 0;

    for (int i = 0; i < input.size(); i++) {
      String s = input.get(i);

      for (int j = 0; j<s.length(); j++)
        alphabet[(int)s.charAt(j) - lower_a]++;

      for (int j = 0; j<alphabet.length; j++)
        if (alphabet[j] == 2) { count2++; break; }

      for (int j = 0; j < alphabet.length; j++)
        if (alphabet[j] == 3) { count3++; break; }

      if (i<input.size()-1) {
        for (int j = 0; j < 26; j++) alphabet[j] = 0;
      }
    }
    return count2 * count3;
  }

  String advent2b() {
    for (int i = 0; i < input.size() - 1; i++) {
      String si = input.get(i);
      for (int j = i + 1; j < input.size(); j++) {
        String sj = input.get(j);
        int count_diffs = 0;

        for (int k = 0; k < si.length(); k++) {
          if (si.charAt(k) != sj.charAt(k)) count_diffs++;
          if (count_diffs == 2) break;
        }

        if (count_diffs == 1) {
          StringBuffer sb = new StringBuffer();
          for (int k = 0; k < si.length(); k++)
            if (si.charAt(k) == sj.charAt(k)) sb.append(si.charAt(k));
          return sb.toString();
        }
      }
    }
    return null;
  }

  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.input = WesUtils.readLines("../inputs/input_2.txt");
    System.out.println(w.advent2a());
    System.out.println(w.advent2b());
  }
}
