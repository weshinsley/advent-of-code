use std::path::Path;

// cargo test    always uses the root as the working directory.
// cargo run     uses system current directory, so try to locat input path

pub fn find_input_path(day_string : &str) -> String {
    let mut depth = 0;
    let mut in_path = format!("inputs/d{day_string}-input.txt");
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

pub fn print_day(day : u32, res : (u32, u32)) {
    println!("Day {}:\t{}\t{}", day, res.0, res.1);
}