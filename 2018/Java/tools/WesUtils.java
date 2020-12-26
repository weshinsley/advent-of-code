package tools;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Arrays;

public class WesUtils {
  
  public static ArrayList<String> readLines(String f) throws Exception {
    BufferedReader br = new BufferedReader(new FileReader(f));
    ArrayList<String> res = new ArrayList<String>();
    String s = br.readLine();
    while (s!=null) {
      res.add(s);
      s = br.readLine();
    }
    br.close();
    return res;	
  }
  
  public static ArrayList<StringBuilder> readLinesSB(String f) throws Exception {
    BufferedReader br = new BufferedReader(new FileReader(f));
    ArrayList<StringBuilder> res = new ArrayList<StringBuilder>();
    String s = br.readLine();
    while (s!=null) {
      res.add(new StringBuilder(s));
      s = br.readLine();
    }
    br.close();
    return res; 
  }
  
  public static ArrayList<Integer> toIntArrayList(ArrayList<String> a) {
    ArrayList<Integer> ai = new ArrayList<Integer>();
    for (int i=0; i<a.size(); i++) ai.add(Integer.parseInt(a.get(i)));
    return ai;
  }
  
  public static int[][] readIntGrid(String f, String sep) throws Exception {
    ArrayList<String> a = readLines(f);
    int[][] res = new int[a.size()][];
    for (int i=0; i<a.size(); i++) {
      String[] bits = a.get(i).split(sep);
      res[i] = new int[bits.length];
      for (int j=0; j<bits.length; j++) {
        res[i][j]=Integer.parseInt(bits[j]);
      }
    }
    return res;
  }
  
  public static int[][] createIntGrid(int x, int y) {
    int[][] g = new int[y][];
    for (int j=0; j<y; j++) g[j]=new int[x];
    return g;
  }
  
  public static int min(int[] x) {
    int m = x[0];
    for (int i=1; i<x.length; i++) if (x[i] < m) m = x[i];
    return m;
  }
  
  public static int min(ArrayList<Integer> x) {
    int m = x.get(0);
    for (int i=1; i<x.size(); i++) if (x.get(i) < m) m = x.get(i);
    return m;
  }
  
  public static int max(ArrayList<Integer> x) {
    int m = x.get(0);
    for (int i=1; i<x.size(); i++) if (x.get(i) > m) m = x.get(i);
    return m;
  }


  
  public static int product(int[] x) {
    int m = x[0];
    for (int i=1; i<x.length; i++) m *= x[i];
    return m;
  }
  
  public static int sum(int[][] x) {
    int s = 0;
    for (int j=0; j<x.length; j++) {
      s += sum(x[j]);
    }
    return s;
  }
  
  public static int sum(ArrayList<Integer> x) {
    return sum(x.stream().mapToInt(i -> i).toArray());
  }
  
  public static int sum(int[] x) {
    int m = x[0];
    for (int i=1; i<x.length; i++) m += x[i];
    return m;
  }
	  
  public static int[] smallest_n(int[] x, int n) {
    Arrays.sort(x);
    int[] res = new int[n];
    for (int i=0; i<n; i++) res[i]=x[i];
    return res;
  }
  
  public static boolean isInt(String s) {
    boolean isint = false;
    try {
      Integer.parseInt(s);
      isint = true;
    } catch (Exception e) {}
    return isint;
  }
  
  public static void test(int x, int y) {
    if (x!=y) System.out.println("TEST FAILED!");
  }
  public static void test(boolean x, boolean y) {
    if (x!=y) System.out.println("TEST FAILED!");
  }
  
  public static void copyGrid(int[][] x, int[][] y) {
    for (int j=0; j<x.length; j++) {
      for (int i=0; i<x[j].length; i++) {
        y[j][i] = x[j][i];
      }
    }
  }
  
  public static ArrayList<ArrayList<Integer>> newGrid() {
    ArrayList<ArrayList<Integer>> grid = new ArrayList<ArrayList<Integer>>();
    grid.add(new ArrayList<Integer>());
    grid.get(0).add(0);
    return grid;
  }
  
  public static void resize(ArrayList<ArrayList<Integer>> grid, int w, int h) {
    while (grid.get(0).size() <= w) {
      int extra = 1 + (w - grid.get(0).size());
      for (int j = 0; j < grid.size(); j++) {
        for (int i = 0; i < extra; i++) grid.get(j).add(0);
      }
    }
    
    while (grid.size() <= h) {
      int w0 = grid.get(0).size();
      ArrayList<Integer> newline = new ArrayList<Integer>();
      for (int i = 0; i < w0; i++) newline.add(0);
      grid.add(newline);
    }
  }
  
  public static ArrayList<Byte> toByteArray(String s) {
    ArrayList<Byte> b = new ArrayList<Byte>();
    for (int i=0; i<s.length(); i++) {
      b.add((byte) s.charAt(i));
    }
    return b;
  }
  
  public static ArrayList<Integer> toIntArray(String s) {
    ArrayList<Integer> b = new ArrayList<Integer>();
    for (int i=0; i<s.length(); i++) {
      b.add((int) s.charAt(i));
    }
    return b;
  }
  
  public static int count(int[] a, int x) {
    int t=0;
    for (int i=0; i<a.length; i++) t+=(a[i]==x)?1:-0;
    return t;
  }
  
  public static int count2d(int[][] a, int x) {
    int t=0;
    for (int i=0; i<a.length; i++) t+=count(a[i], x);
    return t;
  }
}
