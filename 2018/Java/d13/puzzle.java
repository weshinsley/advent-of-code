package d13;

import java.util.ArrayList;
import tools.WesUtils;

public class puzzle {
  ArrayList<StringBuilder> map;
  ArrayList<Integer> cart_x = new ArrayList<Integer>();
  ArrayList<Integer> cart_y = new ArrayList<Integer>();
  ArrayList<Integer> cart_dir = new ArrayList<Integer>();
  StringBuilder cart_char = new StringBuilder();
  ArrayList<Integer> inter_cc = new ArrayList<Integer>();
  
  byte UP = 0;
  byte  RIGHT = 1;
  byte DOWN = 2;
  byte LEFT = 3;
  
  final byte[] slash_dir = new byte[] {RIGHT, UP, LEFT, DOWN};
  final byte[] bslash_dir = new byte[] {LEFT, DOWN, RIGHT, UP};

  char[] carts = new char[] {'^','>','v','<'};
  char[] dirs = new char[] {'|','-','|','-'};
  
  void findCart(String c, int dir, StringBuilder s, int j) {
    int i = s.indexOf(c);
    while (i >= 0) {
      cart_x.add(i);
      cart_y.add(j);
      cart_dir.add(dir);
      inter_cc.add(0);
      cart_char.append(dirs[dir]);
      i = s.indexOf(c,i + 1);
    }
  }

  void findCarts() {
    for (int j = 0; j < map.size(); j++) {
      for (int k = 0; k < carts.length; k++) findCart(String.valueOf(carts[k]), k, map.get(j), j);
    }
  }
  
  void remove_cart(int i) {
    cart_x.remove(i);
    cart_y.remove(i);
    cart_dir.remove(i);
    cart_char.deleteCharAt(i);
    inter_cc.remove(i);
  }
  
  void sort_carts() {
    for (int i = 0; i < cart_x.size() - 1; i++) {
      int best_cart = i;
      int best_y = cart_y.get(i);
      int best_x = cart_x.get(i);
      for (int j = i + 1; j<cart_x.size(); j++) {
        if ((cart_y.get(j) < best_y) || ((cart_y.get(j) == best_y) && (cart_x.get(j) < best_x))) {
          best_cart = j;
          best_x = cart_x.get(j);
          best_y = cart_y.get(j);
        }
      }
    
      if (best_cart!=i) {
        int swap;
        swap = cart_x.get(i); cart_x.set(i, best_x); cart_x.set(best_cart, swap);
        swap = cart_y.get(i); cart_y.set(i, best_y); cart_y.set(best_cart, swap);
        swap = cart_dir.get(i); cart_dir.set(i, cart_dir.get(best_cart)); cart_dir.set(best_cart, swap);
        swap = inter_cc.get(i); inter_cc.set(i, inter_cc.get(best_cart)); inter_cc.set(best_cart, swap);
        char swapc = cart_char.charAt(i);  cart_char.setCharAt(i, cart_char.charAt(best_cart)); cart_char.setCharAt(best_cart, swapc);
      }
    }
  }
  
  void advent13(boolean remove_crashes, String input) throws Exception {
    map = WesUtils.readLinesSB(input);
    findCarts();
    boolean crash_flag;
    boolean last_tick = false;
    while(true) {
     sort_carts();
     int i = 0;
     while (i < cart_x.size()) {
       crash_flag = false;
       int x = cart_x.get(i);
       int y = cart_y.get(i);
       int d = cart_dir.get(i);
       map.get(y).setCharAt(x, cart_char.charAt(i));
       y = y + ((d == DOWN) ? 1 : ((d == UP) ? -1 : 0));
       x = x + ((d == RIGHT) ? 1 : ((d == LEFT) ? -1 : 0));
       char c = map.get(y).charAt(x);
       if ((c == 'v') || (c == '^') || (c == '<') || (c == '>')) {
         if (remove_crashes) {
           crash_flag = true;
           remove_cart(i);
           for (int j = 0; j < cart_x.size(); j++) {
             if ((cart_x.get(j) == x) && (cart_y.get(j) == y)) {
               map.get(cart_y.get(j)).setCharAt(cart_x.get(j), cart_char.charAt(j));
               remove_cart(j);
               if (j < i) i--;
               break;
             }
           }
           if (cart_x.size() == 1) last_tick = true;
         } else {
           System.out.println("Crash at "+x+","+y);
           return;
         }
       } else if (c == '/') d = slash_dir[d];
       else if (c == '\\') d = bslash_dir[d]; 
       
       else if ((c == '+')) {
         int cc = inter_cc.get(i);
         if (cc == 0) d = (d + 3) % 4;
         else if (cc == 2) d = (d + 1) % 4;
         inter_cc.set(i, (cc + 1) % 3);
       }
       if (!crash_flag) {
         cart_dir.set(i, d);
         cart_x.set(i, x);
         cart_y.set(i, y);
         cart_char.setCharAt(i, c);
         map.get(y).setCharAt(x, carts[d]);
         i++;
       }
     }

     if (last_tick) {
       System.out.println("Last cart: "+cart_x.get(0)+","+cart_y.get(0));
       return;
     }
    }
  }

  public static void main(String[] args) throws Exception {
    new puzzle().advent13(false, "../inputs/input_13.txt");
    new puzzle().advent13(true, "../inputs/input_13.txt");  
  }
}
