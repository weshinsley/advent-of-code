package tools;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Arrays;

public class Utils {
  
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
  
  public static ArrayList<Integer> toIntArrayList(ArrayList<String> a) {
    ArrayList<Integer> ai = new ArrayList<Integer>();
    for (int i=0; i<a.size(); i++) ai.add(Integer.parseInt(a.get(i)));
    return ai;
  }
  
  public static int[][] readIntGrid_ji(String f, String sep) throws Exception {
    ArrayList<String> a = readLines(f);
    int[][] res = new int[a.size()][];
    for (int row=0; row<a.size(); row++) {
      String[] bits = a.get(row).trim().split(sep);
      res[row] = new int[bits.length];
      for (int col=0; col<bits.length; col++) {
        res[row][col]=Integer.parseInt(bits[col]);
      }
    }
    return res;
  }
  

  public static int[][] readIntGrid_ij(String f, String sep) throws Exception {
    ArrayList<String> a = readLines(f);
    int no_rows = a.size();
    int no_cols = a.get(0).trim().split(sep).length;
    int[][] res = new int[no_cols][no_rows];
    for (int row=0; row<a.size(); row++) {
      String[] bits = a.get(row).trim().split(sep);
      for (int col=0; col<bits.length; col++) {
        res[col][row]=Integer.parseInt(bits[col]);
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
  
  public static long product(long[] x) {
    long m = x[0];
    for (int i=1; i<x.length; i++) m *= x[i];
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
  
  public static long sum(long[] x) {
    long s = 0;
    for (int j=0; j<x.length; j++) {
      s += x[j];
    }
    return s;
  }
  
  public static int sum(ArrayList<Integer> x) {
    return sum(x.stream().mapToInt(i -> i).toArray());
  }
  
  public static long product(ArrayList<Long> x) {
    return product(x.stream().mapToLong(i -> i).toArray());
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
  
  public static long[] toLongArray(ArrayList<Integer> a) {
    long[] ll = new long[a.size()];
    for (int i=0; i<a.size(); i++) ll[i] = (long) a.get(i);
    return ll;
  }
  
  public static void test(int x, int y) throws Exception {
    if (x!=y) throw new Exception("TEST FAILED!");
  }
  public static void test(boolean x, boolean y) throws Exception {
    if (x!=y) throw new Exception("TEST FAILED!");
  }
  public static void test(String x, String y) throws Exception {
    if (!x.equals(y)) throw new Exception("TEST FAILED!");
  }
  
  
  public static void copyGrid(int[][] x, int[][] y) {
    for (int j=0; j<x.length; j++) {
      for (int i=0; i<x[j].length; i++) {
        y[j][i] = x[j][i];
      }
    }
  }
}
