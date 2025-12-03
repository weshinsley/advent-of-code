package d02;
import tools.Utils;
public class puzzle {
 
  public static int day2a(int[][] grid) {
    int total = 0;
    for (int i = 0; i < grid.length; i++) {
      int area1 = 2 * grid[i][0] * grid[i][1];
      int area2 = 2 * grid[i][0] * grid[i][2];
      int area3 = 2 * grid[i][1] * grid[i][2];
      total += area1 + area2 + area3 + (Utils.min(new int[] {area1, area2, area3}) / 2);
    }
    return total;
  }

  public static int day2b(int[][] grid) {
	  int total = 0;
	  for (int i = 0; i < grid.length; i++) {
      total += Utils.product(grid[i]) + (2 * Utils.sum(Utils.smallest_n(grid[i], 2)));		  
  	}
	  return total;
  }
 
  public static void main(String[] args) throws Exception {
    int[][] lines = Utils.readIntGrid("../inputs/input_2.txt", "x");
    System.out.println(day2a(lines));
    System.out.println(day2b(lines));
  }
}
