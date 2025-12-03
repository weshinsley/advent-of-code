package d14;

import java.util.ArrayList;

import tools.Utils;

public class puzzle {
  ArrayList<Reindeer> reindeers = new ArrayList<Reindeer>();
  
  class Reindeer {
    String name;
    int speed;
    int speed_time;
    int rest_time;
    
    boolean is_resting = false;
    int timer;
    int distance;
    void init() {
      is_resting = false;
      timer = speed_time;
      distance = 0;
    }
    
    public Reindeer(String name, int speed, int speed_time, int rest_time) {
      this.name = name; 
      this.speed = speed; 
      this.speed_time = speed_time;
      this.rest_time = rest_time;
      init();
    }
    
    void timestep() {
      timer--;
      if (is_resting) {
        if (timer==0) {
          is_resting = false;
          timer = speed_time;
        } 
      } else {
        if (timer==0) {
          is_resting = true;
          timer = rest_time;
        }
        distance+=speed;
      }
    }
  }
  
  void parse(ArrayList<String> input) {
    for (int i=0; i<input.size(); i++) {
      String[] bits = input.get(i).split("\\s+");
      reindeers.add(new Reindeer(bits[0], Integer.parseInt(bits[3]), 
          Integer.parseInt(bits[6]), Integer.parseInt(bits[13])));
    }
  }
 
  void advent14a() {
    for (int t=0; t<2503; t++)
      for (int r=0; r<reindeers.size(); r++)
        reindeers.get(r).timestep();
    
    int best=reindeers.get(0).distance;
    int best_index=0;
    for (int r=1; r<reindeers.size(); r++) {
      if (reindeers.get(r).distance>best) {
        best_index=r;
        best=reindeers.get(r).distance;
      }
    }
    System.out.println("Best reindeer is "+reindeers.get(best_index).name+" at "+reindeers.get(best_index).distance);
  }
  
  void advent14b() {
    for (int r=0; r<reindeers.size(); r++) reindeers.get(r).init();
    int[] points = new int[reindeers.size()];
    for (int t=0; t<2503; t++) {
      for (int r=0; r<reindeers.size(); r++)
        reindeers.get(r).timestep();
    
      int best=reindeers.get(0).distance;
      for (int r=1; r<reindeers.size(); r++) {
        if (reindeers.get(r).distance>best) {
          best = reindeers.get(r).distance;
        }
      }
      for (int r=0; r<reindeers.size(); r++) {
        if (reindeers.get(r).distance == best) points[r]++;
      }
    }
    int best = points[0];
    int best_index=0;
    for (int r=1; r<reindeers.size(); r++) {
      if (points[r]>best) {
        best_index=r;
        best=points[r];
      }
    }
    System.out.println("Best reindeer is "+reindeers.get(best_index).name+" with "+points[best_index]);
  }
  
  public static void main(String[] args) throws Exception {
    ArrayList<String> input = Utils.readLines("../inputs/input_14.txt");
    puzzle p = new puzzle();
    p.parse(input);
    p.advent14a();
    p.advent14b();
  }
}
