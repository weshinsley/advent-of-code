package d04;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.HashMap;

public class puzzle {
  
  ArrayList<HashMap<String, String>> read_input(String f) throws Exception {
    ArrayList<HashMap<String, String>> ah = new ArrayList<HashMap<String, String>>();
    BufferedReader br = new BufferedReader(new FileReader(f));
    String s = br.readLine();
    HashMap<String, String> pass = new HashMap<String, String>();
    while (s != null) {
      if (s.equals("")) {
        ah.add(pass);
        pass = new HashMap<String, String>();
      } else {
        String[] bits = s.split("\\s+");
        for (int i=0; i<bits.length; i++) {
          String[] bits2 = bits[i].split(":");
          pass.put(bits2[0],  bits2[1]);
        } 
      }
      s = br.readLine();
    }
    if (pass.size() > 0) ah.add(pass);
    br.close();
    return ah;
  }
  
  boolean int_between(String s, int len, int min, int max) {
    if (s.length() != len) return false;
    try {
      int i = Integer.parseInt(s);
      if ((i < min) || (i > max)) return false;
      return true;
    } catch (Exception e) {}
    return false;
  }
  
  boolean height_valid(String s) {
    if (s.endsWith("cm")) {
      return int_between(s.substring(0, s.length()-2), 3, 150, 193);
    } else if (s.endsWith("in")) {
      return int_between(s.substring(0, s.length()-2), 2, 59, 76);
    } else return false;
  }
  
  boolean hair_valid(String s) {
    return s.matches("[#]{1}[a-f0-9]{6}");
  }
  
  boolean eye_valid(String s) {
    return (s.matches("amb|blu|brn|gry|grn|hzl|oth"));
  }
  
  boolean valid(HashMap<String, String> h, int part) {
    if ((!h.containsKey("byr")) || (!h.containsKey("iyr")) || (!h.containsKey("eyr")) ||
        (!h.containsKey("hgt")) || (!h.containsKey("hcl")) || (!h.containsKey("ecl")) ||
        (!h.containsKey("pid"))) return false;
    if (part == 1) return true;
    
    return ((int_between(h.get("byr"), 4, 1920, 2002)) &&
            (int_between(h.get("iyr"), 4, 2010, 2020)) &&
            (int_between(h.get("eyr"), 4, 2020, 2030)) &&
            (int_between(h.get("pid"), 9, 0, Integer.MAX_VALUE)) &&
            (height_valid(h.get("hgt"))) &&
            (hair_valid(h.get("hcl"))) &&
            (eye_valid(h.get("ecl"))));
  }

  int solve(ArrayList<HashMap<String, String>> d, int part) {
    int v = 0;
    for (int i = 0; i < d.size(); i++) {
      if (valid(d.get(i), part)) v++;
    }
    return v;
  }
    
  void stop_if_not(long res, long expec, String test) {
    if (res != expec) {
      System.out.println("Test "+test+" failure - expected "+expec+", got "+res);
      System.exit(-1);
    }
  }
  
  void run() throws Exception {
    System.out.println("Advent of Code 2020 - Day 04\n----------------------------");
    ArrayList<HashMap<String, String>> wes = read_input("../inputs/input_4.txt");
    System.out.println("Part 1: "+solve(wes, 1));
    System.out.println("Part 2: "+solve(wes, 2));
  }
  
  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
