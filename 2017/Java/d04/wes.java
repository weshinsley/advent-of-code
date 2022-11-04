package d04;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import tools.Utils;

public class wes {

  boolean valid(String s, boolean part2) {
    List<String> bits = Arrays.asList(s.trim().split("\\s+"));
    if (part2) {
      for (int i=0; i<bits.size(); i++) {
        char[] chars = bits.get(i).toCharArray();
        Arrays.sort(chars);
        bits.set(i, new String(chars));
      }
    }
    
    Collections.sort(bits);
    for (int i=0; i<bits.size()-1; i++)
      if (bits.get(i).equals(bits.get(i + 1))) return false;
    return true;
  }
  
  public int solve(ArrayList<String> input, boolean part2) {
    int tot = 0;
    for (int i=0; i<input.size(); i++) {
      tot += valid(input.get(i), part2)?1:0;
    }
    return tot;
  }

  public void test() throws Exception {
    Utils.test(valid("aa bb cc dd ee", false), true);
    Utils.test(valid("aa bb cc dd aa", false), false);
    Utils.test(valid("aa bb cc dd aaa", false), true);
    Utils.test(valid("abcde fghij", true), true);
    Utils.test(valid("abcde xyz ecdab", true),  false);
    
    Utils.test(valid("a ab abc abd abf abj", true),  true);
    Utils.test(valid("iiii oiii ooii oooi oooo", true),  true);
    Utils.test(valid("oiii ioii iioi iiio", true),  false);
  }

  public static void main(String[] args) throws Exception {
    wes w = new wes();
    w.test();
    ArrayList<String> input = Utils.readLines("../R/04/input.txt");
    System.out.println(w.solve(input, false));
    System.out.println(w.solve(input, true));
  }
}
