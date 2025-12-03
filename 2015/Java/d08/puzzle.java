package d08;

import java.util.ArrayList;

import tools.Utils;

public class puzzle {
  
  static String strip(String s) {
    while (s.indexOf("\\\\")>=0) {
      s = s.substring(0,s.indexOf("\\\\")) + "0" + s.substring(s.indexOf("\\\\")+2);  
    }
    while (s.indexOf("\\\"")>=0) {
      s = s.substring(0,s.indexOf("\\\"")) + "0" + s.substring(s.indexOf("\\\"")+2);  
    }
    while (s.indexOf("\\x")>=0) {
      s = s.substring(0,s.indexOf("\\x")) + "0" + s.substring(s.indexOf("\\x")+4);
    }
    
    return s;
  }
  
  static int advent8a(ArrayList<String> input) {
    int diff = 0;
    for (int i=0; i<input.size(); i++) {
      diff += 2+(input.get(i).length() - strip(input.get(i)).length());
    }
    return diff;
  }
  

  static int advent8b(ArrayList<String> input) {
    int diff = 0;
    for (int i=0; i<input.size(); i++) {
      String s = input.get(i);
      diff += 2;
      for (int j=0; j<s.length(); j++) {
        if ((s.charAt(j)=='"') || (s.charAt(j)=='\\')) diff++;
      }
    }
    return diff;
  }
  
  public static void main(String[] args) throws Exception {
    ArrayList<String> input = Utils.readLines("../inputs/input_8.txt");
    System.out.println(advent8a(input));
    System.out.println(advent8b(input));
  }
}
