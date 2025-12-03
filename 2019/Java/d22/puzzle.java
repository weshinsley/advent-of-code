package d22;

import java.io.BufferedReader;
import java.io.FileReader;
import java.math.BigInteger;
import java.util.ArrayList;


public class puzzle {
  ArrayList<Integer> function = new ArrayList<Integer>();
  ArrayList<Integer> param = new ArrayList<Integer>();

  final static int DEAL_NEW = 0;
  final static int DEAL_INC = 1;
  final static int CUT = 2;

  void readInput(String f) throws Exception {
    function.clear();
    param.clear();
    BufferedReader br = new BufferedReader(new FileReader(f));
    String s = br.readLine();
    while (s!=null) {
      if (s.equals("deal into new stack")) { function.add(DEAL_NEW); param.add(0); }
      else if (s.startsWith("deal with increment")) { function.add(DEAL_INC); param.add(Integer.parseInt(s.substring(20))); }
      else { function.add(CUT); param.add(Integer.parseInt(s.substring(4))); }
      s = br.readLine();
    }
    br.close();
  }

  long solve1(String f, long follow, long no_cards) throws Exception {
    readInput(f);
    for (int i=0; i<function.size(); i++) {
      if (function.get(i) == DEAL_NEW) follow = (no_cards-1) - follow;

      else if (function.get(i) == CUT) {
        follow -= param.get(i);
        if (follow < 0) follow+=no_cards;
        if (follow >= no_cards) follow-=no_cards;

      } else if (function.get(i) == DEAL_INC) {
        follow = (follow * param.get(i)) % no_cards;
      }
    }
    return follow;
  }

  // So. Part (b) is the sort of "you know it or you don't" kind of thing, and I would love to see
  // JamesT's haskell solution, as it's probably really elegant. I did a load of googling, still
  // couldn't figure it out, so, I have resorted to trying to write pseudocode from this workthrough
  //
  // https://www.reddit.com/r/adventofcode/comments/ee0rqi/2019_day_22_solutions/fbnkaju/
  //
  // which is a bit shameful, but even understanding the maths in the workthrough enough to code it
  // was enough of a challenge I found, to gain at least a morsel of satisfaction for the extra star.

  BigInteger solve2(String f, BigInteger no_cards, BigInteger no_shuffles, int pos) throws Exception {
    readInput(f);

    // Apparently, a key observation to make is that every possible deck can be encoded as a pair of:
    // (first number of deck = offset, and difference between two adjacent numbers = increment).

    //   Two more key observations I personally make.
    //      1. I did not notice this key observation at all.
    //      2. Even having read it, I still don't really get it, as it feels like the DEAL_INC will
    //         mess up all the adjacency. But anyway.

    // Apparently, we need to keep state in the form
    // (offset, increment) starting at (0,1) - so if we started at the first number (zero), with no offset,
    // and added 1 (the increment) each time, that would describe the initial state of our list.

    BigInteger increment_mul = BigInteger.valueOf(1L);
    BigInteger offset_diff = BigInteger.valueOf(0L);

    // Next, we have to go through our list of functions and combine them...

    for (int i=0; i<function.size(); i++) {
      int func = function.get(i);
      if (func == DEAL_NEW) {

        // So DEAL NEW reverses the list, which means the card numbers decrease instead of increase.
        // This much I'm sort of ok with.

        increment_mul = increment_mul.multiply(BigInteger.valueOf(-1));
        increment_mul = increment_mul.mod(no_cards);

        // Apparently, we also need to increment offset by the new increment. Which makes me think
        // I am not properly understanding what offset is...

        offset_diff = offset_diff.add(increment_mul);
        offset_diff = offset_diff.mod(no_cards);

      } else if (func == CUT) {

        // This is equivalent to offset += (increment * n)

        offset_diff = offset_diff.add(increment_mul.multiply(BigInteger.valueOf(param.get(i))));
        offset_diff = offset_diff.mod(no_cards);

      } else if (func == DEAL_INC) {

        // The description of this totally confuses me in the text. But, BigInteger does seem to have a "modPow" function, which
        // I think is what we want: increment * inv(n) where inv(n) = pow(n, MOD-2, MOD). where n is the DEAL INC param. This might
        // be called Euler's theorem.

        increment_mul = increment_mul.multiply(BigInteger.valueOf(param.get(i)).modPow(no_cards.subtract(BigInteger.valueOf(2)), no_cards));
        increment_mul = increment_mul.mod(no_cards);

      }
    }

    // Now, we apparently multiply this out for the number of shuffles...
    // Again, the maths is going way over me here. We want to multiply the increments together over the shuffles...


    BigInteger increment = increment_mul.modPow(no_shuffles, no_cards);

    // And the offsets are apparently ... something that becomes a geometric series... ummmm...
    // I'll just translate it.

    BigInteger one_minus_inc = BigInteger.valueOf(1L).subtract(increment);
    BigInteger one_minus_incmul = BigInteger.valueOf(1L).subtract(increment_mul).mod(no_cards);

    BigInteger offset = offset_diff.multiply(one_minus_inc).multiply(
      one_minus_incmul.modPow(no_cards.subtract(BigInteger.valueOf(2)), no_cards)).mod(no_cards);

    // Lastly, to get the 2020th index... this is apparently (all_offsets + i * all_increments) % cards.

    BigInteger v2020 = offset.add(BigInteger.valueOf(pos).multiply(increment)).mod(no_cards);
    return v2020;
  }

  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    System.out.println("Part 1: "+W.solve1("../inputs/input_22.txt", 2019, 10007));
    System.out.println("Part 2: "+W.solve2("../inputs/input_22.txt", BigInteger.valueOf(119315717514047L), BigInteger.valueOf(101741582076661L), 2020).toString());
  }
}

