package d20;

import java.util.ArrayDeque;
import java.util.ArrayList;

import tools.WesUtils;

public class puzzle {
  String input;
  ArrayList<ArrayList<Room>> northPole = new ArrayList<ArrayList<Room>>();
  Room origin = null;
  
  
  final static int NORTH = 0;
  final static int EAST = 1;
  final static int SOUTH = 2;
  final static int WEST = 3;

  final static int[] xd = new int[] {0,1,0,-1};
  final static int[] yd = new int[] {-1,0,1,0};
  final static char[] dump_ch = new char[] {'-','|','-','|'};
  
  
  class Room {
    int x, y;
  
    void incY() { y = y + 1; }
    void incX() { x = x + 1; }
    
    Room[] doors;
    int dist;
    boolean plotted;
    
    Room() {
      doors = new Room[4];
      dist = -1;
      x = 0;
      y = 0;
      plotted = false;
    }
    
    Room getRoom(int direction) {
      int xx = x;
      int yy = y;
      if (direction == NORTH) yy--;
      else if (direction == SOUTH) yy++;
      else if (direction == EAST) xx++;
      else if (direction == WEST) xx--;
      Room r = null;
      if ((northPole.size()>yy) && (yy>=0))
        if ((northPole.get(yy).size()>xx) && (xx>=0))
          r = northPole.get(yy).get(xx);
      
      if (r == null) {
        r = new Room();
        doors[direction] = r;
        r.doors[(direction + 2) % 4] = this;
        r.x = xx;
        r.y = yy;
        northPole.get(r.y).set(r.x, r);
      }
      return r;
    }
  }
  
  void expandNorth() {
    for (int j=0; j<northPole.size(); j++)
      for (int i=0; i<northPole.get(j).size(); i++)
        if (northPole.get(j).get(i)!=null) northPole.get(j).get(i).incY(); 

    ArrayList<Room> new_row = new ArrayList<Room>();
    for (int i=0; i<northPole.get(0).size(); i++) new_row.add(null);
    northPole.add(0, new_row);
  }
  
  void expandSouth() {
    ArrayList<Room> new_row = new ArrayList<Room>();
    for (int i=0; i<northPole.get(0).size(); i++) new_row.add(null);
    northPole.add(new_row);
  }
  
  void expandWest() {
    for (int j=0; j<northPole.size(); j++) 
      for (int i=0; i<northPole.get(j).size(); i++)
        if (northPole.get(j).get(i)!=null) northPole.get(j).get(i).incX(); 
    
    for (int j=0; j<northPole.size(); j++)
      northPole.get(j).add(0, null);
  }
  
  void expandEast() {
    for (int j=0; j<northPole.size(); j++)
      northPole.get(j).add(null);
  }
  
  int scan(int pos, Room start, boolean dump) {
    Room current = start;
    while (true) {
      char ch = input.charAt(pos);

      if ((ch=='N') || (ch=='W') || (ch=='E') || (ch=='S')) {
        int dir = (ch=='N')?NORTH:(ch=='E')?EAST:(ch=='S')?SOUTH:(ch=='W')?WEST:-1;
        if (current.x + xd[dir] == -1) { expandWest(); }
        if (current.x + xd[dir] == northPole.get(0).size()) {expandEast(); }
        if (current.y + yd[dir] == -1) expandNorth(); 
        if (current.y + yd[dir] == northPole.size()) expandSouth();
        current = current.getRoom(dir);
        pos++;
      
      } else if (ch == '|') {
        current = start;
        pos++;
    
      } else if (ch == '(') {
        pos = scan(pos + 1, current, dump);
      
      } else if ((ch == ')') || (ch=='$')) {
        return pos + 1;
      
      } else return Integer.MIN_VALUE;
      
      if (dump) dump(origin);
    }
  }
   
  int findLongest(Room r) {
    ArrayDeque<Room> stack = new ArrayDeque<Room>();
    r.dist = 0;
    stack.push(r);
    int max=0;
    while (stack.size()>0) {
      Room room = stack.pop();
      max = Math.max(max, room.dist);
      for (int i=0; i<4; i++) {
        if ((room.doors[i]!=null) && ((room.doors[i].dist==-1) || room.doors[i].dist > room.dist)) {
          room.doors[i].dist = room.dist + 1;
          stack.push(room.doors[i]);
        }
      }
    }
    return max;
  }
  
  
  void plot(Room r, StringBuilder[] map) {
    r.plotted = true;
    int x = 2*(r.x)+1;
    int y = 2*(r.y)+1;
    map[y-1].setCharAt(x-1,'#');
    map[y-1].setCharAt(x,(r.doors[NORTH]==null?'#':'-'));
    map[y-1].setCharAt(x+1,'#');
    map[y].setCharAt(x-1,(r.doors[WEST]==null?'#':'|'));
    map[y].setCharAt(x, '.');
    map[y].setCharAt(x+1,(r.doors[EAST]==null?'#':'|'));
    map[y+1].setCharAt(x-1,'#');
    map[y+1].setCharAt(x,(r.doors[SOUTH]==null?'#':'-'));
    map[y+1].setCharAt(x+1,'#');

    for (int d=0; d<=3; d++) {
      if ((r.doors[d]!=null) && (!r.doors[d].plotted)) {
        map[y+yd[d]].setCharAt(x+xd[d], dump_ch[d]);
        plot(r.doors[d], map);
      } 
    }
  }
  
  void dump(Room start) {
    for (int j=0; j<northPole.size(); j++) {
      for (int i=0; i<northPole.get(j).size(); i++) {
        Room r = northPole.get(j).get(i);
        if (r!=null) r.plotted=false;
      }
    }
    StringBuilder[] map = new StringBuilder[1 + (northPole.size()*2)];
    for (int j=0; j<map.length; j++) { 
      map[j] = new StringBuilder();
      map[j].append(" ");
      for (int i=0; i<northPole.get(0).size(); i++) map[j].append("  ");
    }
    plot(start, map);
    map[1 + origin.y*2].setCharAt(1 + origin.x*2, 'X');
    
    for (int i=0; i<map.length; i++) System.out.println(map[i]);
    System.out.println("");
  }
  
  int advent20a(String s) {
    input = s;
    origin = new Room();
    northPole = new ArrayList<ArrayList<Room>>();
    northPole.add(new ArrayList<Room>());
    northPole.get(0).add(origin);
    scan(1, origin, false);
    return findLongest(origin);     
  }
  
  int advent20b() {
    int z=0;
    for (int j=0; j<northPole.size(); j++)
      for (int i=0; i<northPole.get(j).size(); i++)
        if (northPole.get(j).get(i).dist>=1000) z++;
    return z;
  }
  
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    System.out.println(w.advent20a(WesUtils.readLines("../inputs/input_20.txt").get(0)));
    System.out.println(w.advent20b());
    
  }
}
