package d20;

import java.io.File;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class puzzle {

  class Tile {
    char[][] chars;
    char[][] spare;
    long id;
    
    Tile(int size) {
      chars = new char[size][size];
      spare = new char[size][size];
        
    }
    
    void update() {
      for (int i=0; i<chars.length; i++)
        for (int j=0; j<chars.length; j++)
          chars[i][j]=spare[i][j];      
    }
    
    void rotate() {
      for (int i=0; i<chars.length; i++)
        for (int j=0; j<chars.length; j++)
          spare[i][j]=chars[j][(chars.length-1)-i];
      update();
    }
    
    void flip() {
      for (int i=0; i<chars.length; i++)
        for (int j=0; j<chars.length; j++)
          spare[i][j]=chars[i][(chars.length-1)-j];
     update();
    }
    
    String getTop() {
      String s = "";
      for (int i=0; i<chars.length; i++) s+=chars[i][0];
      return s;
    
    }
    String getBottom() { 
      String s = "";
      for (int i=0; i<chars.length; i++) s+=chars[i][chars.length-1];
      return s;
    }
    String getLeft() { 
      String s = "";
      for (int j=0; j<chars.length; j++) s+=chars[0][j];
      return s;
    }
    String getRight() { 
      String s = "";
      for (int j=0; j<chars.length; j++) s+=chars[chars.length-1][j];
      return s;
    }
  }
  
  
  
  Tile[] read_input(String f) throws Exception {
    List<String> inp = Files.readAllLines(new File(f).toPath());
    int size = inp.size()/12;
    Tile[] res = new Tile[size];
    int i=0;
    for (int j=0; j<res.length; j++) {
      res[j] = new Tile(10);
      String s = inp.get(i++);
      res[j].id = Integer.parseInt(s.split("\\s+")[1].substring(0,4));
      for (int k=0; k<10; k++) {
        s = inp.get(i++);
        for (int m=0; m<10; m++) {
          res[j].chars[m][k] = s.charAt(m);
        }
      }
      i++;
    }
    return res;
  }
  
  long result=-1;
  
  boolean canPlace(Tile[] ts, Tile t, LinkedList<Integer> placed, int no, int size) {
    if (no == 0) return true;
    else if (no < size) return t.getLeft().equals(ts[placed.get(no-1)].getRight());
    else if (no % size == 0) 
      return t.getTop().equals(ts[placed.get(no-size)].getBottom());
    else 
      return (t.getLeft().equals(ts[placed.get(no-1)].getRight())
         && (t.getTop().equals(ts[placed.get(no-size)].getBottom()))); 
  }
  
  Tile big_tile;
      
  boolean recurse(Tile[] ts, LinkedList<Integer> placed, ArrayList<Integer> spare, int no, int size) {
    if (no == size*size) {
      result = ts[placed.get(0)].id;
      result *= ts[placed.get(size-1)].id;
      result *= ts[placed.get((size*size)-1)].id;
      result *= ts[placed.get((size*size)-size)].id;
      int dim = 8*size;
      big_tile = new Tile(dim);
      for (int ty=0; ty<size; ty++) {
        for (int tx=0; tx<size; tx++) {
          int newy = (ty*8);
          int newx = (tx*8);
          int orig = placed.get(tx + (ty * size));
          for (int px=1; px<=8; px++) 
            for (int py=1; py<=8; py++)
              big_tile.chars[newx+(px-1)][newy+(py-1)] = ts[orig].chars[px][py];
        }
      }
      return true;
    } else {
      boolean done = false;
      for (int i=0; i<spare.size(); i++) {
        int trythis = spare.get(i);
        for (int k=0; k<8; k++) {
          if (canPlace(ts, ts[trythis], placed, no, size)) {
            spare.remove(i);
            placed.add(trythis);
            done = recurse(ts, placed, spare, no + 1, size);
            if (done) return true;
            spare.add(i, trythis);
            placed.removeLast();
          }
          ts[trythis].rotate();
          if ((k==3) || (k==7)) ts[trythis].flip();
        }
      }
    }
    return false;
  }
  
  int solve2() {
    // ..................#..
    // #....##....##....###
    // .#..#..#..#..#..#...
 
    int monsters=0;
    int op=0;
    int[] xs = new int[] {18,0,5,6,11,12,17,18,19,1,4,7,10,13,16};
    int[] ys = new int[] {0, 1,1,1,1, 1,  1, 1, 1,2,2,2,2, 2, 2};
    while (monsters == 0) {
      for (int i=0; i<big_tile.chars.length-19; i++) {
        for (int j=0; j<big_tile.chars.length-2; j++) {
          boolean found = true;
          for (int k=0; k<xs.length; k++) {
            if (big_tile.chars[i+xs[k]][j+ys[k]] == '.') {
              found=false;
            }
          }
          if (found) {
            monsters++;
            for (int k=0; k<xs.length; k++) {
              big_tile.chars[i+xs[k]][j+ys[k]] = 'O';
            }
          }
        }
      }
      if (monsters == 0) {
        big_tile.rotate();
        if (op == 3) big_tile.flip();
        op++;
      }
    }
    int sea=0;
    for (int i=0; i<big_tile.chars.length; i++)
      for (int j=0; j<big_tile.chars.length; j++)
        if (big_tile.chars[j][i] == '#') sea++;
    return sea;
  }
    
  long solve(Tile[] ts) throws Exception {
    ArrayList<Integer> spare = new ArrayList<Integer>();
    for (int i=0; i<ts.length; i++) spare.add(i);
    recurse(ts, new LinkedList<Integer>(), spare, 0, (int) Math.sqrt(ts.length));
    return result;
  }

  void run() throws Exception {
    System.out.println("Advent of Code 2020 - Day 20\n----------------------------");
    System.out.println("Part 1: "+solve(read_input("../inputs/input_20.txt")));
    System.out.println("Part 2: "+solve2());

  }

  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
