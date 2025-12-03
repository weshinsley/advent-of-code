package d12;
import java.util.ArrayList;
import java.util.HashSet;

import tools.Utils;

public class puzzle {

  public int[][] parse(ArrayList<String> input) {
    int[][] network = new int[input.size()][];
    for (int i=0; i<input.size(); i++) {
      String[] s = input.get(i).replaceAll(" ",  "").split("<->");
      String[] links = s[1].split(",");
      network[i] = new int[links.length];
      for (int j=0; j<links.length; j++) network[i][j] = Integer.parseInt(links[j]);
    }
    return network;
  }

  public HashSet<Integer> part1(int[][] network, int root) {
    HashSet<Integer> hs = new HashSet<Integer>();
    ArrayList<Integer> queue = new ArrayList<Integer>();
    queue.add(root);
    while (queue.size() > 0) {
      int head = queue.remove(0);
      if (!hs.contains(head)) {
        hs.add(head);
        for (int i=0; i<network[head].length; i++) {
          queue.add(network[head][i]);
        }
      }
    }
    return hs;
  }

  public int part2(int[][] network) {
    HashSet<Integer> all = new HashSet<Integer>();
    for (int i=0; i<network.length; i++) all.add(i);
    int groups = 0;
    while (all.size() > 0) {
      HashSet<Integer> remove = part1(network, all.iterator().next());
      groups++;
      all.removeAll(remove);
    }
    return groups;
  }

  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    int[][] network = w.parse(Utils.readLines("../inputs/input_12.txt"));
    System.out.println(w.part1(network, 0).size());
    System.out.println(w.part2(network));
  }
}
