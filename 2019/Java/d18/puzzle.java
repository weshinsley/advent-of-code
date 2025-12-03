package d18;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.HashMap;

public class puzzle {
  static int[] dx = new int[] {0,1,0,-1};
  static int[] dy = new int[] {-1,0,1,0};
  ArrayList<ArrayList<HashMap<Long, int[]>>> lookup;
  
  ArrayList<StringBuffer> readInput(String f) throws Exception {
    ArrayList<StringBuffer> in = new ArrayList<StringBuffer>();
    BufferedReader br = new BufferedReader(new FileReader(f));
    String s = br.readLine();
    while (s!=null) {
      if (s.length()>1) in.add(new StringBuffer(s));
      s = br.readLine();
    }
    br.close();
    return in;
  }
  
  long encodeKeys(boolean[] gotkeys) {
    long encoded =0;
    long bit=1;
    for (int i=0; i<gotkeys.length; i++) {
      if (gotkeys[i]) encoded+=bit;
      bit*=2;
    }
    return encoded;
  }
  
  int[] getKeys(ArrayList<StringBuffer> maze, int startx, int starty, boolean[] gotkeys) {
    int[] cached = lookup.get(starty).get(startx).get(encodeKeys(gotkeys));
    if (cached != null) return cached;
    ArrayList<Integer> keys = new ArrayList<Integer>();
    int hei = maze.size();
    int wid = maze.get(0).length();
    int[][] distance = new int[hei][];
    for (int j=0; j<distance.length; j++) { 
      distance[j] = new int[wid];
      for (int i=0; i<wid; i++) distance[j][i]=-1;
    }
    
    
    ArrayDeque<Integer> nextx = new ArrayDeque<Integer>();
    ArrayDeque<Integer> nexty = new ArrayDeque<Integer>();
    distance[starty][startx]=0;
    nextx.add(startx);
    nexty.add(starty);
    
    while (nextx.size()>0) {
      int x = nextx.removeFirst();
      int y = nexty.removeFirst();

      for (int dir=0; dir<=3; dir++) {
        int x2 = x + dx[dir];
        int y2 = y + dy[dir];
        char ch = maze.get(y2).charAt(x2);

        if ((ch == '#') || (distance[y2][x2]!=-1)) continue;
        distance[y2][x2] = distance[y][x]+1;
        if ((ch >= 'A') && (ch <= 'Z') && (!gotkeys[ch - 'A'])) {
          continue;
        }
        if ((ch >= 'a') && (ch <= 'z') && (!gotkeys[ch - 'a'])) {
          keys.add(x2);
          keys.add(y2);
          keys.add((int)ch);
          keys.add(distance[y2][x2]);
        } else {
          nextx.add(x2);
          nexty.add(y2);
        }
      }
    }
    int[] arr = new int[keys.size()];
    for (int i=0; i<keys.size(); i++) arr[i]=keys.get(i);
    lookup.get(starty).get(startx).put(encodeKeys(gotkeys), arr);
    return arr;
  }
  
  int best = Integer.MAX_VALUE;
  
  void search(ArrayList<StringBuffer> map, int[] startx, int[] starty, boolean[] mykeys, int dist) {
    boolean got_all = true;
    for (int i=0; i<mykeys.length; i++) {
      if (!mykeys[i]) { got_all=false; break; }
    }
    if (got_all) {
      best = Math.min(best, dist);
      return;
    }
    int[][] keys = new int[startx.length][];
    int[] newx = new int[startx.length];
    int[] newy = new int[starty.length];
    for (int i=0; i<startx.length; i++) {
      keys[i] = getKeys(map, startx[i], starty[i], mykeys);
      newx[i] = startx[i];
      newy[i] = starty[i];
    }
    for (int j=0; j<keys.length; j++) {
      for (int i=0; i<keys[j].length; i+=4) {
        int kx = keys[j][i];
        int ky = keys[j][i+1];
        char kc = (char) keys[j][i+2];
        int kd = keys[j][i+3];
        mykeys[kc-'a'] = true;
        newx[j] = kx;
        newy[j] = ky;
        search(map, newx, newy, mykeys, dist + kd);
        newx[j] = startx[j];
        newy[j] = starty[j];
        mykeys[kc-'a'] = false;
      }
    }
  }
  
  int solve(ArrayList<StringBuffer> map, boolean adjust) {
    best = Integer.MAX_VALUE;
    int hei = map.size();
    int wid = map.get(0).length();
    lookup = new ArrayList<ArrayList<HashMap<Long, int[]>>>();
    int max_key=0;
    int starts=0;
    for (int j=0; j<hei; j++) {
      ArrayList<HashMap<Long, int[]>> row = new ArrayList<HashMap<Long, int[]>>();
      for (int i=0; i<wid; i++) {
        char ch = map.get(j).charAt(i);
        if (ch == '@') starts++;
        if ((ch >= 'a') && (ch <= 'z')) max_key = Math.max(max_key,  (ch - 'a'));
        row.add(new HashMap<Long, int[]>());
      }
      lookup.add(row);
    }
    
    if (adjust) {
      for (int j=0; j<hei; j++)
        for (int i=0; i<wid; i++)
          if (map.get(j).charAt(i) == '@') {  
            for (int ii=-1; ii<=1; ii++)
              for (int jj=-1; jj<=1; jj++)
                map.get(j+jj).setCharAt(i+ii, '#');
            for (int ii=-1; ii<=1; ii+=2) 
              for (int jj=-1; jj<=1; jj+=2)
                map.get(j+jj).setCharAt(i+ii, '@');
            i=wid;
            j=hei;
          }
      starts=4;
    }
    
    int[] startx = new int[starts];
    int[] starty = new int[starts];
    
    starts = 0;
  
  
    for (int j=0; j<hei; j++)
      for (int i=0; i<wid; i++)
        if (map.get(j).charAt(i) == '@') {
          startx[starts] = i;
          starty[starts++] = j;
        }
       
    boolean[] mykeys = new boolean[max_key+1];
    
    search(map, startx, starty, mykeys, 0);
    return best;
  }

  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    System.out.println("Part 1: "+W.solve(W.readInput("../inputs/input_18.txt"), false));
    System.out.println("Part 2: "+W.solve(W.readInput("../inputs/input_18.txt"), true));
  }
}