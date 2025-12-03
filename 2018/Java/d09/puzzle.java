package d09;

import java.util.ArrayDeque;

import tools.WesUtils;

public class puzzle {
  int in_players;
  long in_lmv;
  
  @SuppressWarnings("serial")
  class Circular<Type> extends ArrayDeque<Type> {
    void rotate(int num) {
      if (num > 0) {
        for (int i = 0; i < num; i++) {
          Type I = this.removeLast();
          this.addFirst(I);
        }
      } else if (num < 0) {
        for (int i = 0; i < (-num) - 1; i++) {
          Type I = this.remove();
          this.addLast(I);
        }
      }
    }
  }
  
  void parseInput(String s) {
    s = s.replace("players; last marble is worth ","");
    s = s.replace("points","");
    String[] bits = s.split("\\s+");
    in_players = Integer.parseInt(bits[0]);
    in_lmv = Integer.parseInt(bits[1]);
  }
  
  long advent9a(int players, long no_marbles) {
    long[] scores = new long[players];
    Circular<Integer> circle =  new Circular<Integer>();
    circle.addFirst(0);
    int current_player=0;
    long max_score=0;
    for (int next_marble = 1; next_marble <= no_marbles; next_marble++) {
      if (next_marble %23 == 0) {
        scores[current_player] += next_marble;
        circle.rotate(-7);
        scores[current_player] += circle.pop();
        max_score = Math.max(max_score,  scores[current_player]);
      } else {
        circle.rotate(2);
        circle.addLast(next_marble);
      }
      current_player = (current_player + 1) % players;
    }
    return max_score;
  }
  
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.parseInput(WesUtils.readLines("../inputs/input_9.txt").get(0));
    long time = -System.currentTimeMillis();
    System.out.print(w.advent9a(w.in_players, w.in_lmv));
    time += System.currentTimeMillis();
    System.out.println(" ("+time+" ms)");
    time = -System.currentTimeMillis();
    System.out.print(w.advent9a(w.in_players, w.in_lmv*100));
    time += System.currentTimeMillis();
    System.out.println(" ("+time+" ms)");
  }
}
