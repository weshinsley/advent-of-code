package d04;

import java.util.ArrayList;
import java.util.Collections;
import tools.WesUtils;

public class puzzle {
  ArrayList<Long> event_timestamp = new ArrayList<Long>();
  ArrayList<Integer> event_guard = new ArrayList<Integer>();
  ArrayList<Boolean> event_newshift = new ArrayList<Boolean>();
  
  ArrayList<Integer> guard_id = new ArrayList<Integer>();
  ArrayList<int[]> guard_minutes = new ArrayList<int[]>();
  ArrayList<Integer> guard_total_mins = new ArrayList<Integer>();
  
  void parseInput(ArrayList<String> input) {
    Collections.sort(input);

    for (int i=0; i<input.size(); i++) {
      String s = input.get(i);
      long timestamp = Long.parseLong(s.substring(1,5)+s.substring(6,8)+s.substring(9,11)
                                     +s.substring(12,14)+s.substring(15,17));
      int guard = -1;
      boolean new_shift = false;
      int hash = s.indexOf("#");
      if (hash >=0) {
        new_shift = true;
        guard = Integer.parseInt(s.substring(hash+1, s.indexOf(" ", hash)));
        if (guard_id.indexOf(guard) == -1) {
          guard_id.add(guard);
          guard_minutes.add(new int[60]);
          guard_total_mins.add(0);
        }
      }

      event_timestamp.add(timestamp);
      event_guard.add(guard);
      event_newshift.add(new_shift);
    }
  }

  public int advent4a() {
    int guard_index=-1;
    int i=0;
    int best_guard=-1;
    int best_total=-1;
    while (i<event_timestamp.size()) {
      if (event_newshift.get(i)) {
        guard_index = guard_id.indexOf(event_guard.get(i++));
        while ((i<event_timestamp.size()) && (!event_newshift.get(i))) {
          int time1 = (int) (event_timestamp.get(i++) % 100);
          int time2 = (int) (event_timestamp.get(i++) % 100);
          for (int j = time1; j < time2; j++) guard_minutes.get(guard_index)[j]++;
          int total = guard_total_mins.get(guard_index);
          total += (time2 - time1);
          guard_total_mins.set(guard_index, total);
          if (total > best_total) {
            best_total = total;
            best_guard = guard_index;
          }
        }
      }
    }

    int mfreq = guard_minutes.get(best_guard)[0];
    int mindex = 0;
    for (i = 1; i < 60; i++) {
      if (guard_minutes.get(best_guard)[i] > mfreq) { 
        mfreq = guard_minutes.get(best_guard)[i];
        mindex = i;
      }
    }
    return mindex * guard_id.get(best_guard);
  }

  int advent4b() {
    int best_min = -1;
    int best_guard = -1;
    int best = -1;
    for (int i = 0; i < guard_minutes.size(); i++) {
      for (int j = 0; j < 60; j++) {
        if (guard_minutes.get(i)[j] > best) {
          best = guard_minutes.get(i)[j];
          best_min = j;
          best_guard = guard_id.get(i);
        }
      }
    }
    return best_min * best_guard;
  }

  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.parseInput(WesUtils.readLines("../inputs/input_4.txt"));
    System.out.println(w.advent4a());
    System.out.println(w.advent4b());
  }
}
