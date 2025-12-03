package d16;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;

public class puzzle {

  ArrayList<String> fields = new ArrayList<String>();
  ArrayList<Integer> min1 = new ArrayList<Integer>();
  ArrayList<Integer> max1 = new ArrayList<Integer>();
  ArrayList<Integer> min2 = new ArrayList<Integer>();
  ArrayList<Integer> max2 = new ArrayList<Integer>();

  ArrayList<Integer> your_ticket = new ArrayList<Integer>();
  ArrayList<ArrayList<Integer>> other_tickets = new ArrayList<ArrayList<Integer>>();

  void parse(String f) throws Exception {
    fields.clear();
    min1.clear();
    max1.clear();
    min2.clear();
    max2.clear();
    BufferedReader br = new BufferedReader(new FileReader(f));
    String s = br.readLine();
    while (s.length() > 0) {
      String[] bits = s.split(":");
      fields.add(bits[0]);
      bits = bits[1].split(" ");
      String[] m1 = bits[1].split("-");
      String[] m2 = bits[3].split("-");
      min1.add(Integer.parseInt(m1[0]));
      max1.add(Integer.parseInt(m1[1]));
      min2.add(Integer.parseInt(m2[0]));
      max2.add(Integer.parseInt(m2[1]));
      s = br.readLine();
    }
    s = br.readLine();
    s = br.readLine();
    your_ticket.clear();
    String[] bits = s.split(",");
    for (int i = 0; i < bits.length; i++)
      your_ticket.add(Integer.parseInt(bits[i]));
    s = br.readLine();
    s = br.readLine();
    s = br.readLine();
    other_tickets.clear();
    while (s != null) {
      ArrayList<Integer> next = new ArrayList<Integer>();
      bits = s.split(",");
      for (int i = 0; i < bits.length; i++)
        next.add(Integer.parseInt(bits[i]));
      other_tickets.add(next);
      s = br.readLine();
    }
    br.close();
  }

  long solve1() {
    int rate = 0;
    for (int i = 0; i < other_tickets.size(); i++) {
      boolean found = false;
      ArrayList<Integer> t = other_tickets.get(i);
      for (int j = 0; j < t.size(); j++) {
        int v = t.get(j);
        for (int k = 0; k < fields.size(); k++) {
          found = ((v >= min1.get(k) && (v <= max1.get(k))) || ((v >= min2.get(k) && (v <= max2.get(k)))));
          if (found)
            break;
        }
        if (!found) {
          other_tickets.set(i, null);
          rate += v;
        }
      }
    }

    for (int j = other_tickets.size() - 1; j >= 0; j--)
      if (other_tickets.get(j) == null)
        other_tickets.remove(j);

    return rate;
  }

  long solve2() {
    ArrayList<ArrayList<Integer>> all_options = new ArrayList<ArrayList<Integer>>();

    for (int f = 0; f < fields.size(); f++) {
      ArrayList<Integer> options = new ArrayList<Integer>();
      for (int c = 0; c < fields.size(); c++)
        options.add(c);
      all_options.add(options);
    }

    for (int f = 0; f < fields.size(); f++) { // f is the field I consider
      for (int c = 0; c < fields.size(); c++) { // c is the column in the grid
        boolean possible = true;
        for (int t = 0; t < other_tickets.size(); t++) { // t is each ticket
          int v = other_tickets.get(t).get(c);
          possible = ((v >= min1.get(f) && (v <= max1.get(f))) || ((v >= min2.get(f) && (v <= max2.get(f)))));
          if (!possible)
            break;
        }
        if (!possible)
          all_options.get(f).remove(all_options.get(f).indexOf(c));
      }
    }

    // If there's only one possible column for this field...
    // Then no other fields can be that column.
    boolean keep_going = true;
    while (keep_going) {
      keep_going = false;
      for (int f = 0; f < fields.size(); f++) {
        if (all_options.get(f).size() == 1) {
          int c = all_options.get(f).get(0);
          for (int f2 = 0; f2 < fields.size(); f2++) {
            if ((f != f2) && (all_options.get(f2).contains(c))) {
              all_options.get(f2).remove(all_options.get(f2).indexOf(c));
            }
          }
        } else keep_going = true;
      }
    }
    long prod = 1;
    for (int i = 0; i < fields.size(); i++) {
      if (fields.get(i).startsWith("departure")) {
        prod *= your_ticket.get(all_options.get(i).get(0));
      }
    }
    return prod;
  }

  void run() throws Exception {
    parse("../inputs/input_16.txt");
    System.out.println("Advent of Code 2020 - Day 16\n----------------------------");
    System.out.println("Part 1: " + solve1());
    System.out.println("Part 2: " + solve2());
  }

  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
