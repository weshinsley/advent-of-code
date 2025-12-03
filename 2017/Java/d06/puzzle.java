package d06;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.stream.Collectors;

import tools.Utils;

public class puzzle {

  String compress(List<Integer> input) {
    StringBuffer sb = new StringBuffer(input.get(0));
    for (int i=1; i<input.size(); i++) sb.append(","+input.get(i));
    return sb.toString();
  }
  
  void redist(List<Integer> d) {
    int best_index = 0;
    int best_val = d.get(0);
    for (int i = 1; i < d.size(); i++) {
      if (d.get(i) > best_val) {
        best_val = d.get(i);
        best_index = i;
      }
    }
    int i = best_index;
    d.set(i,  0);
    while (best_val > 0) {
      i = (i + 1) % d.size();
      d.set(i, 1 + d.get(i));
      best_val--;
    }
  }
  
  public int[] solve(List<Integer> input) {
    HashSet<String> visited = new HashSet<String>();
    String compressed = compress(input);
    int res1 = 0;
    while (!visited.contains(compressed)) {
      res1++;
      visited.add(compressed);
      redist(input);
      compressed = compress(input); 
    }
    String remember = compressed;
    redist(input);
    compressed = compress(input);
    int res2 = 1;
    while (!remember.equals(compressed)) {
      redist(input);
      compressed = compress(input);
      res2++;
    }
    return new int[] {res1, res2};
  }

  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    List<Integer> input = Arrays.stream(Utils.readIntGrid_ji("../inputs/input_6.txt", "\\s+")[0]).boxed().collect(Collectors.toList());
    int[] res = w.solve(input);
    System.out.println(res[0]);
    System.out.println(res[1]);
  }
}
