pub fn read_file_contents(file: &str) -> String {
    let input = std::fs::read_to_string(file).expect("Fatal Error");
    input.replace('\r', "")
}

pub fn print_day(res : (u32, u32)) {
    println!("Part 1: {}", res.0);
    println!("Part 2: {}", res.1);
}