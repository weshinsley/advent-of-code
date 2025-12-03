use crate::tools;
use std::collections::HashSet;

fn follow(tail : (i32, i32), head : (i32, i32)) -> (i32, i32) {
    if (tail.0.abs_diff(head.0) <= 1) & (tail.1.abs_diff(head.1) <= 1) {
        return (tail.0, tail.1);
    }
    (if tail.0 == head.0 { tail.0} else { tail.0 + (head.0 - tail.0).signum() },
     if tail.1 == head.1 { tail.1} else { tail.1 + (head.1 - tail.1).signum() })
}

pub fn _solve(input : &Vec<(char, u32)>, knot_count : usize) -> u32 {
    let mut knots = vec![(0, 0); knot_count];
    let head = knot_count - 1;
    let mut history = HashSet::new();
    for m in input {
        for _n in 0..m.1 {
            knots[head].0 += if m.0 == 'R' { 1 } else if m.0 == 'L' { -1 } else { 0 };
            knots[head].1 += if m.0 == 'D' { 1 } else if m.0 == 'U' { -1 } else { 0 };
            for k in (1..=head).rev() {
                knots[k - 1] = follow(knots[k - 1], knots[k])
            }
            history.insert(knots[0]);
        }
    }
    history.len() as u32
}


pub fn solve() -> (u32, u32) {
    let input = tools::read_file_contents_as_tuples(&tools::find_input_path("09"));
    (_solve(&input, 2), _solve(&input, 10))
}
