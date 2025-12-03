use std::path::Path;
use std::fmt::Display;
use std::str::FromStr;

// cargo test    always uses the root as the working directory.
// cargo run     uses system current directory, so try to locate input path

pub fn find_input_path(day_string: &str) -> String {
    let mut depth = 0;
    let mut in_path = format!("inputs/input_{day_string}.txt");
    loop {
        if !(Path::new(&in_path).exists()) {
            in_path.insert_str(0, "../");
            depth += 1;
            if depth == 5 {
                panic!("Cannot find input file");
            }
        } else {
            return in_path.to_string();
        }
    }
}

pub fn read_file_contents(file: &str) -> String {
    let input = std::fs::read_to_string(file).expect("Fatal Error");
    input.replace('\r', "")
}

pub fn read_file_contents_as_i64s(file: &str) -> Vec<i64> {
    let strings = read_file_contents(file);
    let mut res : Vec<i64> = Vec::new();
    for line in strings.split('\n') {
        if !line.is_empty() {
            res.push(FromStr::from_str(line).unwrap());
        }
    }
    res
}

pub fn read_file_contents_as_char_grid(file: &str) -> Vec<Vec<char>> {
    let strings = read_file_contents(file);
    let mut res = Vec::new();
    for line in strings.split('\n') {
        let line_chars = line.chars().collect();
        res.push(line_chars);
    }
    res
}

pub fn read_file_contents_as_ascii_grid(file: &str) -> Vec<Vec<u16>> {
    let strings = read_file_contents(file);
    let mut res = Vec::new();
    for line in strings.split('\n') {
        if line.is_empty() {
            continue;
        }
        let mut new_line = Vec::new();
        for char in line.chars() {
            new_line.push(char as u16);
        }
        res.push(new_line);
    }
    res
}


pub fn read_file_contents_as_tuples(file: &str) -> Vec<(char, u32)> {
    let strings = read_file_contents(file);
    let mut res = Vec::new();
    for line in strings.split('\n') {
        if line.is_empty() {
            continue;
        }
        let mut parts = line.split(' ');
        let tup = (
            parts.next().unwrap().chars().next().unwrap(),
            parts.next().unwrap().parse::<u32>().unwrap(),
        );
        res.push(tup);
    }
    res
}

pub fn read_file_contents_as_u8_grid(file: &str) -> Vec<Vec<u8>> {
    let strings = read_file_contents(file);
    let mut res = Vec::new();
    for line in strings.split('\n') {
        if line.is_empty() {
            continue;
        }
        let mut line_ints = Vec::new();
        for ch in line.chars() {
            line_ints.push(u8::try_from(ch.to_digit(10).unwrap()).unwrap());
        }
        res.push(line_ints);
    }
    res
}

pub fn print_day(day : u32, res: (impl Display, impl Display)) {
    println!("Day {}:\t{}\t{}", day, res.0, res.1);
}