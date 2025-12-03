package d24;

import java.util.ArrayList;
import java.util.Arrays;

import tools.WesUtils;

public class puzzle {
  static final ArrayList<String> types = new ArrayList<String>(Arrays.asList(new String[] {"bludgeoning", "radiation", "slashing", "fire", "cold"}));
  
  class Army {
    ArrayList<Group> groups;
    
    Army() {
      groups = new ArrayList<Group>();
    }
    
    void removeTheDead() {
      int i = 0;
      while (i < groups.size()) {
        if (groups.get(i).units <= 0) groups.remove(i);
        else i++;
      }
    }
    
    int totalUnits() {
      int sum = 0;
      for (int i = 0; i < groups.size(); i++) sum += groups.get(i).units;
      return sum;
    }
    
    void sortByEP() {
      for (int i = 0; i < groups.size() - 1; i++) {
        int eff_best = groups.get(i).effectivePower();
        int eff_best_init = groups.get(i).initiative;
        int eff_index = i;
        
        for (int j = i + 1; j < groups.size(); j++) {
          int eff_comp = groups.get(j).effectivePower();
          if ((eff_comp > eff_best) || ((eff_comp == eff_best) && (groups.get(j).initiative > eff_best_init))) {
            eff_best = eff_comp;
            eff_best_init = groups.get(j).initiative;
            eff_index = j;
          }
        }
        if (i != eff_index) {
          Group swap = groups.get(i);
          groups.set(i,  groups.get(eff_index));
          groups.set(eff_index, swap);
        }
      }
    }
  }
  
  class Group {
    int id;
    int units;
    int hp;
    int attack_damage;
    int attack_type;
    int initiative;
    Group target;
    
    boolean[] immune = new boolean[types.size()];
    boolean[] weak = new boolean[types.size()];
    
    Group(int u, int h, int _id) {
      units = u;
      hp = h;
      for (int i = 0; i < types.size(); i++) {
        immune[i] = false;
        weak[i] = false;
      }
      target = null;
      id = _id;
      
    }
    
    int effectivePower() {
      return units * attack_damage;
    }
  }
  
  Army immune = new Army();
  Army infection = new Army();
  
  void parseInput(ArrayList<String> input) {
    immune.groups.clear();
    infection.groups.clear();
    
    Army current = null;
    int i=0;
    while (i < input.size()) {
      String s = input.get(i);
    
      if (s.equals("Immune System:")) current = immune;
      
      else if (s.equals("Infection:")) current = infection;

      else if (s.indexOf("units each with") >= 0) {
        
        int units = Integer.parseInt(s.substring(0, s.indexOf(" ")));
        s = s.substring(s.indexOf("units each with ") + 16);
        
        int hp = Integer.parseInt(s.substring(0, s.indexOf(" ")));
        s = s.substring(s.indexOf("hit points ") + 11);
        
        Group g = new Group(units, hp, 1 + current.groups.size());
        if (s.startsWith("(")) {
          String[] extras = s.substring(s.indexOf("(")+1, s.indexOf(")")).split("; ");
          for (int e = 0; e < extras.length; e++) {
            extras[e] = extras[e].trim();
            if (extras[e].startsWith("immune to ")) {
              String[] things = extras[e].substring(10).split(", ");
              for (int j = 0; j < things.length; j++) g.immune[types.indexOf(things[j])] = true;
                  
            } else if (extras[e].startsWith("weak to ")) {
              String[] things = extras[e].substring(8).split(", ");
              for (int j = 0; j < things.length; j++) g.weak[types.indexOf(things[j])] = true;
            }
          }
          
          s = s.substring(s.indexOf(")") + 27);
        } else s = s.substring(25);
        g.attack_damage = Integer.parseInt(s.substring(0, s.indexOf(" ")));
        s = s.substring(s.indexOf(" ") + 1);
        g.attack_type = types.indexOf(s.substring(0, s.indexOf(" ")));
        s = s.substring(s.indexOf(" ") + 22);
        g.initiative = Integer.parseInt(s);
        current.groups.add(g);
      }
      i++;
    }
  }
  
  void targeting(Army A, Army B) {
    A.sortByEP();
    ArrayList<Group> selection = new ArrayList<Group>();
    for (int i = 0; i < B.groups.size(); i++) selection.add(B.groups.get(i));
    
    for (int ga = 0; ga < A.groups.size(); ga++) {
      Group att = A.groups.get(ga);
      double best_damage = -1;
      int best_effp = -1;
      int best_init = -1;
      att.target = null;
      
      for (int gb = 0; gb < selection.size(); gb++) {
        Group def = selection.get(gb);
        int damage = att.effectivePower();
        if (def.immune[att.attack_type]) damage = 0;
        else if (def.weak[att.attack_type]) damage *= 2.0;
        if (damage > 0) {
          if ((damage > best_damage) || ((damage == best_damage) && (def.effectivePower() > best_effp))
                                     || ((damage == best_damage) && (def.effectivePower() == best_effp) && (def.initiative > best_init))) {
            best_damage = damage;
            best_effp = def.effectivePower();
            best_init = def.initiative;
            att.target = def;
          }
        }
      }
      
      if (att.target != null) selection.remove(att.target);
    }
  }
   
  void attacking() {
    ArrayList<Group> all = new ArrayList<Group>();
    for (int i = 0; i < immune.groups.size(); i++) all.add(immune.groups.get(i));
    for (int i = 0; i < infection.groups.size(); i++) all.add(infection.groups.get(i));
    
    for (int i = 0; i<all.size() - 1; i++) {
      int best_init = all.get(i).initiative;
      int best_index = i;
      for (int j= i + 1; j<all.size(); j++) {
        if (all.get(j).initiative > best_init) {
          best_init = all.get(j).initiative;
          best_index = j;
        }
      }
      if (best_index != i) {
        Group tmp = all.get(i);
        all.set(i, all.get(best_index));
        all.set(best_index, tmp);
      }
    }
    
    for (int i = 0; i < all.size(); i++) {
      Group att = all.get(i);
      Group def = att.target;
      if (def != null) {
        int damage = att.effectivePower();
        if (def.immune[att.attack_type]) damage = 0;
        else if (def.weak[att.attack_type]) damage *= 2.0;
        int units_lost = Math.min(def.units, damage / def.hp);
        def.units -= units_lost;
      }
    }
  }
  
  int advent24a() {
    boolean stalemate = false;
    do {
      int total_units = infection.totalUnits() + immune.totalUnits();
      
      targeting(immune, infection);
      targeting(infection, immune);
      attacking();
      
      int total_units2 = infection.totalUnits() + immune.totalUnits();
      if (total_units == total_units2) {
        System.out.println("Stalemate");
        stalemate = true;
        break;
      }
      
      infection.removeTheDead();
      immune.removeTheDead();
    } while ((infection.totalUnits() > 0) && (immune.totalUnits() > 0));
    
    Army alive = (infection.totalUnits() > 0) ? infection : immune;
    
    return (stalemate) ? -1 : alive.totalUnits();
  }
  
  int advent24b() throws Exception {
    int boost = 0;
    int alive = -1;
    
    while (true) {
      System.out.print("BOOST "+boost+" - result: ");
      parseInput(WesUtils.readLines("../inputs/input_24.txt"));
      for (int i = 0; i < immune.groups.size(); i++) immune.groups.get(i).attack_damage += boost;
      
      alive = advent24a();
      
      if ((immune.totalUnits() == 0) || (alive == -1)) {
        boost++;
        if (immune.totalUnits() == 0) System.out.println("Infected win with "+infection.totalUnits());
      }
      else break;
    }
    System.out.print("Immune victory by ");
    return alive;
  }
  
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.parseInput(WesUtils.readLines("../inputs/input_24.txt"));
    System.out.println(w.advent24a());
    System.out.println(w.advent24b());    
  }
}
