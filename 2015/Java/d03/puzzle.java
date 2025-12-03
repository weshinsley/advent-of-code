package d03;
import tools.InfiniteGrid;
import tools.Utils;

public class puzzle {
  
  public static void doMove(InfiniteGrid ig, char c, int player) {
    if (c == 'v') ig.move(player, InfiniteGrid.SOUTH);
    else if (c == '<') ig.move(player, InfiniteGrid.WEST);
    else if (c == '>') ig.move(player, InfiniteGrid.EAST);
    else if (c == '^') ig.move(player, InfiniteGrid.NORTH);
    ig.write(ig.get(player) + 1, player);
  }
  
  public static int at_least_one(InfiniteGrid ig) {
    int at_least_one = 0;
    for (int j = 0; j < ig.getHeight(); j++) {
      for (int i = 0; i < ig.getWidth(); i++) {
        if (ig.get(i,j) >= 1) at_least_one++;
      }
    }
    return at_least_one;
  }
  
  public static int advent3a(String route) {
    InfiniteGrid ig = new InfiniteGrid(1);
    for (int i = 0; i<route.length(); i++) doMove(ig, route.charAt(i), 0);
    return at_least_one(ig);
  }
  
  public static int advent3b(String route) {
    InfiniteGrid ig = new InfiniteGrid(1, 2);
    int player = 0;
    for (int i = 0; i < route.length(); i++) {
      doMove(ig, route.charAt(i), player);
      player = 1 - player;
    }
    return at_least_one(ig);
  }
  
  public static void main(String[] args) throws Exception {
    String route = Utils.readLines("../inputs/input_3.txt").get(0);
    Utils.test(advent3a(""), 1);
    Utils.test(advent3a(">"), 2);
    Utils.test(advent3a("^>v<"), 4);
    Utils.test(advent3a("^v^v^v^v^v"), 2);
  
    System.out.println(advent3a(route));
    
    Utils.test(advent3b(""), 1);
    Utils.test(advent3b("^v"), 3);
    Utils.test(advent3b("^>v<"), 3);
    Utils.test(advent3b("^v^v^v^v^v"), 11);
    
    System.out.println(advent3b(route));
  }
}
