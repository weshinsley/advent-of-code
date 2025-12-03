package d04;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import tools.Utils;

public class puzzle {

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

  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    ArrayList<String> input = Utils.readLines("../inputs/input_4.txt");
    System.out.println(w.solve(input, false));
    System.out.println(w.solve(input, true));
  }
}
