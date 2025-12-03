package d21;

import java.util.ArrayList;
import java.util.HashMap;

import tools.Utils;

public class puzzle {
  HashMap<String, String> rules = new HashMap<String, String>();
  HashMap<String, Integer> lights = new HashMap<String, Integer>();

  StringBuffer[] copyBuf(String[] s) {
    StringBuffer[] s2 = new StringBuffer[s.length];
    for (int i = 0; i < s.length; i++) s2[i] = new StringBuffer(s[i]);
    return s2;
  }

  String combine(StringBuffer[] s) {
    String res = s[0].toString();
    for (int j = 1; j < s.length; j++) {
      res += "/" + s[j].toString();
    }
    return res;
  }

  String rot(String s) {
    String[] bits = s.split("/");
    StringBuffer[] bits2 = copyBuf(bits);
    for (int j = 0; j < bits.length; j++) {
      for (int i = 0; i < bits[j].length(); i++) {
        bits2[i].setCharAt(bits.length-(j+1), bits[j].charAt(i));
      }
    }
    return combine(bits2);
  }

  String flip(String s) {
    String[] bits = s.split("/");
    StringBuffer[] bits2 = new StringBuffer[bits.length];
    for (int j=0; j<bits.length; j++)
      bits2[bits.length - (j + 1)] = new StringBuffer(bits[j]);
    return combine(bits2);
  }

  void parse(ArrayList<String> input) {
    rules.clear();
    lights.clear();
    for (int i=0; i<input.size(); i++) {
      String[] bits = input.get(i).split(" => ");
      rules.put(bits[0], bits[1]);
      int tot_light = bits[0].replaceAll("[./]", "").length();
      lights.put(bits[0], tot_light);
      for (int r = 0; r < 3; r++) {
        bits[0] = rot(bits[0]);
        rules.put(bits[0], bits[1]);
        lights.put(bits[0], tot_light);
      }
      bits[0] = flip(bits[0]);
      rules.put(bits[0], bits[1]);
      lights.put(bits[0], tot_light);
      for (int r=0; r<3; r++) {
        bits[0] = rot(bits[0]);
        rules.put(bits[0], bits[1]);
        lights.put(bits[0], tot_light);
      }
    }
    for (String v : rules.values()) {
      int tot_light = v.replaceAll("[./]", "").length();
      lights.put(v,  tot_light);
    }
  }

  void add_or_set(HashMap<String, Integer> H, String p, int c) {
    if (!H.containsKey(p)) H.put(p, c);
    else H.put(p, H.get(p) + c);
  }

  int count(HashMap<String, Integer> H) {
    int t=0;
    for (String p : H.keySet()) {
      int lig = lights.containsKey(p) ? lights.get(p) :
        p.replaceAll("[/.]", "").length();
      t += H.get(p) * lig;
    }

    return t;
  }

  // The alg is as follows...
  // Step 0: you have a 3x3.
  // Step 1: transform 3x3 into 4x4.
  // Step 2: split 4x4 into a grid of four 2x2s. Transform each to 3x3 - total size 6x6
  // Step 3: split 6x6 into a grid of 9 2x2s. Tranform each to 3x3 - total size 9x9
  //         split 9x9 into a grid of 9 3x3s. Call step 1 with each of them independently.

  int[] solve(boolean test) {
    int[] res = new int[2];
    HashMap<String, Integer> counts = new HashMap<String, Integer>();
    HashMap<String, Integer> next = new HashMap<String, Integer>();
    counts.put(".#./..#/###",  1);
    int turn = 0;
    while (turn < 18) {

      // Transform 3s into 4s

      for (String pat : counts.keySet()) add_or_set(next, rules.get(pat), counts.get(pat));

      counts.clear();
      for (String pat : next.keySet()) counts.put(pat, next.get(pat));
      next.clear();
      turn++;

      // Split 4s into 2s, transform into 3s, and split into 2s.

      for (String pat : counts.keySet()) {
        if (turn==16) {
          turn = 16;
        }
        int count = counts.get(pat);
        String n1 = rules.get(pat.substring(0,2)+"/"+pat.substring(5,7));
        String n2 = rules.get(pat.substring(2,4)+"/"+pat.substring(7,9));
        String n3 = rules.get(pat.substring(10,12)+"/"+pat.substring(15,17));
        String n4 = rules.get(pat.substring(12,14)+"/"+pat.substring(17,19));

        // n1  n2  01234567890        q1  q2  q3
        // n3  n4  123/456/789        q4  q5  q6  ...

        add_or_set(next, n1.substring(0, 2) + "/" + n1.substring(4, 6), count);
        add_or_set(next, n1.substring(2, 3) + n2.substring(0, 1) + "/" +
                         n1.substring(6, 7)  + n2.substring(4, 5), count);
        add_or_set(next, n2.substring(1, 3) + "/" + n2.substring(5, 7), count);
        add_or_set(next, n1.substring(8, 10) + "/" + n3.substring(0, 2), count);
        add_or_set(next, n1.substring(10, 11) + n2.substring(8, 9) + "/" +
                         n3.substring(2, 3) + n4.substring(0, 1), count);
        add_or_set(next, n2.substring(9, 11) + "/" + n4.substring(1, 3), count);
        add_or_set(next, n3.substring(4,6) + "/" + n3.substring(8, 10), count);
        add_or_set(next, n3.substring(6, 7) + n4.substring(4, 5) + "/" +
                         n3.substring(10, 11) + n4.substring(8, 9), count);
        add_or_set(next, n4.substring(5, 7) + "/" + n4.substring(9, 11), count);
      }
      turn++;
      if ((turn == 2) && (test)) {
        res[0] = count(next);
        return(res);
      } else if (turn == 5) res[0] = count(next);

      // Convert the 2s into 3s

      counts.clear();
      for (String p : next.keySet()) add_or_set(counts, rules.get(p), next.get(p));
      next.clear();
      turn++;
      if (turn == 18) {
        res[1] = count(counts);
        return(res);
      }
    }
    return res;
  }

  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    ArrayList<String> input = Utils.readLines("../inputs/input_21.txt");
    w.parse(input);
    int [] res = w.solve(false);
    System.out.println(res[0]);
    System.out.println(res[1]);
   }
}
