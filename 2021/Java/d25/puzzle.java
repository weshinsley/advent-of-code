package d25;
import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

import javax.imageio.ImageIO;
  
class puzzle {
  
  char[][] grid = null;
  char[][] grid2 = null;
  int wid = -1;
  int hei = -1;
  
  void readInput(String file) throws Exception {
    BufferedReader br = new BufferedReader(new FileReader(new File(file)));
    String s = br.readLine();
    wid = s.length();
    hei = 0;
    while (s!= null) {
      hei++;
      s = br.readLine();
    }
    br.close();
    br = new BufferedReader(new FileReader(new File(file)));
    grid = new char[hei][wid];
    grid2 = new char[hei][wid];
    for (int j=0; j<hei; j++) {
      s = br.readLine();
      for (int i=0; i<wid; i++) {
        grid[j] = s.toCharArray();
        grid2[j] = s.toCharArray();
      }
    }
    br.close();
 
  }
  
  public void copy(char[][] a, char[][] b) {
    for (int j=0; j<hei; j++) {
      for (int i=0; i<wid; i++) {
        b[j][i] = a[j][i];
      }
    }
  }
  
  public void plot(BufferedImage bi, int x, int y, char ch) {
    final int bed = new Color(32,192,32).getRGB();
    final int q1 = new Color(128,255,128).getRGB();
    final int q2 = new Color(96,224,96).getRGB();
    int w = bi.getWidth();
    int h = bi.getHeight();
    if (ch == '>') {
      bi.setRGB((x+2) % w,  (y+1) % h,  q1);
      bi.setRGB((x+3) % w,  (y+2) % h,  q1);
      bi.setRGB((x+4) % w,  (y+3) % h,  q1);
      bi.setRGB((x+3) % w,  (y+4) % h,  q1);
      bi.setRGB((x+2) % w,  (y+5) % h,  q1);
      bi.setRGB((x+3) % w,  (y+1) % h,  q2);
      bi.setRGB((x+4) % w,  (y+2) % h,  q2);
      bi.setRGB((x+5) % w,  (y+3) % h,  q2);
      bi.setRGB((x+4) % w,  (y+4) % h,  q2);
      bi.setRGB((x+3) % w,  (y+5) % h,  q2);
    } else if (ch == 'v') {
      bi.setRGB((x+2) % w,  (y+2) % h,  q1);
      bi.setRGB((x+3) % w,  (y+3) % h,  q1);
      bi.setRGB((x+4) % w,  (y+4) % h,  q1);
      bi.setRGB((x+5) % w,  (y+3) % h,  q1);
      bi.setRGB((x+6) % w,  (y+2) % h,  q1);
      bi.setRGB((x+2) % w,  (y+3) % h,  q2);
      bi.setRGB((x+3) % w,  (y+4) % h,  q2);
      bi.setRGB((x+4) % w,  (y+5) % h,  q2);
      bi.setRGB((x+5) % w,  (y+4) % h,  q2);
      bi.setRGB((x+6) % w,  (y+3) % h,  q2);
    }
  }
  
  public int writeFrames(char[][] grid, char[][] grid2, int start) throws Exception {
    final int bed = new Color(32,192,32).getRGB();
    for (int step=0; step<7; step++) {
      BufferedImage bi = new BufferedImage(wid * 7, hei * 7, BufferedImage.TYPE_3BYTE_BGR);
      for (int j=0; j<hei*7; j++)
        for (int i=0; i<wid*7; i++)
          bi.setRGB(i,  j,  bed);
      for (int j=0; j<hei; j++) {
        for (int i=0; i<wid; i++) {
          boolean anim = grid[j][i] != grid2[j][i];
          int d = (anim)? step : 0;
          if (grid[j][i] == '>') plot(bi, (i*7) + d, (j*7), grid[j][i]);
          else if (grid[j][i] == 'v') plot(bi, (i*7), (j*7)+d, grid[j][i]);
          else plot(bi, i*7, j*7, grid[j][i]);
        }
      }
      ImageIO.write(bi, "PNG",  new File("img"+start+".png"));
      start++;
    }
    return start;
  }
  
  public int solve(boolean cinema) throws Exception {
    int count = 0;
    int frame = 1;
    while(true) {
      boolean change = false;
      for (int j=0; j<hei; j++) {
        for (int i=0; i<wid; i++) {
          if (grid[j][i] == '>') {
            if (grid[j][(i + 1) % wid] == '.') {
              grid2[j][i] = '.';
              grid2[j][(i + 1) % wid] = '>';
              change = true;
            }
          }
        }
      }
      if (cinema) frame = writeFrames(grid, grid2, frame);
      copy(grid2, grid);
      
      
      for (int j=0; j<hei; j++) {
        for (int i=0; i<wid; i++) {
          if (grid[j][i] == 'v') {
            if (grid[(j + 1) % hei][i] == '.') {
              grid2[j][i] = '.';
              grid2[(j + 1) % hei][i] = 'v';
              change = true;
            }
          }
        }
      }
      count++;
      if (cinema) frame = writeFrames(grid, grid2, frame);
      if (!change) break;
      copy(grid2, grid);
    }
    return count;
  }
    
    
  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    W.readInput("../inputs/input_25.txt");
    System.out.println(W.solve(false));
  }
}
