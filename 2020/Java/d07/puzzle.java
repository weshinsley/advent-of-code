package d07;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;

public class puzzle {
  ArrayList<Bag> all_bags = new ArrayList<Bag>();
  ArrayList<String> bag_names = new ArrayList<String>();
  
  class Bag {
    String name;
    ArrayList<Bag> contents;
    ArrayList<Integer> count;
    
    Bag(String s) {
      contents = new ArrayList<Bag>();
      count = new ArrayList<Integer>();
      name = new String(s);
    }
    
    void add_can_contain(Bag b, int n) {
      contents.add(b);
      count.add(n);
    }
    
    boolean recursive_contains(Bag b) {
      if (contents.contains(b)) return true;
      else for (int i=0; i<contents.size(); i++) {
        if (contents.get(i).recursive_contains(b)) return true;
      }
      return false;
    }
    
    int recursive_counts() {
      int c = 0;
      for (int i=0; i<contents.size(); i++) {
        c += count.get(i) + (count.get(i) * contents.get(i).recursive_counts());
      }
      return c;
    }
  }
  
  Bag find_bag(String b) {
    int i = bag_names.indexOf(b);
    if (i == -1) {
      bag_names.add(b);
      all_bags.add(new Bag(b));
      i = bag_names.size()-1;
    }
    return all_bags.get(i);
  }
  
  void parse_manky_input(String f) throws Exception {
    all_bags.clear();
    bag_names.clear();
    BufferedReader br = new BufferedReader(new FileReader(f));
    String s = br.readLine();
    while (s!=null) {
      String[] bits = s.split(" bags contain ");
      Bag b = find_bag(bits[0]);
      String[] bits2 = bits[1].split(", ");
      if (!bits2[0].startsWith("no")) {
        for (int i=0; i<bits2.length; i++) {
          String num = bits2[i].substring(0, bits2[i].indexOf(" "));
          int count = Integer.parseInt(num);
          bits2[i] = bits2[i].substring(bits2[i].indexOf(" ") + 1);
          String col = bits2[i].substring(0, bits2[i].indexOf(" "))+" ";
          bits2[i] = bits2[i].substring(bits2[i].indexOf(" ") + 1);
          col += bits2[i].substring(0, bits2[i].indexOf(" "));
          Bag b2 = find_bag(col);
          b.add_can_contain(b2, count);
        }
      }
           
      s = br.readLine();
    }
    br.close();
  }
  
  int solve(int part) {
    int r=0;
    Bag target = find_bag("shiny gold");
    for (int i=0; i<all_bags.size(); i++) {
      if (part == 1) {
        if (all_bags.get(i).recursive_contains(target)) r++;
      } else {
        return target.recursive_counts();
      }
    }
    return r;
  }
     
  void run() throws Exception {
    System.out.println("Advent of Code 2020 - Day 07\n----------------------------");
    parse_manky_input("../inputs/input_7.txt");
    System.out.println("Part 1: "+solve(1));
    System.out.println("Part 2: "+solve(2));
  }
  
  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
