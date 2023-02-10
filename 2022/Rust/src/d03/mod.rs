use crate::tools;
use std::collections::HashSet;

pub fn solve() -> (u32, u32) {
    let data = tools::read_file_contents(&tools::find_input_path("03"));
    (solve_p1(data.clone()), solve_p2(data))
}

fn char_to_val(chr : char) -> u32 {
    let ch = chr as u32;
    if ch >= 97 {
        ch - 96
    } else {
        ch - 38
    }
}

fn find_p1_value(pack: String) -> char {
    let mut pack_chars = pack.chars();
    let mut letters = HashSet::new();
    let half = pack.len() / 2;

    for _i in 0..half {
        let one_char = pack_chars.next().unwrap();
        letters.insert(one_char);
    }
    for _i in 0..half {
        let one_char = pack_chars.next().unwrap();
        if letters.contains(&one_char) {
            return one_char;
        }
    }
    '0'
}

fn solve_p1(packs : String) -> u32 {
    let mut total = 0;
    for pack in packs.split('\n') {
        if !pack.is_empty() {
            let ch = find_p1_value(pack.to_string());
            total += char_to_val(ch);
        }
    }
    total
}

fn find_p2_value(pack1 : String, pack2 : String, pack3 : String) -> char {
    let mut pack1_hash = HashSet::new();
    let mut pack2_hash = HashSet::new();
    for each_char in pack1.chars() {
        pack1_hash.insert(each_char);
    }
    for each_char in pack2.chars() {
        if pack1_hash.contains(&each_char) {
            pack2_hash.insert(each_char);
        }
    }
    for each_char in pack3.chars() {
        if pack2_hash.contains(&each_char) {
            return each_char;
        }
    }
    '0'
}

fn solve_p2(packs : String) -> u32 {
    let pack_split = packs.split('\n');
    let pack_vec = pack_split.collect::<Vec<&str>>();
    let no_groups = 3 * (pack_vec.len() / 3);
    let mut total = 0;
    for i in (0..no_groups).step_by(3) {
        let ch = find_p2_value(pack_vec.get(i).unwrap().to_string(),
                                      pack_vec.get(i + 1).unwrap().to_string(),
                                      pack_vec.get(i + 2).unwrap().to_string());
        total += char_to_val(ch);
    }
    total
}

#[cfg(test)]
mod tests {
    use crate::*;
    #[test]
    fn test_day3() {
        let data = tools::read_file_contents("../inputs/d03-test.txt");
        let data_vec = data.split('\n').collect::<Vec<&str>>();
        let answers = ['p', 'L', 'P', 'v', 't', 's'];
        for (i, line) in data_vec.iter().enumerate() {
            if !line.is_empty() {
                let res = d03::find_p1_value(line.to_string());
                assert_eq!(res, answers[i]);
            }
        }

        assert_eq!(d03::solve_p1(data.clone()), 157);

        assert_eq!(d03::find_p2_value(data_vec[0].to_string(),
                                      data_vec[1].to_string(),
                                      data_vec[2].to_string()), 'r');
        assert_eq!(d03::find_p2_value(data_vec[3].to_string(),
                                      data_vec[4].to_string(),
                                      data_vec[5].to_string()), 'Z');
        assert_eq!(d03::solve_p2(data.clone()), 70);

    }
}
