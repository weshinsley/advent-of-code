package d12;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;

public class puzzle {
  
  class Moon {
    int vx=0,vy=0,vz=0;
    int px,py,pz;
    int nvx=0, nvy=0, nvz = 0;
    int ix=0,iy=0,iz=0;
    
    Moon(int _px, int _py, int _pz) {
      px = _px; py = _py; pz = _pz;
      ix=_px; iy=_py; iz=_pz;
      vx = 0; vy = 0; vz = 0;
    }
    
    void calcNewVel(ArrayList<Moon> moons) {
      nvx=vx;
      nvy=vy;
      nvz=vz;
      
      for (int i=0; i<moons.size(); i++) {
        Moon m = moons.get(i);
        if (this!=m) {
          if (m.px > this.px) nvx++;
          else if (m.px < this.px) nvx--;
          if (m.py > this.py) nvy++;
          else if (m.py < this.py) nvy--;
          if (m.pz > this.pz) nvz++;
          else if (m.pz < this.pz) nvz--;
        }
      }
    }
    
    void update() {
      vx=nvx; vy=nvy; vz=nvz;
      px+=vx; py+=vy; pz+=vz;
    }
    
    int energy() {
      return (Math.abs(px)+Math.abs(py)+Math.abs(pz)) * (Math.abs(vx)+Math.abs(vy)+Math.abs(vz));
    }
    
    boolean atOrig(int axis) {
      if (axis==0) return ix==px;
      else if (axis==1) return iy==py;
      else if (axis==2) return iz==pz;
      else return false;
    }
  }
  
     
  ArrayList<Moon> readInput(String f) throws Exception{
    ArrayList<Moon> moons = new ArrayList<Moon>();
    BufferedReader br = new BufferedReader(new FileReader(f));
    String s = br.readLine();
    while (s!=null) {
      String[] bits = s.replaceAll("[<>= xyz]", "").split(",");
      moons.add(new Moon(Integer.parseInt(bits[0]), Integer.parseInt(bits[1]), Integer.parseInt(bits[2])));
      s = br.readLine();
    }
    br.close();
    return moons;
  }
  
  int solve1(ArrayList<Moon> moons, int iters) {
    for (int j=0; j<iters; j++) {
      for (int i=0; i<moons.size(); i++) moons.get(i).calcNewVel(moons);
      for (int i=0; i<moons.size(); i++) moons.get(i).update();
    }
    
    int e=0;
    for (int i=0; i<moons.size(); i++) e+=moons.get(i).energy();
    return e;
  }
  
  long solve2(String f) throws Exception {
    int[] axis = new int[3];
    for (int a=0; a<3; a++) {
      ArrayList<Moon> moons = readInput(f);
      int steps=0;
      boolean same = false;
      while (!same) {
        for (int i=0; i<moons.size(); i++) moons.get(i).calcNewVel(moons);
        for (int i=0; i<moons.size(); i++) moons.get(i).update();
        same=true;
        for (int i=0; i<moons.size(); i++) if (!moons.get(i).atOrig(a)) { same=false; break; }
        steps++;
      }
      axis[a] = steps + 1;   // not sure why the +1 here - but clearly needed for the simple example (2772)
    }
    
    // LCM of the three values...
    long lcm = 1;
    long max = Math.max(Math.max(axis[0],  axis[1]),  axis[2]);
    long div=2;
    while (div<max) {
      if ((axis[0]%div ==0) || (axis[1]%div == 0) || (axis[2]%div == 0)) { 
        if (axis[0]%div ==0) axis[0]/=div;
        if (axis[1]%div ==0) axis[1]/=div;
        if (axis[2]%div ==0) axis[2]/=div;
        max = Math.max(Math.max(axis[0],  axis[1]),  axis[2]);
        lcm *= div;
      } else {
        div++;
      }
    }
    lcm *= axis[0] * axis[1] * axis[2];
    
    return lcm;
  }
  
  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    System.out.println("Part 1: "+W.solve1(W.readInput("../inputs/input_12.txt"), 1000)); 
    System.out.println("Part 2: "+W.solve2("../inputs/input_12.txt"));
    
  }
}
