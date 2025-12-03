package d22;

import java.io.File;
import java.nio.file.Files;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;

public class puzzle {
  
  long solve(String f, boolean part2) throws Exception {
    LinkedList<Integer> p1_orig = new LinkedList<Integer>();
    LinkedList<Integer> p2_orig = new LinkedList<Integer>();
    List<String> lines = Files.readAllLines(new File(f).toPath());
    int i=1;
    int p=1;
    while (i<lines.size()) {
      String s = lines.get(i++);
      if ((s.equals("")) || (s.startsWith("P"))) p = 2; 
      else {
        if (p == 1) p1_orig.add(Integer.parseInt(s));
        else p2_orig.add(Integer.parseInt(s));
      }
    }
    return part2 ? solve2(p1_orig, p2_orig, 1) : solve1(p1_orig, p2_orig);
  }
    
  long result(LinkedList<Integer> x) {
    long sum = 0;
    for (int i = 0; i<x.size(); i++)
      sum += (x.get(i) * (x.size() - i));
    return sum;
  }
  
  void do_play(long winner, LinkedList<Integer> player1, LinkedList<Integer> player2, int p1, int p2) {
    if (winner == 1) {
      player1.add(p1);
      player1.add(p2);
    } else {
      player2.add(p2);
      player2.add(p1);
    }
  }

  long solve1(LinkedList<Integer> player1, LinkedList<Integer> player2) {
    while ((player1.size() > 0) && (player2.size() > 0)) {
      int p1 = player1.removeFirst();
      int p2 = player2.removeFirst();
      do_play((p1 > p2) ? 1 : 2, player1, player2, p1, p2);
    }
    return result((player1.size()==0) ? player2 : player1);
  }
  
  String getState(LinkedList<Integer> p1, LinkedList<Integer> p2) {
    StringBuffer sb = new StringBuffer();
    for (int i=0; i<p1.size(); i++) sb.append(""+(char)(33 + p1.get(i)));
    sb.append(" ");
    for (int i=0; i<p2.size(); i++) sb.append(""+(char)(33 + p2.get(i)));
    return sb.toString();
  }
  
  LinkedList<Integer> clonePart(LinkedList<Integer> x, int count) {
    LinkedList<Integer> result = new LinkedList<Integer>();
    for (int i=0; i<count; i++) result.add(x.get(i));
    return result;
  }
  
  long solve2(LinkedList<Integer> player1, LinkedList<Integer> player2, int game) {
    HashSet<String> memory = new HashSet<String>();
    long winner = -1;
    while (true) {
      String state = getState(player1, player2);
      if (memory.contains(state)) return 1;
      else {
        memory.add(state);
        int p1 = player1.removeFirst();
        int p2 = player2.removeFirst();
        if ((player1.size() >= p1) && (player2.size() >= p2)) {
          winner = solve2(clonePart(player1, p1), clonePart(player2, p2), game + 1);
        } else {
          winner = (p1 > p2) ? 1 : 2;
        }
        do_play(winner, player1, player2, p1, p2);
        if ((player1.size() == 0) || (player2.size() == 0))
          return (game>1) ? winner : (result(player1.size() == 0 ? player2 : player1));
      }
    }
  }
  
  void run() throws Exception {
    System.out.println("Advent of Code 2020 - Day 22\n----------------------------");
    System.out.println("Part 1: "+solve("../inputs/input_22.txt", false));
    System.out.println("Part 2: "+solve("../inputs/input_22.txt", true));
  }

  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
