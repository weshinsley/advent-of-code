package d24;

import java.io.File;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.List;

public class puzzle {

  int next_state(HashMap<String, Integer> m, int x, int y, int bw) {
    int neigh = (m.containsKey((x+2)+","+y)?m.get((x+2)+","+y):0) +
                (m.containsKey((x-2)+","+y)?m.get((x-2)+","+y):0) +
                (m.containsKey((x+1)+","+(y-1))?m.get((x+1)+","+(y-1)):0) +
                (m.containsKey((x-1)+","+(y-1))?m.get((x-1)+","+(y-1)):0) +
                (m.containsKey((x+1)+","+(y+1))?m.get((x+1)+","+(y+1)):0) +
                (m.containsKey((x-1)+","+(y+1))?m.get((x-1)+","+(y+1)):0);

    return (bw == 1) ? (((neigh == 0) || (neigh > 2)) ? 0 : 1)
                     : ((neigh == 2) ? 1 : 0);
  }

   int[] solve(List<String> tiles) {
     int[] result = new int[2];
     HashMap<String, Integer> map = new HashMap<String, Integer>();
     int black=0;
     for (int i=0; i<tiles.size(); i++) {
       String s = tiles.get(i);
       int x=0;
       int y=0;
       for (int j=0; j<s.length(); j++) {
         char ch = s.charAt(j);
         if (ch == 'e') { x+=2; }
         else if (ch == 'w') { x-=2; }
         else {
           char ch2 = s.charAt(++j);
           if ((ch== 'n') && (ch2 == 'e')) { x+=1; y-=1; }
           else if ((ch== 'n') && (ch2 == 'w')) { x-=1; y-=1; }
           else if ((ch== 's') && (ch2 == 'e')) { x+=1; y+=1; }
           else if ((ch== 's') && (ch2 == 'w')) { x-=1; y+=1; }
         }
       }
       String hash = x+","+y;
       if (map.containsKey(hash)) {
         int v = map.get(hash);
         black += (v==0) ? 1 : -1;
         map.put(hash,  1 - map.get(hash));
       } else {
         map.put(hash,  1);
         black++;
       }
     }
     result[0] = black;

     // Part 2

     HashMap<String, Integer> next_day = new HashMap<String, Integer>();

     int count=0;
     for (int day=0; day<100; day++) {
       count=0;

       for (String key : map.keySet()) {
         int x = Integer.parseInt(key.split(",")[0]);
         int y = Integer.parseInt(key.split(",")[1]);
         int bw = next_state(map, x, y, map.get(key));
         next_day.put(x+","+y, bw);
         count += (bw == 1) ? 1 : 0;

         // New tiles...

         for (int xx=x-2; xx <= x+2; xx+=4)
           if ((!map.containsKey(xx+","+y)) && (!next_day.containsKey(xx+","+y)) &&
              (next_state(map, xx, y, 0) == 1)) {
             next_day.put(xx+","+y, 1);
             count++;
           }

         for (int xx = x-1; xx <= x+1; xx+=2)
           for (int yy = y-1; yy<= y+1; yy+=2)
             if ((!map.containsKey(xx+","+yy)) &&
                 (!next_day.containsKey(xx+","+yy)) &&
                 (next_state(map,xx,yy, 0) == 1)) {
               next_day.put(xx+","+yy, 1);
               count++;
             }
       }
       map.clear();
       for (String key : next_day.keySet()) {
         map.put(key, next_day.get(key));
       }
       next_day.clear();
     }
     result[1] = count;
     return result;
  }


  void run() throws Exception {
    System.out.println("Advent of Code 2020 - Day 24\n----------------------------");
    int[] res = solve(Files.readAllLines(new File("../inputs/input_24.txt").toPath()));
    System.out.println("Part 1: "+res[0]);
    System.out.println("Part 2: "+res[1]);
  }

  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
