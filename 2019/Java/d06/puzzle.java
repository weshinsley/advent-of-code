package d06;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;

public class puzzle {

  ArrayList<Thing> things;

  class Thing {
    String name;
    ArrayList<Thing> orbits;
    ArrayList<Thing> is_orbited_by;
    int visited_in = 0;

    Thing(String n) {
      name = new String(n);
      orbits = new ArrayList<Thing>();
      is_orbited_by = new ArrayList<Thing>();
      visited_in = Integer.MAX_VALUE;
    }

    int countOrbits() {
      int o = orbits.size();
      for (int i=0; i<orbits.size(); i++)
        o += orbits.get(i).countOrbits();
      return o;
    }
  }

  Thing findThing(String s) {
    for (int i=0; i<things.size(); i++) {
      if (things.get(i).name.equals(s)) {
        return things.get(i);
      }
    }
    Thing P = new Thing(s);
    things.add(P);
    return P;
  }

  void readInput(String f) throws Exception{
    things = new ArrayList<Thing>();
    BufferedReader br = new BufferedReader(new FileReader(f));
    String s = br.readLine();
    while (s!=null) {
      String[] bits = s.split("\\)"); // bits[1] orbits bits[0]
      Thing p1 = findThing(bits[1]);
      Thing p0 = findThing(bits[0]);
      p1.orbits.add(p0);
      p0.is_orbited_by.add(p1);
      s = br.readLine();
    }
    br.close();
  }

  int solve1() {
    int total=0;
    for (int i=0; i<things.size(); i++)
      total+=things.get(i).countOrbits();
    return total;
  }

  void consider(Thing potential, ArrayList<Thing> queue, int steps) {
    if ((steps + 1) < potential.visited_in) {
      potential.visited_in = steps + 1;
      queue.add(potential);
    }
  }

  int solve2() {
    ArrayList<Thing> queue = new ArrayList<Thing>();
    Thing thing_you_orbit = findThing("YOU").orbits.get(0);
    Thing thing_san_orbits = findThing("SAN").orbits.get(0);
    thing_you_orbit.visited_in = 0;
    queue.add(thing_you_orbit);
    while (queue.size()>0) {
      thing_you_orbit = queue.get(0);
      int steps = thing_you_orbit.visited_in;
      queue.remove(0);
      if (thing_you_orbit == thing_san_orbits) {
        return thing_you_orbit.visited_in;
      }

      for (int i=0; i<thing_you_orbit.orbits.size(); i++)
        consider(thing_you_orbit.orbits.get(i), queue, steps);

      for (int i=0; i<thing_you_orbit.is_orbited_by.size(); i++)
        consider(thing_you_orbit.is_orbited_by.get(i), queue, steps);

    }
    return -1;
  }

  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    W.readInput("../inputs/input_6.txt");
    System.out.println("Part 1: "+W.solve1());
    System.out.println("Part 2: "+W.solve2());
  }
}
