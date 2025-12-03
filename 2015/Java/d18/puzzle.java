package d18;

import java.util.ArrayList;

import tools.Utils;

public class puzzle {
  int[][] grid = Utils.createIntGrid(100, 100);
  int[][] grid2 = Utils.createIntGrid(100, 100);
  
  void init(ArrayList<String> input) {
    for (int j=0; j<input.size(); j++) {
      for (int i=0; i<input.get(j).length(); i++) {
        grid[j][i] = (input.get(j).charAt(i)=='#')?1:0;
      }
    }
    Utils.copyGrid(grid,grid2);
  }
  
  int advent18(boolean partb) {
    if (partb) {
      grid[0][0]=1;
      grid[99][0]=1;
      grid[99][99]=1;
      grid[0][99]=1;
    }
    
    for (int step=0; step<100; step++) {
      for (int j=0; j<grid.length; j++) {
        for (int i=0; i<grid[j].length; i++) {
          int n_on=-grid[j][i];
          for (int jj=j-1; jj<=j+1; jj++) {
            for (int ii=i-1; ii<=i+1; ii++) {
              if ((ii>=0) && (ii<grid[0].length) && (jj>=0) && (jj<grid.length))
                n_on += grid[jj][ii];
            }
          }
          if (grid[j][i]==0) grid2[j][i] = (n_on==3)?1:0;
          else grid2[j][i] = (n_on==2 || n_on==3)?1:0;
        }
      }
      if (partb) {
        grid2[0][0]=1;
        grid2[99][0]=1;
        grid2[99][99]=1;
        grid2[0][99]=1;
      }
      Utils.copyGrid(grid2, grid);
    }
    int sum=0;
    for (int j=0; j<grid.length; j++) {
      for (int i=0; i<grid[j].length; i++) {
        sum+=grid[j][i];
      }
    }
    return sum;
  }
  
  public static void main(String[] args) throws Exception {
    ArrayList<String> input = Utils.readLines("../inputs/input_18.txt");
    puzzle p = new puzzle();
    p.init(input);
    System.out.println(p.advent18(false));
    p.init(input);
    System.out.println(p.advent18(true));
  }
}
