package d19;

import java.io.File;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class puzzle {

  Object[][][] rules = null;
  ArrayList<String> targets = new ArrayList<String>();

  Object toObject(String s) {
    if (s.contains("\"")) return s.charAt(1);
    else return Integer.parseInt(s);
  }

  void read_input(String f) throws Exception {
    rules = null;
    targets.clear();
    List<String> d = Files.readAllLines(new File(f).toPath());
    int max_rule = -1;
    int no_rules = 0;
    for (int i=0; i<d.size(); i++) {
      String s = d.get(i);
      if (s.equals("")) break;
      no_rules++;
      max_rule = Math.max(max_rule, 1+ Integer.parseInt(s.substring(0, s.indexOf(":"))));
    }
 
    rules = new Object[max_rule][][];
    for (int i=0; i<no_rules; i++) {
      String[] bits = d.get(i).split("\\s+");
      int rule_no = Integer.parseInt(bits[0].substring(0, bits[0].indexOf(":")));
      int pipe=-1;
      for (int j = 0; j<bits.length; j++)
        if (bits[j].equals("|")) pipe = j;

      if (pipe != -1) {
        rules[rule_no] = new Object[2][];
        rules[rule_no][0] = new Object[pipe - 1];
        rules[rule_no][1] = new Object[bits.length - (pipe + 1)];
      }
      else {
        rules[rule_no] = new Object[1][];
        rules[rule_no][0] = new Object[bits.length - 1];
      }

      int opt_no=0;
      int index=0;
      for (int j = 1; j < bits.length; j++) {
        if (bits[j].equals("|")) {
          opt_no++;
          index=0;
        } else {
          rules[rule_no][opt_no][index] = toObject(bits[j]);
          index++;
        }
      }
    }

    for (int i=no_rules+1; i<d.size(); i++)
      targets.add(d.get(i));

  }

  boolean is_valid(StringBuffer target, LinkedList<Object> queue) {
    if (queue.size() > target.length()) return false;
    else if ((queue.size() == 0) && (target.length() == 0)) return true;
    else if ((queue.size() == 0) || (target.length() == 0)) return false;

    LinkedList<Object> new_queue = new LinkedList<Object>();
    for (int i=0; i<queue.size(); i++)
      new_queue.addLast(queue.get(i));

    Object head = new_queue.removeFirst();
    if (head instanceof Character) {
      if (target.charAt(0) == ((Character) head).charValue())
        return is_valid(new StringBuffer(target.substring(1)), new_queue);

    } else {
      int rule = ((Integer) head).intValue();
      for (int opt = 0; opt < rules[rule].length; opt++) {
        for (int el = rules[rule][opt].length- 1; el >= 0; el--)
          new_queue.addFirst(rules[rule][opt][el]);
        if (is_valid(target, new_queue)) return true;
        for (int el = rules[rule][opt].length - 1; el>=0; el--)
          new_queue.removeFirst();
      }
    }
    return false;
  }

  int solve(String f, boolean part2) throws Exception {
    read_input(f);
    if (part2) {
      rules[8] = new Object[][] {{42}, {42, 8}};
      rules[11] = new Object[][] {{42, 31}, {42, 11, 31}};
    }

    LinkedList<Object> queue = new LinkedList<Object>();
    queue.add(0);
    int hit=0;
    for (int i=0; i<targets.size(); i++)
      if (is_valid(new StringBuffer(targets.get(i)), queue)) hit++;

    return hit;
  }

  void run() throws Exception {
    System.out.println("Advent of Code 2020 - Day 19\n----------------------------");
    System.out.println("Part 1: "+solve("../inputs/input_19.txt", false));
    System.out.println("Part 2: "+solve("../inputs/input_19.txt", true));
  }

  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
