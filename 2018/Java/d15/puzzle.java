package d15;

import java.util.ArrayList;

import tools.WesUtils;

public class puzzle {
  final static int EMPTY = -1;
  final static int WALL = -2;
  final static int GOBLIN = -3;
  final static int ELF = -4;
  final static char[] map_chars = new char[] {'E','G','#','.'};
  
  final ArrayList<Player> players = new ArrayList<Player>();
  final ArrayList<Player> elves = new ArrayList<Player>();
  final ArrayList<Player> goblins = new ArrayList<Player>();
  int[][] map;

  
  class Player { 
    int x, y, hp, ap, new_x, new_y; 
    Player(int _x, int _y) { 
      x = _x; 
      y = _y; 
      hp = 200;
      ap = 3;
      
    }
    
    void moves(ArrayList<Player> m) {
      if (map[x][y-1] == EMPTY) m.add(new Player(x, y-1));
      if (map[x-1][y] == EMPTY) m.add(new Player(x-1, y));
      if (map[x+1][y] == EMPTY) m.add(new Player(x+1, y));
      if (map[x][y+1] == EMPTY) m.add(new Player(x, y+1));
    }
   
    boolean inRange(Player p) {
      return (((x == p.x) && ((y==p.y-1) || (y==p.y+1))) ||
              ((y == p.y) && ((x==p.x-1) || (x==p.x+1))));
    }
    
    void makeMove(int[][] distmap) {
      int min = Integer.MAX_VALUE;
      new_x = x;
      new_y = y;
      if ((distmap[x][y-1]>=0) && (distmap[x][y-1]<min)) {
        min = distmap[x][y-1]; new_y = y - 1;
      }
      if ((distmap[x-1][y]>=0) && (distmap[x-1][y]<min)) {
        min = distmap[x-1][y]; new_x = x-1; new_y = y;
      }
      if ((distmap[x+1][y]>=0) && (distmap[x+1][y]<min)) {
        min = distmap[x+1][y]; new_x = x+1; new_y = y;
      }
      if ((distmap[x][y+1]>=0) && (distmap[x][y+1]<min)) {
        min = distmap[x][y+1]; new_x = x; new_y = y+1;
      }
    }
    
    int addPotential(ArrayList<Player> ap, int i, int j) {
      for (int z=0; z<players.size(); z++) {
        if ((players.get(z).x==i) && (players.get(z).y==j)) {
          ap.add(players.get(z));
          return players.get(z).hp;
        }
      }
      return Integer.MIN_VALUE;
    }
    
    Player pickFight(boolean me_elf) {
      ArrayList<Player> potential = new ArrayList<Player>();
      int min_hp = Integer.MAX_VALUE;
      if (map[x][y - 1] == (me_elf?GOBLIN:ELF)) min_hp = Math.min(min_hp, addPotential(potential, x, y - 1));
      if (map[x - 1][y] == (me_elf?GOBLIN:ELF)) min_hp = Math.min(min_hp, addPotential(potential, x - 1, y));
      if (map[x + 1][y] == (me_elf?GOBLIN:ELF)) min_hp = Math.min(min_hp, addPotential(potential, x + 1, y));
      if (map[x][y + 1] == (me_elf?GOBLIN:ELF)) min_hp = Math.min(min_hp, addPotential(potential, x, y + 1));
      for (int i = potential.size() - 1; i>=0; i--) {
        if (potential.get(i).hp > min_hp) potential.remove(i);
      }
      if (potential.size()==0) return null;
      else return potential.get(0);
    }
  }
  
  class Goblin extends Player { 
    Goblin(int _x, int _y) { 
      super(_x,_y); 
    }
  }
  
  class Elf extends Player { 
    Elf(int _x, int _y) { 
      super(_x,_y); 
    }
  }
  
  void exploreMap(int[][] m, int i, int j, int dist) {
    if (m[i][j] < EMPTY) return;
    if ((m[i][j] > EMPTY) && (m[i][j] <= dist)) return;
    m[i][j] = dist;
    dist++;
    exploreMap(m, i + 1, j, dist);
    exploreMap(m, i - 1, j, dist);
    exploreMap(m, i, j - 1, dist);
    exploreMap(m, i, j + 1, dist);
  }
  
  int[][] getShortestDistanceMap(int x, int y) {
    int[][] map2 = new int[map.length][map[0].length];
    for (int i=0; i<map2.length; i++)
      for (int j=0; j<map2[i].length; j++)
        map2[i][j] = map[i][j];
    map2[x][y]=0;
    exploreMap(map2, x + 1, y, 1);
    exploreMap(map2, x - 1, y, 1);
    exploreMap(map2, x, y - 1, 1);
    exploreMap(map2, x, y + 1, 1);
    return map2;
  }
  
  
  void parseInput(ArrayList<StringBuilder> input) {
    players.clear();
    elves.clear();
    goblins.clear();
    map = new int[input.get(0).length()][input.size()];
    for (int j=0; j<input.size(); j++) {
      StringBuilder sb = input.get(j);
      for (int i=0; i<sb.length(); i++) {
        if (sb.charAt(i) == '#') map[i][j] = WALL;
        else if (sb.charAt(i) == '.') map[i][j] = EMPTY;
        else if (sb.charAt(i) == 'G') {
          Goblin g = new Goblin(i,j);
          players.add(g);
          goblins.add(g);
          map[i][j]=GOBLIN;
        } else if (sb.charAt(i) == 'E') {
          Elf e = new Elf(i,j);
          players.add(e);
          elves.add(e);
          map[i][j]=ELF;
        }
      }
    }
  }
  
  
  void sort(ArrayList<Player> list) {
    for (int i=0; i<list.size()-1; i++) {
      Player best_player = list.get(i);
      int best_index = i;
      for (int j=i+1; j<list.size(); j++) {
        Player compare = list.get(j);
        if ((compare.y < best_player.y) || ((compare.y == best_player.y) && (compare.x < best_player.x))) {
          best_index = j;
          best_player = compare;
        }
      }
      if (best_index != i) {
        list.remove(best_index);
        list.add(i, best_player);
      }
    }
  }
  
  void unique(ArrayList<Player> list) {
    int i=0;
    while (i<list.size()-1) {
      if ((list.get(i).x == list.get(i+1).x) && (list.get(i).y == list.get(i+1).y)) {
        list.remove(i);
      } else i++;
    }
  }
  
  void nearest(ArrayList<Player> squares, int[][] distmap) {
    int min = Integer.MAX_VALUE;
    for (int i=0; i<squares.size(); i++) {
      Player sq = squares.get(i);
      int dist = distmap[sq.x][sq.y];
      if (dist>0) min = Math.min(min, dist);
    }
    if (min == Integer.MAX_VALUE) squares.clear();
    else {
      int i=0;
      while (i < squares.size()) {
        Player sq = squares.get(i);
        int dist = distmap[sq.x][sq.y];
        if (dist!=min) squares.remove(i);
        else i++;
      }
    }
  }
  
  void printMap(int[][] m, boolean ch) {
    for (int j=0; j<m[0].length; j++) {
      for (int i=0; i<m.length; i++) {
        if (ch) System.out.print(map_chars[m[i][j] + 4]);
        else {
          if (m[i][j]>=0) System.out.print(m[i][j]);
          else System.out.print(".");
        }
      }
      System.out.println();
    }
    System.out.println();
  }
  
  void printStats() {
    for (int i=0; i<players.size(); i++) {
      System.out.print((players.get(i) instanceof Goblin)?"G":"E");
      System.out.print("("+players.get(i).hp+"), ");
    }
    System.out.println("\n");
  }
  
  int turn() {
    sort(players);
    sort(elves);
    sort(goblins);
    ArrayList<Player> targets;
    ArrayList<Player> moves = new ArrayList<Player>();
    int p=0;
    while (p<players.size()) {
      moves.clear();
      Player me = players.get(p);
      me.new_x = me.x;
      me.new_y = me.y;
      boolean elf = (me instanceof Elf);
      targets = (elf) ? goblins : elves;
      boolean skip_move = false;
      if (targets.size()==0) return 0;
      for (int t=0; t<targets.size(); t++) {
        Player targ = targets.get(t);
        targ.moves(moves);
        if (me.inRange(targ)) {
          skip_move = true;
         
        }
      }
      if (!skip_move) {
        int[][] dist_map = getShortestDistanceMap(me.x, me.y);
        if (moves.size()>1) {
          nearest(moves, dist_map);
          sort(moves);
          unique(moves);
        }
        if (moves.size()>0) {
          dist_map = getShortestDistanceMap(moves.get(0).x, moves.get(0).y);
          me.makeMove(dist_map);
        }
      }
      if ((me.x != me.new_x) || (me.y != me.new_y)) {
        map[me.new_x][me.new_y] = map[me.x][me.y];
        map[me.x][me.y] = EMPTY;
        me.x = me.new_x;
        me.y = me.new_y;         
      }
      
      Player victim = me.pickFight(elf);
      if (victim!=null) {
        victim.hp -= me.ap;
        if (victim.hp<=0) {
          map[victim.x][victim.y] = EMPTY;
          targets.remove(victim);
          if (players.indexOf(victim)<p) p--;
          players.remove(victim);
        }
      } 
      p++;
    }
    return 1;
  }
  
  void advent15a() {
    System.out.println("Initialisation: ");
    printMap(map,true);
    printStats();
    int turns=0;
    while ((goblins.size()>0) && (elves.size()>0)) {
      turns += turn();
      sort(players);
      System.out.println("After turn "+turns+": ");
      printMap(map, true);
      printStats();
    }
    ArrayList<Player> winners;
    winners = (goblins.size()>0)?goblins:elves;
    System.out.print(((goblins.size()>0)?"Goblin ":"Elf ")+" victory after "+turns+" turns. ");
    int h=0;
    for (int i=0; i<winners.size(); i++) h+=winners.get(i).hp;
    System.out.println("Total Hp = "+h+" - Answer = "+turns*h);
  }
  
  void advent15b() throws Exception {
    int ap=4;
    parseInput(WesUtils.readLinesSB("../inputs/input_15.txt"));
    for (int i=0; i<elves.size(); i++) elves.get(i).ap=ap;
    int orig_elves = elves.size();
    int turns;
    while (true) {
      System.out.print("Try ap="+ap+" ... ");
      turns=0;
      while ((goblins.size()>0) && (elves.size()>0)) {
        turns += turn();
        sort(players);
      }
      if (elves.size() < orig_elves) {
        System.out.println("Final elves: "+elves.size());
        ap++;
        parseInput(WesUtils.readLinesSB("../inputs/input_15.txt"));
        for (int i=0; i<elves.size(); i++) elves.get(i).ap=ap;
      } else break;
    }
    int h=0;
    for (int i=0; i<elves.size(); i++) h+=elves.get(i).hp;
    System.out.print("\nElves win with no fatalities, after "+turns+" turns. Total Hp = "+h+" - Answer = "+turns*h);
  }
  
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.parseInput(WesUtils.readLinesSB("../inputs/input_15.txt"));
    w.advent15a();
    w.advent15b();
  
  }
}
