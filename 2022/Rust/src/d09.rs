use crate::tools;
use std::collections::HashSet;

fn follow(tail : (i32, i32), head : (i32, i32)) -> (i32, i32) {
    if (tail.0.abs_diff(head.0) <= 1) & (tail.1.abs_diff(head.1) <= 1) {
        return (tail.0, tail.1);
    }
    if tail.0 == head.0 {
        return (tail.0, tail.1 + (head.1 - tail.1).signum());
    }
    if tail.1 == head.1 {
        return (tail.0 + (head.0 - tail.0).signum(), tail.1);
    }
    (tail.0 + (head.0 - tail.0).signum(), tail.1 + (head.1 - tail.1).signum())
}

pub fn _solve(input : &Vec<(char, u32)>, knot_count : u32) -> u32 {
    let mut knots = Vec::new();
    for _i in 0..knot_count {
        knots.push((0, 0));
    }
    let head = (knot_count - 1) as usize;
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

#[cfg(test)]
mod tests {
    use crate::*;
    #[test]
    fn test_day9() {
        let data = tools::read_file_contents_as_tuples("../inputs/d09-test1.txt");
        assert_eq!(d09::_solve(&data, 2), 13);
        assert_eq!(d09::_solve(&data, 10), 1);
        let data = tools::read_file_contents_as_tuples("../inputs/d09-test2.txt");
        assert_eq!(d09::_solve(&data, 10), 36);
    }
}
