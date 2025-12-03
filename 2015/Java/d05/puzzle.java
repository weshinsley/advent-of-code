package d05;

import java.util.ArrayList;
import tools.Utils;

public class puzzle {
  
  public static boolean isNice1(String s) {
    if (s.indexOf("ab") >= 0) return false;
    if (s.indexOf("cd") >= 0) return false;
    if (s.indexOf("pq") >= 0) return false;
    if (s.indexOf("xy") >= 0) return false;
    boolean double_letter = false;    
    for (int i = 0; i<s.length() - 1; i++) {
      if (s.charAt(i) == s.charAt(i + 1)) {
        double_letter = true;
        break;
      }
    }
    if (!double_letter) return false;
    int vowel = 0;
    for (int i=0; i<s.length(); i++) {
      if ("aeiou".indexOf(s.charAt(i))>=0) {
        vowel++;
        if (vowel==3) break;
      }
    }
    return (vowel==3);
  }
  
  public static int advent5a(ArrayList<String> words) {
    int nice = 0;
    for (int i = 0; i < words.size(); i++) {
      if (isNice1(words.get(i))) nice = nice + 1;
    }
    return nice;
  }
  
  public static boolean isNice2(String s) {
    boolean nice1 = false;
    boolean nice2 = false;
    for (int i = 0; i < s.length() - 2; i++) {
      if (s.charAt(i) == s.charAt(i + 2)) {
        nice1 = true;
        if (nice1 && nice2) return true;
      }
      for (int j = i + 2; j < s.length() - 1; j++) {
        if ((s.charAt(i) == s.charAt(j)) &&
            (s.charAt(i + 1) == s.charAt(j + 1))) {
          nice2 = true;
          if (nice1 && nice2) return true;
        }
      }
    }
    return false;
  }
  
  public static int advent5b(ArrayList<String> words) {
    int nice = 0;
    for (int i = 0; i < words.size(); i++) {
      if (isNice2(words.get(i))) nice = nice + 1;
    }
    return nice;
  }
  
  public static void main(String[] args) throws Exception {
    ArrayList<String> words = Utils.readLines("../inputs/input_5.txt");
    
    Utils.test(isNice1("ugknbfddgicrmopn"), true);
    Utils.test(isNice1("aaa"), true);
    Utils.test(isNice1("jchzalrnumimnmhp"), false);
    Utils.test(isNice1("haegwjzuvuyypxyu"), false);
    Utils.test(isNice1("dvszwmarrgswjxmb"), false);
    System.out.println(advent5a(words));
    Utils.test(isNice2("qjhvhtzxzqqjkmpb"), true);
    Utils.test(isNice2("xxyxx"), true);
    Utils.test(isNice2("uurcxstgmygtbstg"), false);
    Utils.test(isNice2("ieodomkazucvgmuy"), false);
    System.out.println(advent5b(words));
  
  }
}
