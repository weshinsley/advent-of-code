package d10;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;

public class puzzle {

  ArrayList<StringBuffer> readInput(String s) throws Exception{
    ArrayList<StringBuffer> input = new ArrayList<StringBuffer>();
    BufferedReader br = new BufferedReader(new FileReader(s));
    String s2 = br.readLine();
    while (s2!=null) {
      input.add(new StringBuffer(s2));
      s2 = br.readLine();
    }
    br.close();
    return input;
  }

  int count_los(int ti, int tj, ArrayList<StringBuffer> map) {
    int count=0;
    for (int j=0; j<map.size(); j++) {
      for (int i=0; i<map.get(j).length(); i++) {
        if ((map.get(j).charAt(i)=='#') && ((i!=ti) || (j!=tj))) {
          int vx = ti-i;
          int vy = tj-j;
          if (vx==0) { vy /= Math.abs(vy); }
          else if (vy == 0) vx /= Math.abs(vx);
          else {
            for (int k = Math.max(Math.abs(vx), Math.abs(vy)); k>=2; k--) {
              if ((vx%k == 0) && (vy%k == 0)) {
                vx/=k;
                vy/=k;
              }
            }
          }
          boolean clear=true;
          int i2=i+vx;
          int j2=j+vy;
          while ((i2!=ti) || (j2!=tj)) {
            if (map.get(j2).charAt(i2) == '#') {
              clear=false;
              break;
            }
            i2+=vx;
            j2+=vy;
          }
          if (clear) count++;
        }
      }
    }
    return count;
  }

  int[] solve1(ArrayList<StringBuffer> map) {
    int best=0, bestx=-1, besty=-1;
    for (int j=0; j<map.size(); j++) {
      for (int i=0; i<map.get(j).length(); i++) {
        if (map.get(j).charAt(i) == '#') {
          int count = count_los(i, j, map);
          if (count>best) {
            best = count;
            bestx=i;
            besty=j;
          }
        }
      }
    }
    return new int[] {best, bestx, besty};
  }

  boolean eq(double a, double b) {
    return (Math.abs(a-b) < 1E-10);
  }

  int solve2(int x, int y, ArrayList<StringBuffer> map) {
    ArrayList<Double> angles = new ArrayList<Double>();
    ArrayList<Double> dists = new ArrayList<Double>();
    ArrayList<Integer> xs = new ArrayList<Integer>();
    ArrayList<Integer> ys = new ArrayList<Integer>();
    for (int j=0; j<map.size(); j++) {
      for (int i=0; i<map.get(j).length(); i++) {
        if ((map.get(j).charAt(i) == '#') && ((i!=x) || (j!=y))) {

          double dist = Math.sqrt(((i-x)*(i-x)) + ((j-y)*(j-y)));
          double angle=0;
          if ((i==x) && (j<y)) angle=0;
          else if ((i==x) && (j>y)) angle=Math.PI;
          else if ((j==y) && (i<x)) angle=1.5*Math.PI;
          else if ((j==y) && (i>x)) angle=0.5*Math.PI;
          else if ((i>x) && (j<y)) angle=Math.asin((i-x)/dist);
          else if ((i>x) && (j>y)) angle=(0.5*Math.PI) + Math.asin((j-y)/dist);
          else if ((i<x) && (j>y)) angle=Math.PI+ Math.asin((x-i)/dist);
          else if ((i<x) && (j<y)) angle=(1.5*Math.PI) + Math.asin((y-j)/dist);

          boolean inserted = false;
          for (int k=0; k<angles.size(); k++) {
            if ((angle < angles.get(k)) || (eq(angles.get(k), angle) && (dist < dists.get(k)))) {
              angles.add(k, angle);
              dists.add(k, dist);
              xs.add(k,i);
              ys.add(k,j);
              inserted = true;
              break;
            }
          }
          if (!inserted) {
            angles.add(angle);
            dists.add(dist);
            xs.add(i);
            ys.add(j);
          }
        }
      }
    }

    int hits=0;
    double angle = 0;
    int target_no = 0;
    while (true) {
      hits++;
      if (hits == 200) return (xs.get(target_no)*100) + ys.get(target_no);
      angle = angles.get(target_no);
      angles.remove(target_no);
      dists.remove(target_no);

      xs.remove(target_no);
      ys.remove(target_no);
      if (target_no == angles.size()) target_no = 0;
      while (eq(angles.get(target_no), angle)) {
        target_no++;
        if (target_no == angles.size()) target_no = 0;
      }
    }
  }

  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    ArrayList<StringBuffer> input = W.readInput("../inputs/input_10.txt");
    int[] part1 = W.solve1(input);
    System.out.println("Part 1: "+part1[0]+" at x = "+part1[1]+", y = "+part1[2]);
    System.out.println("Part 2: "+W.solve2(part1[1], part1[2], input));
  }
}
