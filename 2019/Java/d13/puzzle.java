package d13;

import javax.swing.SwingUtilities;

import d09.wes_computer;


public class puzzle {
  char[] chars = new char[] {' ', '#', '*', '=', 'O'};
  
  int solve(wes_computer wc, int speed) {
    // I calculated maxx and maxy earlier...
    int maxx = 41;
    int maxy = 23;
    wes_screen ws = new wes_screen();
    ws.setVisible(true);
    char[][] grid = new char[maxy + 1][];
    for (int y = 0; y <= 23; y++) grid[y] = new char[maxx+1];
    wc.poke(0, 2);
    wc.run();
    int block = 0;

    for (int i = 0; i < (maxx + 1) * (maxy + 1); i++) {
      int x = (int) wc.read_output();
      int y = (int) wc.read_output();
      char z = (char) wc.read_output();
      grid[y][x] = z;
      if (z == 2) block++;
      ws.draw(x, y, z);
    }
    ws.repaint();
    System.out.println("Part 1: "+block);
    
    int score = 0;
    int ballx = 0;
    int paddlex = 0;
    int blocks = 0;
    
    wc.poke(0, 2);
    wc.run();

    while (true) {
      blocks = 0;
      for (int j = 0; j < grid.length; j++) {
        for (int i = 0; i < grid[j].length; i++) {
          if (grid[j][i] == 4) ballx = i;
          else if (grid[j][i] == 3) paddlex = i;
          else if (grid[j][i] == 2) blocks++;
        }
      }
      if (blocks == 0) {
        System.out.println("Part 2: "+score); System.exit(0);
      }
      if (ballx > paddlex) wc.add_input(1);
      else if (ballx < paddlex) wc.add_input(-1);
      else wc.add_input(0);
      wc.run();
      while (wc.output_available()) {
        int x = (int) wc.read_output();
        int y = (int) wc.read_output();
        int z = (int) wc.read_output();
        if ((x == -1) && (y == 0)) {
          score = (int) z;
          ws.score(score);
        }
        else {
          grid[y][x] = (char) z;
          ws.draw(x,y,z);
        }
      }
      ws.ip.update(ws.ip.getGraphics());

      try {
        Thread.sleep(speed);
      } catch (Exception e) { e.printStackTrace();}
    }
  }
  
  puzzle() {
    try {
      solve(wes_computer.wc_from_input("../inputs/input_13.txt"), 5);
    } catch (Exception e) { e.printStackTrace(); }
  }
  
  public static void main(String[] args) throws Exception {
    SwingUtilities.invokeLater(new Runnable() {
      public void run() {
        new puzzle();
      }
    });
  }
}
