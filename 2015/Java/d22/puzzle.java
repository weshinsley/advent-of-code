package d22;

import java.util.ArrayList;

import tools.Utils;

public class puzzle {
  int smallest_manna_spend = Integer.MAX_VALUE;
  int def_boss_hit;
  int def_boss_damage;
  class GameState {
    boolean easy;
    boolean live = true;
    byte next_move=1;
    byte player_hit;
    byte player_armour;
    byte boss_hit;
    byte boss_damage;
    byte shield_timer;
    byte poison_timer;
    byte recharge_timer;
    
    int manna;
    int manna_spent;
    
    GameState(boolean e, byte ph, byte pa, byte bh, byte bd, byte st, byte pt, byte rt, int m, int ms, byte nm) {
      player_hit = ph; player_armour = pa; boss_hit = bh; 
      boss_damage = bd; shield_timer = st; poison_timer = pt;
      recharge_timer = rt; manna = m; next_move = nm;
      manna_spent = ms; easy = e;
    }
    
    GameState(GameState g) {
      live = g.live; player_hit = g.player_hit; player_armour=g.player_armour;
      boss_hit = g.boss_hit; shield_timer = g.shield_timer; 
      poison_timer = g.poison_timer; recharge_timer = g.recharge_timer; 
      manna = g.manna; boss_damage = g.boss_damage; 
      manna_spent = g.manna_spent;
      easy = g.easy;
    }
    
    void nextState() {
      if (!easy) player_hit--;
      if (player_hit<=0) live=false;
      
      if (live) doEffects();
      if (live) checkDeath();
      if (live) doPlayerMove();
      if (live) checkDeath();
      if (live) doEffects();
      if (live) checkDeath();
      if (live) doBossMove();
      if (live) checkDeath(); 
    }
    
    void doEffects() {
      if (shield_timer>0) {
        shield_timer--;
      }
      
      if (poison_timer>0) {
        poison_timer--;
        boss_hit -= 3;
      }
      
      if (recharge_timer>0) {
        recharge_timer--;
        manna+=101;
      }
    }
    
    void doPlayerMove() {
      byte moves=0;
      byte tries=0;
      while ((tries<5) && (moves==0)) {
        if (next_move == 1) {
          tries++;
          if (manna>=53) {
            manna -= 53;
            manna_spent += 53;
            boss_hit -= 4;
            moves++;
          }
        }
      
        if (next_move == 2) {
          tries++;
          if (manna>=73) {
            manna -= 73;
            manna_spent += 73;
            player_hit += 2;
            boss_hit -= 2;
            moves++;
          }
        } 
      
        if (next_move == 3) {
          tries++;
          if ((shield_timer==0) && (manna >= 113)) {
            manna-=113;
            manna_spent += 113;
            shield_timer = 6;
            moves++;
          }
        }
      
        if (next_move == 4) {
          tries++;
          if ((poison_timer==0) && (manna >= 173)) {
            manna-=173;
            manna_spent += 173;
            poison_timer = 6;
            moves++;
          }
        }
    
        if (next_move == 5) {
          tries++;
          if ((recharge_timer==0) && (manna >= 229)) {
            manna -= 229;
            manna_spent += 229;
            recharge_timer = 5;
            moves++;
          }
        }
      
        if (moves==0) next_move = (byte) (1 + (next_move % 5));
      }
      if (moves==0) live = false;
      
    }
    
    
    void checkDeath() {
      if (boss_hit<=0) {
        live=false;
        smallest_manna_spend = Math.min(smallest_manna_spend,  manna_spent);
      }
      
      if (player_hit<=0) live=false;
      if (manna_spent >= smallest_manna_spend) live=false;
    }
    
    void doBossMove() {
      if (shield_timer>0) player_armour=7;
      else player_armour=0;
      player_hit -= Math.max(1, boss_damage - player_armour);
    }
  }
  
  void parse(ArrayList<String> input) {
    for (int i=0; i<input.size(); i++) {
      String s = input.get(i);
      s = s.replace(":", "");
      String[] bits = s.split("\\s+");
      if (bits[0].equals("Hit")) def_boss_hit = Integer.parseInt(bits[2]);
      if (bits[0].equals("Damage")) def_boss_damage = Integer.parseInt(bits[1]);
    }
  }
  
  void advent21(boolean easy) {
    smallest_manna_spend = Integer.MAX_VALUE;
    ArrayList<GameState> gs = new ArrayList<GameState>();
    for (int i=0; i<5; i++) {
      gs.add(new GameState(easy, (byte)50, (byte)0, (byte)def_boss_hit, 
          (byte)def_boss_damage, (byte)0, (byte)0, (byte)0, 500, 0,
          (byte)(i+1)));
    }
    
    while (gs.size()>0) {
      GameState g = gs.get(gs.size()-1);
      gs.remove(g);
      g.nextState();
      if (g.live) {
        for (int j=0; j<5; j++) {
          GameState g2 = new GameState(g);
          g2.next_move = (byte) (j+1);
          gs.add(g2); 
        }
      } 
    }
    System.out.println(smallest_manna_spend);
  }
  
  
  public static void main(String[] args) throws Exception {
    ArrayList<String> input = Utils.readLines("../inputs/input_22.txt");
    puzzle p = new puzzle();
    p.parse(input);
    p.advent21(true);
    
    p.advent21(false);
  }
}
