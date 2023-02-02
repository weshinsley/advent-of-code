use crate::tools;

pub fn solve() -> (u32, u32) {
    _solve("../inputs/d02-input.txt")
}

fn _solve(file : &str) -> (u32, u32) {
    static LOOKUP: [usize; 18] = [4, 1, 7, 8, 5, 2, 3, 9, 6,
                                  3, 1, 2, 4, 5, 6, 8, 9, 7];
    static AX: [usize; 2] = [65, 88];
    static MUL: [usize; 2] = [1, 3];

    let mut scores: [usize; 2] = [0, 0];

    for round in tools::read_file_contents(file).split('\n') {
        if !round.trim().is_empty() {
            let mut index : usize = 0;
            for (hand_no, hand) in round.split(' ').enumerate() {
                let hand_char = hand.chars().next().unwrap();
                index += ((hand_char as usize) - AX[hand_no]) * MUL[hand_no];
            }
            scores[0] += LOOKUP[index];
            scores[1] += LOOKUP[index + 9];
        }
    }
    (scores[0] as u32, scores[1] as u32)
}

#[cfg(test)]
mod tests {
    use crate::*;
    #[test]
    fn test_day2() {
        let res = d02::_solve("../inputs/d02-test.txt");
        assert_eq!(res.0, 15);
        assert_eq!(res.1, 12);
    }
}
