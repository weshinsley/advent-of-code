package d24;

import java.util.ArrayList;
import java.util.Collections;

import tools.Utils;



public class puzzle {
  ArrayList<Integer> input;
    
  void explore(ArrayList<Integer> pool, ArrayList<Integer> candidate, int group_size, int target, int sum, int count,
      ArrayList<ArrayList<Integer>> candidates) {
    for (int i=0; i<pool.size(); i++) {
      Integer ii = pool.get(i);
      if (sum + ii == target) {
        candidate.add(ii);
        candidates.add(new ArrayList<Integer>(candidate));
        candidate.remove(ii);
      } else if ((sum + ii < target) && (count < group_size)) {
        pool.remove(ii);
        candidate.add(ii);
        explore(pool, candidate, group_size, target, sum + ii, count + 1, candidates);
        pool.add(i,ii);
        candidate.remove(ii);
      } else if ((sum + ii < target) && (count == group_size)) break;
    }
  }
  
  boolean explore_any(ArrayList<Integer> pool, int target, boolean extra) {
    int[] power = new int[pool.size()];
    int max = (int) Math.pow(2, pool.size());
    for (int i=0; i<power.length; i++) power[i] = (int) Math.pow(2, i);
    for (int i=0; i<max; i++) {
      int sum=0;
      for (int j=0; j<power.length; j++) {
        if ((i & power[j])>0) sum+=pool.get(j);
        if (sum>target) break;
      }
      if (sum==target) {
        if (!extra) return true;
        else {
          ArrayList<Integer> new_pool = new ArrayList<Integer>();
          for (int j=0; j<power.length; j++) 
            if ((i & power[j])==0) new_pool.add(pool.get(j));
          return explore_any(new_pool, target, false);
        }
      }
    }
    return false;
  }
  
  void ensure(ArrayList<Integer> pool, ArrayList<ArrayList<Integer>> cands, int target, boolean extra_step) {
    int i=0;
    while (i<cands.size()) {
      ArrayList<Integer> cand = cands.get(i);
      for (int j=0; j<cand.size(); j++) pool.remove(cand.get(j));
      boolean found = explore_any(pool, target, extra_step);
      for (int j=0; j<cand.size(); j++) pool.add(cand.get(j));
      Collections.sort(pool);
      Collections.reverse(pool);
      if (found) i++;
      else cands.remove(i);
    }
  }
    
  long qe_best(ArrayList<ArrayList<Integer>> cands) {
    long qe_best = Utils.product(Utils.toLongArray(cands.get(0)));
    for (int i=1; i<cands.size(); i++) {
      long qe = Utils.product(Utils.toLongArray(cands.get(i)));
      if (qe < qe_best) qe_best = qe;
    }
    return qe_best;
  }
  
  long advent24(int n_groups) {
    Collections.sort(input);
    Collections.reverse(input);
    int target = Utils.sum(input)/n_groups;    
    int small_group=1;
    int cumul=input.get(small_group - 1);
    
    while (cumul<target) {
      small_group++;
      cumul+=input.get(small_group - 1);
    }
    
    ArrayList<ArrayList<Integer>> candidates_small = new ArrayList<ArrayList<Integer>>();
    while (true) {
      explore(input, new ArrayList<Integer>(), small_group, target, 0, 0, candidates_small);
      ensure(input, candidates_small, target, n_groups == 4);
      if (candidates_small.size()>0) return qe_best(candidates_small);
      small_group++;
    }   
  }
  
  public static void main(String[] args) throws Exception {
    puzzle p = new puzzle();
    p.input = Utils.toIntArrayList(Utils.readLines("../inputs/input_24.txt"));
    System.out.println(p.advent24(3));
    System.out.println(p.advent24(4));
  }
}
