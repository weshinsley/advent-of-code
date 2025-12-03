package d20;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class puzzle {

  final int[] dx = new int[] {0,1,0,-1};
  final int[] dy = new int[] {1,0,-1,0};
 
  ArrayList<String> readInput(String f) throws Exception {
    BufferedReader br = new BufferedReader(new FileReader(f));
    ArrayList<String> maze = new ArrayList<String>();
    String s = br.readLine();
    while (s!=null) {
      if (s.length()>2) maze.add(s);
      s = br.readLine();
    }
    br.close();
    return maze;
  }
 
  int solve(ArrayList<String> maze, boolean part1) {
    int hei = maze.size();
    int wid = maze.get(0).length();
    int startx=-1, starty=-1, endx=-1, endy = -1;
   
    HashMap<Integer, String> portals = new HashMap<Integer, String>();
   
    for (int j=0; j<hei; j++) {
      if (maze.get(j).charAt(0)!=' ') {
        String portal = ""+maze.get(j).charAt(0)+maze.get(j).charAt(1);
        portals.put((j*wid)+2, portal);
        if (portal.equals("AA")) { startx = 2; starty = j; }
        else if (portal.equals("ZZ")) { endx = 2; endy = j; }
      }
      if (maze.get(j).charAt(wid-1)!=' ') {
        String portal = ""+maze.get(j).charAt(wid-2)+maze.get(j).charAt(wid-1);
        portals.put((j*wid)+(wid-3), portal);
        if (portal.equals("AA")) { startx = wid-3; starty = j; }
        else if (portal.equals("ZZ")) { endx = wid-3; starty = j; }
      }
    }
   
    for (int i=0; i<wid; i++) {
      if (maze.get(0).charAt(i)!=' ') {
        String portal = ""+maze.get(0).charAt(i)+maze.get(1).charAt(i);
        portals.put((2*wid)+i, portal);
        if (portal.equals("AA")) { startx = i; starty = 2; }
        else if (portal.equals("ZZ")) { endx = i; endy = 2; }
      }
      if (maze.get(hei-1).charAt(i)!=' ') {
        String portal = ""+maze.get(hei-2).charAt(i)+maze.get(hei-1).charAt(i);
        portals.put(((hei-3)*wid)+i, portal);
        if (portal.equals("AA")) { startx = i; starty = hei-3; }
        else if (portal.equals("ZZ")) { endx = i; endy = hei-3; }
      }
    }
    int wmid = wid/2;
    int lmid = wmid;
    int rmid = wmid;
    int tmid = hei/2;
    int bmid = hei/2;
    while ((maze.get(tmid).charAt(lmid)!='.') && (maze.get(tmid).charAt(lmid)!='#')) lmid--;
    while ((maze.get(tmid).charAt(rmid)!='.') && (maze.get(tmid).charAt(rmid)!='#')) rmid++;
    while ((maze.get(tmid).charAt(wmid)!='.') && (maze.get(tmid).charAt(wmid)!='#')) tmid--;
    while ((maze.get(bmid).charAt(wmid)!='.') && (maze.get(bmid).charAt(wmid)!='#')) bmid++;

   
    for (int j=tmid+1; j<=bmid-1; j++) {
      if (maze.get(j).charAt(lmid+1)!=' ') {
        String portal = ""+maze.get(j).charAt(lmid+1)+maze.get(j).charAt(lmid+2);
        portals.put((j*wid)+lmid, portal);
        if (portal.equals("AA")) { startx = lmid; starty = j; }
        else if (portal.equals("ZZ")) { endx = lmid; endy = j; }
      }
      if (maze.get(j).charAt(rmid-2)!=' ') {
        String portal = ""+maze.get(j).charAt(rmid-2)+maze.get(j).charAt(rmid-1);
        portals.put((j*wid)+rmid, portal);
        if (portal.equals("AA")) { startx = rmid; starty = j; }
        else if (portal.equals("ZZ")) { endx = rmid; starty = j; }
      }
    }
   
    for (int i=lmid+1; i<=rmid-1; i++) {
      if (maze.get(tmid+1).charAt(i)!=' ') {
        String portal = ""+maze.get(tmid+1).charAt(i)+maze.get(tmid+2).charAt(i);
        portals.put((tmid*wid)+i, portal);
        if (portal.equals("AA")) { startx = i; starty = tmid; }
        else if (portal.equals("ZZ")) { endx = i; endy = tmid; }
      }
      if (maze.get(bmid-1).charAt(i)!=' ') {
        String portal = ""+maze.get(bmid-2).charAt(i)+maze.get(bmid-1).charAt(i);
        portals.put((bmid*wid)+i, portal);
        if (portal.equals("AA")) { startx = i; starty = bmid; }
        else if (portal.equals("ZZ")) { endx = i; endy = bmid; }
      }
    }
   
    int max_level = 200; // Might need to adjust this for other input!
   
    int[][][] dist = new int[hei][wid][max_level];
    for (int m=0; m<max_level; m++) for (int j=0; j<hei; j++) for (int i=0; i<wid; i++) dist[j][i][m] = Integer.MAX_VALUE;
   
    ArrayDeque<Integer> nextx = new ArrayDeque<Integer>();
    ArrayDeque<Integer> nexty = new ArrayDeque<Integer>();
    ArrayDeque<Integer> nextl = new ArrayDeque<Integer>();
    nextx.addLast(startx);
    nexty.addLast(starty);
    nextl.addLast(0);
   
    dist[starty][startx][0]=0;
   
    while (nextx.size()>0) {
      int x = nextx.removeFirst();
      int y = nexty.removeFirst();
      int lev = nextl.removeFirst();
      if (dist[y][x][lev] < dist[endy][endx][0]) {
        for (int i=0; i<=3; i++) {
          if (maze.get(y+dy[i]).charAt(x+dx[i]) == '.') {
            if (dist[y+dy[i]][x+dx[i]][lev] > dist[y][x][lev] + 1) {
              dist[y+dy[i]][x+dx[i]][lev] = dist[y][x][lev] + 1;
              nextx.add(x+dx[i]);
              nexty.add(y+dy[i]);
              nextl.add(lev);
            }
          }
        }
        String p1 = portals.get((y*wid)+x);
        if (p1!=null) {
          if ((!p1.equals("AA") && (!p1.equals("ZZ")))) {
            for (Map.Entry<Integer, String> entry : portals.entrySet()) {
              int pos = entry.getKey();
              String name = entry.getValue();
              int py = pos / wid;
              int px = pos % wid;
              int plev = lev;
            
              if (!part1) {
                if ((x==2) || (x==wid-3) || (y==2) || (y==hei-3)) plev--;
                else plev++;
              }
              if (plev>=0) {
                if ((name.equals(p1)) && (px!=x) && (py!=y)) {
                  if (dist[py][px][plev] > dist[y][x][lev] + 1) {
                    dist[py][px][plev] = dist[y][x][lev] + 1;
                    nextx.add(px);
                    nexty.add(py);
                    nextl.add(plev);
                  }
                }
              }
            }
          }
        }
      }
    }
    return dist[endy][endx][0];
  }
 
  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    System.out.println("Part 1: "+W.solve(W.readInput("../inputs/input_20.txt"), true));
    System.out.println("Part 2: "+W.solve(W.readInput("../inputs/input_20.txt"), false));
  }
}