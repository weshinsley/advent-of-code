package d09;

import java.util.ArrayList;

import tools.Utils;

public class puzzle {
  ArrayList<String> input;
  
  class Place {
    int visited = 0;
    ArrayList<Place> links = new ArrayList<Place>();
    ArrayList<Integer> distances = new ArrayList<Integer>();
    String name;
    Place(String n) {
      name = n;
    };
    void addLink(Place p, int dist) {
      links.add(p);
      distances.add(dist);
    }
  }
  
  ArrayList<Place> places = new ArrayList<Place>();
  
  Place getPlace(String s) {
    for (int i=0; i<places.size(); i++) {
      if (places.get(i).name.equals(s)) return places.get(i);
    }
    Place p = new Place(s);
    places.add(p);
    return p;
  }
  
  void makeTree() {
    for (int i=0; i<input.size(); i++) {
      String[] bits = input.get(i).split("\\s+");
      Place p1 = getPlace(bits[0]);
      Place p2 = getPlace(bits[2]);
      p1.addLink(p2, Integer.parseInt(bits[4]));
      p2.addLink(p1, Integer.parseInt(bits[4]));
    }    
  }
  
  int visit(Place p, int distance, int best_distance, boolean use_min) {
    boolean done=true;
    for (int i=0; i<places.size(); i++) {
      if (places.get(i).visited == 0) {
        done=false;
        break;
      }
    }
    
    if (!done) {
      for (int i=0; i<p.links.size(); i++) {
        if (p.links.get(i).visited == 0) {
          p.links.get(i).visited++;
          best_distance = visit(p.links.get(i), distance + p.distances.get(i), best_distance, use_min);
          p.links.get(i).visited--;
        }
      }
    } else {
      if (use_min) best_distance = Math.min(best_distance, distance);
      else best_distance = Math.max(best_distance, distance);
    }
    return best_distance;
  }
  
  int advent9(boolean use_min) {
    int best;
    if (use_min) best = Integer.MAX_VALUE;
    else best = 0;
    for (int i=0; i<places.size(); i++) {
       places.get(i).visited++;
       if (use_min) best = Math.min(visit(places.get(i), 0, best, use_min), best);
       else best = Math.max(visit(places.get(i), 0, best, use_min), best);
       places.get(i).visited--;
    }
    return best;
  }
  
  public puzzle() throws Exception {
    input = Utils.readLines("../inputs/input_9.txt");
    makeTree();
  }
  
  public static void main(String[] args) throws Exception {
    puzzle p = new puzzle();
    System.out.println(p.advent9(true));
    System.out.println(p.advent9(false));
    
  }
}