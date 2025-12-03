use crate::tools;
use std::collections::HashMap;

pub fn solve() -> (u32, u32) {
    _solve(&tools::find_input_path("02"))
}

fn hardcoded_results() -> (HashMap<String, u32>, HashMap<String, u32>) {
    static COMBOS: [&str; 9] = ["A X", "B X", "C X", "A Y", "B Y", "C Y", "A Z", "B Z", "C Z"];
    static SCORES1: [u32; 9] = [4, 1, 7, 8, 5, 2, 3, 9, 6];
    static SCORES2: [u32; 9] = [3, 1, 2, 4, 5, 6, 8, 9, 7];

    let mut map1 = HashMap::new();
    let mut map2 = HashMap::new();

    for i in 0..9 {
        map1.insert(COMBOS[i].to_string(), SCORES1[i]);
        map2.insert(COMBOS[i].to_string(), SCORES2[i]);
    }
    (map1, map2)
}

fn _solve(file : &str) -> (u32, u32) {
    let maps = hardcoded_results();
    let mut scores: [u32; 2] = [0, 0];

    for round in tools::read_file_contents(file).split('\n') {
        if !round.trim().is_empty() {
            scores[0] += maps.0.get(round).unwrap();
            scores[1] += maps.1.get(round).unwrap();
        }
    }
    (scores[0], scores[1])
}
