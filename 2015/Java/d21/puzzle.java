package d21;

import java.util.ArrayList;

import tools.Utils;

public class puzzle {
  final static int[][] weapons = new int[][] {{8,4,0},{10,5,0},{25,6,0},{40,7,0},{74,8,0}};
  final static int[][] armours = new int[][] {{13,0,1},{31,0,2},{53,0,3},{75,0,4},{102,0,5}};
  final static int[][] rings = new int[][] {{25,1,0},{50,2,0},{100,3,0},{20,0,1},{40,0,2},{80,0,3}};
  
  int boss_hit=-1;
  int boss_damage=-1;
  int boss_armour=-1;
  
  void parse(ArrayList<String> input) {
    for (int i=0; i<input.size(); i++) {
      String s = input.get(i);
      s = s.replace(":", "");
      String[] bits = s.split("\\s+");
      if (bits[0].equals("Hit")) boss_hit = Integer.parseInt(bits[2]);
      if (bits[0].equals("Damage")) boss_damage = Integer.parseInt(bits[1]);
      if (bits[0].equals("Armor")) boss_armour = Integer.parseInt(bits[1]);
    }
  }
  
  boolean win(int damage, int armour) {
    int bh = boss_hit;
    int ph = 100;
    while (true) {
      bh -= Math.max(1,  damage - boss_armour);
      if (bh<=0) return true;
      ph -= Math.max(1, boss_damage - armour);
      if (ph<=0) return false;
    }
  }
  
  void advent21() {
    int min_cost = Integer.MAX_VALUE;
    int max_cost= 0;
    // One weapon, 0-1 armour, 0-2 rings.
    for (int w=0; w<5; w++) { // Weapon 0..4
      for (int a=-1; a<5; a++) { // Armour 0..4  or -1 = none.
        for (int r=-1; r<21; r++) { // Ring -1 = none, 0..5 = 1 ring, 6..10 is first+another,
                                    //                 11..14 is second+another, 15..17 = third+another,
                                    //                 18-19 = fourth+other, 20 = 5th and 6th.
          int cost = weapons[w][0];
          int damage = weapons[w][1];
          int armour = 0;
          if (a>=0) { cost += armours[a][0]; armour += armours[a][2]; }
          if (r>=0) {
            if (r<=5) { cost+= rings[r][0]; damage+=rings[r][1]; armour+=rings[r][2];
            } else if (r<=10) { cost += rings[0][0] + rings[r-5][0];
                               damage += rings[0][1] + rings[r-5][1];
                               armour += rings[0][2] + rings[r-5][2];
            } else if (r<=14) { cost += rings[1][0] + rings[r-9][0];
                                damage += rings[1][1] + rings[r-9][1];
                                armour += rings[1][2] + rings[r-9][2];
            } else if (r<=17) { cost += rings[2][0] + rings[r-12][0];
                                damage += rings[2][1] + rings[r-12][1];
                                armour += rings[2][2] + rings[r-12][2];
            } else if (r<=19) { cost += rings[3][0] + rings[r-14][0];
                                damage += rings[3][1] + rings[r-14][1];
                                armour += rings[3][2] + rings[r-14][2];
            } else if (r<=20) { cost += rings[4][0] + rings[5][0];
                                damage += rings[4][1] + rings[5][1];
                                armour += rings[4][2] + rings[5][2];
            }
          }
          if (win(damage, armour)) {
            min_cost = Math.min(min_cost, cost);
          }
          if (!win(damage,armour)) {
            max_cost = Math.max(max_cost,  cost);
          }
        }
      }
    }
    System.out.println("Win with "+min_cost);
    System.out.println("Lose with "+max_cost);
  }
  
  public static void main(String[] args) throws Exception {
    ArrayList<String> input = Utils.readLines("../inputs/input_21.txt");
    puzzle p = new puzzle();
    p.parse(input);
    p.advent21();
  }
}
