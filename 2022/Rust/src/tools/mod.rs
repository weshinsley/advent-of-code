pub fn read_file_contents(file: &str) -> String {
    let input = std::fs::read_to_string(file).expect("Fatal Error");
    input.replace('\r', "")
}

pub fn print_day(day : u32, res : (u32, u32)) {
    println!("Day {}:\t{}\t{}", day, res.0, res.1);
}