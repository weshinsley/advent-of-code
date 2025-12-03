package d21;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

public class puzzle {
  
  static long[] combs = new long[] {0,0,0,1,3,6,7,6,3,1}; // How many times can totals be made with (d1,d2,d3)
  static long p1wins = 0;
  static long p2wins = 0;
  
  static int part1(int p1, int p2) {
    int[] score = new int[] {-1, 0, 0}; 
    int[] pos = new int[] {1, p1, p2};
    int rolls = 0; 
    int dice = 1;
    
    while (true) {
      for (int player=1; player<=2; player++) {
        int dv = dice;
        dice = (dice == 100 ? 1 : dice + 1);
        dv += dice;
        dice = (dice == 100 ? 1 : dice + 1);
        dv += dice;
        dice = (dice == 100 ? 1 : dice + 1);
        rolls += 3;
    
        pos[player] = pos[player] + dv;
        while (pos[player] > 10) pos[player] = pos[player] - 10;
        score[player] = score[player] + pos[player]; 
        if (score[player] >= 1000) {
          return score[3 - player] * rolls;
        }
      }
    }
  }

  
  static void game(int p1, int p2, int s1, int s2, boolean p1_turn, long rolls) {
    if (p1_turn) {
      for (int dice = 3; dice <= 9; dice++) {
        int next_p1 = p1 + dice;
        if (next_p1 > 10) next_p1 -=10;
        int next_s1 = s1 + next_p1;
        if (next_s1 >= 21) {
          p1wins = p1wins + (rolls * combs[dice]);
        } else {
          game(next_p1, p2, next_s1, s2, false, rolls * combs[dice]);
        }
      }
    } else {
      for (int dice = 3; dice <= 9; dice++) {
        int next_p2 = p2 + dice;
        if (next_p2 > 10) next_p2 -=10;
        int next_s2 = s2 + next_p2;
        if (next_s2 >= 21) {
          p2wins = p2wins + (rolls * combs[dice]);
        } else {
          game(p1, next_p2, s1, next_s2, true, rolls * combs[dice]);
        }
      }
    }
  }
    
  public static void main(String[] args) throws Exception {
    BufferedReader br = new BufferedReader(new FileReader(new File("../inputs/input_21.txt")));
    String s = br.readLine();
    int p1 = Integer.parseInt(s.substring(28));
    s = br.readLine();
    int p2 = Integer.parseInt(s.substring(28));
    br.close();
    System.out.println("Part 1: "+part1(p1, p2));
    
    game(4, 8, 0, 0, true, 1);
    long time = System.currentTimeMillis();
    p1wins = 0;
    p2wins = 0;
    game(p1, p2, 0, 0, true, 1);
    System.out.print("Part 2: "+Math.max(p1wins, p2wins));
    long time2 = System.currentTimeMillis();
    System.out.println("  ("+(time2 - time)+" ms)");
  }
    
}
