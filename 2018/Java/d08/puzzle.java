package d08;

import tools.WesUtils;

public class puzzle {
  int[] input;
  int pointer;
  Node tree;
  
  class Node {
    Node[] children;
    int[] metadata;
    
    Node(int nc, int nm) {
      children = new Node[nc];
      metadata = new int[nm];
    }
  }
  
  Node parseNode() {
    int no_child_nodes = input[pointer++];
    int no_metadata = input[pointer++];
    Node t = new Node(no_child_nodes, no_metadata);
    for (int i = 0; i < no_child_nodes; i++) t.children[i] = parseNode();
    for (int i = 0; i < no_metadata; i++) t.metadata[i] = input[pointer++];
    return t;
  }
  
  void parseInput(String s) {
    String[] nums = s.split("\\s+");
    input = new int[nums.length];
    for (int i = 0; i < nums.length; i++) input[i] = Integer.parseInt(nums[i]);
    pointer = 0;
    tree = parseNode();
  }
  
  int advent8a(Node t) {
    int total = WesUtils.sum(t.metadata);
    for (int i = 0; i < t.children.length; i++) total += advent8a(t.children[i]);
    return total;
  }
  
  int advent8b(Node t) {
    int total = 0;
    if (t.children.length == 0) total = WesUtils.sum(t.metadata);
    else for (int i = 0; i < t.metadata.length; i++)
      if (t.metadata[i] <= t.children.length) total += advent8b(t.children[t.metadata[i] - 1]);
    return total;
  }
  
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.parseInput(WesUtils.readLines("../inputs/input_8.txt").get(0));
    w.pointer = 0;
    System.out.println(w.advent8a(w.tree));
    System.out.println(w.advent8b(w.tree));
  }
  
}
