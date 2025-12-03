package d07;

import java.util.ArrayList;
import java.util.Collections;

import tools.WesUtils;

public class puzzle {
  
  boolean[] done = new boolean[26];
  StringBuilder[] required = new StringBuilder[26];

  void parseInput(ArrayList<String> txt) {
    for (int i = 0; i < 26; i++) {
      required[i] = new StringBuilder();
      done[i] = true;
    }
    for (int i=0; i<txt.size(); i++) {
      String s = txt.get(i);
      required[(int)(s.charAt(36) - 65)].append(s.charAt(5));
      done[(int)(s.charAt(5)) - 65]=false;
      done[(int)(s.charAt(36)) - 65]=false;
    }
  }

  public String advent7a() {
    StringBuilder res = new StringBuilder();
    boolean work_to_do = true;
    while (work_to_do) {
      work_to_do = false;
      int i = 0;
      while ((i < 26) && ((done[i]) || (required[i].length() > 0))) i++;
      
      if (i < 26) {
        char dothis = (char)(65 + i);
        done[i] = true;
        res.append(dothis);
        for (int j = 0; j < 26; j++) {
          int k = required[j].indexOf(String.valueOf(dothis));
          if (k>=0) required[j].deleteCharAt(k);
        }
        work_to_do = true;
      }
    }
    return res.toString();
  }

  public int advent7b() {
    ArrayList<Integer> end_time = new ArrayList<Integer>();
    StringBuilder in_progress = new StringBuilder();
    int max_workers = 5;
    int time = 0;
    while (true) {

      while (in_progress.length() < max_workers) {
        int i=0;
        while ((i < 26) && ((required[i].length()!=0) || (done[i]))) i++;
        if (i>=26) break;
        done[i] = true;
        in_progress.append((char)(i+65));
        end_time.add(61 +i);
      }

      int elapsed = Collections.min(end_time);
      for (int i=0; i<end_time.size(); i++) end_time.set(i, end_time.get(i) - elapsed);
      time += elapsed;
      for (int i=0; i<end_time.size(); i++) {
        if (end_time.get(i)==0) {
          for (int j=0; j<26; j++) 
            if (required[j].indexOf(""+in_progress.charAt(i))>=0) 
              required[j].deleteCharAt(required[j].indexOf(""+in_progress.charAt(i)));
          in_progress.deleteCharAt(i);
          end_time.remove(i);
          break;
        }
      }

      boolean any_work = false;
      for (int i=0; i<done.length; i++)
        if (!done[i]) { any_work = true; break; }

      if ((!any_work) && (end_time.size()==0)) break;
    }
    return time;
  }

  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.parseInput(WesUtils.readLines("../inputs/input_7.txt"));
    System.out.println(w.advent7a());
    w.parseInput(WesUtils.readLines("../inputs/input_7.txt"));
    System.out.println(w.advent7b());
  }
}
