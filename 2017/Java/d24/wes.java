package d24;

import java.util.ArrayList;
import java.util.HashSet;

import tools.Utils;

public class wes {

  class Thing {
    int a;
    int b;
    Thing(int x, int y) { a = x; b = y; }
    boolean match(int x) { return ((a == x) || (b == x)); }
  }

  HashSet<Thing> parse(ArrayList<String> input) {
    HashSet<Thing> spares = new HashSet<Thing>();
    for (int i=0; i<input.size(); i++) {
      String[] s = input.get(i).split("/");
      spares.add(new Thing(Integer.parseInt(s[0]), Integer.parseInt(s[1])));
    }
    return spares;
  }

  int best_strength = 0;
  int longest = 0;
  int best_longest = 0;

  void recurse(int match_me, HashSet<Thing> spares, int strength, int length) {
    best_strength = Math.max(best_strength, strength);
    if ((length > longest) || ((length == longest) && (strength > best_longest))) {
      longest = length;
      best_longest = strength;
    }
    HashSet<Thing> new_options = new HashSet<Thing>();
    HashSet<Thing> options = new HashSet<Thing>();
    for (Thing t : spares) {
      new_options.add(t);
      if ((t.a == match_me) || (t.b == match_me)) {
        options.add(t);
      }
    }
    for (Thing t : options) {
      int next = (t.a == match_me) ? t.b : t.a;
      new_options.remove(t);
      recurse(next, new_options, strength + t.a + t.b, length + 1);
      new_options.add(t);
    }
  }

  int[] solve(ArrayList<String> input) {
    HashSet<Thing> spares = parse(input);
    recurse(0, spares, 0, 0);
    return new int[] {best_strength, best_longest};
  }
  void test() throws Exception {
    ArrayList<String> input = Utils.readLines("../R/example.txt");
    int[] res = solve(input);
    Utils.test(res[0],  31);
    Utils.test(res[1],  19);
  }

  public static void main(String[] args) throws Exception {
    wes w = new wes();
    ArrayList<String> input = Utils.readLines("../R/24/input.txt");
    int[] res = w.solve(input);
    System.out.println(res[0]);
    System.out.println(res[1]);
  }
}
