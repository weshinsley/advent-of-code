use std::collections::HashSet;
use crate::tools;

pub fn solve() -> (u32, u32) {
    let data = tools::read_file_contents(&tools::find_input_path("06"));
    (_solve(data.clone(), 4), _solve(data, 14))
}

pub fn _solve(msg : String, window_size : i32) -> u32 {
    let chars : Vec<char> = msg.chars().collect();
    let mut letters = HashSet::new();
    let mut start: usize = 0;
    let mut end : usize = start + usize::try_from(window_size).unwrap();
    loop {
        letters.clear();
        let mut happy = true;
        for ch in  chars.iter().take(end).skip(start) {
            if letters.contains(ch) {
                happy = false;
                break;
            }
            letters.insert(ch);
        }
        if happy {
            return u32::try_from(end).unwrap();
        } else {
            start += 1;
            end += 1;
        }
    }
}
