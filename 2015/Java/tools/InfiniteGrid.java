package tools;
import java.util.ArrayList;

public class InfiniteGrid {
  public static final byte NORTH = 1;
  public static final byte EAST= 2;
  public static final byte SOUTH = 3;
  public static final byte WEST = 4;

  ArrayList<ArrayList<Integer>> grid;
  ArrayList<Integer> x;
  ArrayList<Integer> y;

  public InfiniteGrid(int v, int players) {
	  grid = new ArrayList<ArrayList<Integer>>();
	  grid.add(new ArrayList<Integer>());
	  grid.get(0).add(v);
	  x = new ArrayList<Integer>();
	  y = new ArrayList<Integer>();
	  for (int i = 0; i < players; i++) { x.add(0); y.add(0); } 
  }
  public InfiniteGrid(int v) { this(v, 1); }
  public InfiniteGrid() { this(0, 1); }
  
  public int getWidth() { return grid.get(0).size(); }
  public int getHeight() { return grid.size(); }
  public void write(int i, int p) { grid.get(y.get(p)).set(x.get(p), i); }
  public void write(int i) { write(i, 0); }
  public void write(int _x, int _y, int i) { grid.get(_y).set(_x, i); }
  public int get(int p) { return grid.get(y.get(p)).get(x.get(p)); }
  public int get() { return get(0); }
  public int get(int _x, int _y) { return grid.get(_y).get(_x); }
  
  public void moveWest(int p) {
    x.set(p, x.get(p) - 1);
    if (x.get(p) == -1) {
      for (int j = 0; j < grid.size(); j++) {
        grid.get(j).add(0,0);
      }
      for (int i = 0; i < x.size(); i++) x.set(i, x.get(i) + 1);
    }
  }
  public void moveEast(int p) {
    x.set(p, x.get(p) + 1);
    if (x.get(p) == grid.get(0).size()) {
      for (int j = 0; j < grid.size(); j++) {
        grid.get(j).add(0);
      }
    }
  }
  
  public void moveNorth(int p) {
    y.set(p, y.get(p) - 1);
    if (y.get(p) == -1) {
      ArrayList<Integer> newArray = new ArrayList<Integer>();
      for (int i = 0; i < grid.get(0).size(); i++) newArray.add(0);
      grid.add(0, newArray);
      for (int i = 0; i < y.size(); i++) y.set(i, y.get(i) + 1); 
    }
  }
  
  public void moveSouth(int p) {
    y.set(p, y.get(p) + 1);
    if (y.get(p) == grid.size()) {
      ArrayList<Integer> newArray = new ArrayList<Integer>();
      for (int i = 0; i < grid.get(0).size(); i++) newArray.add(0);
      grid.add(newArray);
    }
  }
  
  public void moveSouth() { moveSouth(0); }
  public void moveNorth() { moveNorth(0); }
  public void moveWest() { moveWest(0); }
  public void moveEast() { moveEast(0); }      
  
  public void move(int p, int d) {
    if (d == NORTH) moveNorth(p);
    else if (d == SOUTH) moveSouth(p);
    else if (d == WEST) moveWest(p);
    else if (d == EAST) moveEast(p);
  }

  public void move(int d) { move(0,d); }    

}
