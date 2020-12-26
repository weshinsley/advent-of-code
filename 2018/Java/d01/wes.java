package d01;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import tools.WesUtils;

public class wes {
  ArrayList<Integer> input;

  int advent1a() { return WesUtils.sum(input); }

  int advent1b() {
    Set<Integer> freqs = new HashSet<Integer>();
    int freq = 0, index = 0;
    while (true) {
      freq += input.get(index);
      if (freqs.contains(freq)) return freq;
      freqs.add(freq);
      index = (index + 1) % input.size();
    }
  }

  public static void main(String[] args) throws Exception {
    wes w = new wes();
    w.input = WesUtils.toIntArrayList(WesUtils.readLines("d01/wes-input.txt"));
    System.out.println(w.advent1a());
    System.out.println(w.advent1b());
  }
}
