package d15;

import java.util.ArrayList;

import tools.Utils;

public class puzzle {
  
  class Ingredient {
    String name;
    int capacity, durability, flavour, texture, calories;
    
    Ingredient(String n, int c, int d, int f, int t, int cal) {
      name = new String(n); 
      capacity=c;
      durability=d;
      flavour=f;
      texture=t;
      calories=cal;       
    }
  }
  
  ArrayList<Ingredient> kitchen = new ArrayList<Ingredient>();
  
  void parse(ArrayList<String> input) {
    for (int i=0; i<input.size(); i++) {
      String s = input.get(i);
      s = s.replace(","," ");
      s = s.replace(":"," ");
      String[] bits = s.split("\\s+");
      kitchen.add(new Ingredient(bits[0], Integer.parseInt(bits[2]), Integer.parseInt(bits[4]),
          Integer.parseInt(bits[6]), Integer.parseInt(bits[8]), Integer.parseInt(bits[10])));
    }
  }
  
  long score1(int[] teaspoons, int target_calories) {
    long capacity=0;
    long durability=0;
    long flavour=0;
    long texture=0;
    long calories=0;
    
    for (int i=0; i<teaspoons.length; i++) {
      if (teaspoons[i]>0) {
        Ingredient ing = kitchen.get(i);
        capacity += teaspoons[i] * ing.capacity;
        durability += teaspoons[i] * ing.durability;
        flavour += teaspoons[i] * ing.flavour;
        texture += teaspoons[i] * ing.texture;
        calories += teaspoons[i] * ing.calories;
      }
    }
    if (target_calories !=-1) {
      if (calories!=target_calories) {
        calories=-1;
      } else calories=1;
    } else calories=1;
    
    return Math.max(0, capacity) * 
           Math.max(0, durability) * 
           Math.max(0, flavour) *
           Math.max(0, texture) *
           Math.max(0,  calories);
  }
  
  long advent15(int calories) {
    long score=0;
    int[] tsp = new int[] {0,0,0,0};
    for (int i=0; i<=100; i++) {
      for (int j=0; j<=100; j++) {
        for (int k=0; k<=100; k++) {
          for (int m=0; m<=100; m++) {
            if (i+j+k+m == 100) {
              tsp[0]=i;
              tsp[1]=j;
              tsp[2]=k;
              tsp[3]=m;
              score = Math.max(score, score1(tsp, calories));
            }
          }
        }
      }
    }
    return score;
  }
  
  public static void main(String[] args) throws Exception {
    ArrayList<String> input = Utils.readLines("../inputs/input_15.txt");
    puzzle p = new puzzle();
    p.parse(input);
    System.out.println(p.advent15(-1));
    System.out.println(p.advent15(500));
  }
}
