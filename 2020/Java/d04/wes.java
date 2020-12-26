package d04;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.HashMap;

public class wes {
  
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
  
  void stop_if_not(boolean res, boolean expec, String test) {
    stop_if_not(res?1:0, expec?1:0, test);
  }
  
  void run() throws Exception {
    System.out.println("Advent of Code 2020 - Day 04\n----------------------------");
    stop_if_not(solve(read_input("d04/test_part1_2.txt"), 1), 2, "Solve1");
    stop_if_not(int_between("2002", 4, 1920, 2002), true, "byr valid");
    stop_if_not(int_between("2003", 4, 1920, 2002), false, "byr invalid");
    stop_if_not(height_valid("60in"), true, "hgt valid 1");
    stop_if_not(height_valid("190cm"), true, "hgt valid 2");
    stop_if_not(height_valid("190in"), false, "hgt invalid 1");
    stop_if_not(height_valid("190"), false, "hgt invalid 2");
    stop_if_not(hair_valid("#123abc"), true, "hcl valid");
    stop_if_not(hair_valid("#123abz"), false, "hcl invalid 1");
    stop_if_not(hair_valid("123abc"), false, "hcl invalid 2");
    stop_if_not(eye_valid("brn"), true, "ecl valid");
    stop_if_not(eye_valid("wat"), false, "ecl invalid");
    stop_if_not(int_between("000000001", 9, 0, Integer.MAX_VALUE), true, "pid valid");
    stop_if_not(int_between("0123456789", 9, 0, Integer.MAX_VALUE), false, "pid invalid");
    stop_if_not(solve(read_input("d04/test_part2_4.txt"), 2), 4, "Solve 4 valid");
    stop_if_not(solve(read_input("d04/test_part2_0.txt"), 2), 0, "Solve 4 invalid");

    ArrayList<HashMap<String, String>> wes = read_input("d04/wes-input.txt");
    System.out.println("Part 1: "+solve(wes, 1));
    System.out.println("Part 2: "+solve(wes, 2));
  }
  
  public static void main(String[] args) throws Exception {
    new wes().run();
  }
}
