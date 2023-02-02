fn read_file_contents(file: &str) -> String {
    let input = std::fs::read_to_string(file).expect("Fatal Error");
    input.replace('\r', "")
}

fn solve(file : &str) -> (u32, u32) {
  let mut elves = Vec::new();

  for elf in read_file_contents(file).split("\n\n") {
    let mut elf_total: u32 = 0;
    for weight in elf.split('\n') {
      if !weight.is_empty() {
        elf_total += weight.parse::<u32>().unwrap();
       }
    }
    elves.push(elf_total);
  }

  elves.sort();
  elves.reverse();
  (elves[0], elves[0] + elves[1] + elves[2])
}

fn main() {
  let res = solve("../inputs/d01-input.txt");
  println!("Part 1: {}", res.0);
  println!("Part 2: {}", res.1);
}

#[cfg(test)]
mod tests {
  use crate::*;
  #[test]
  fn test_day1() {
    let res = solve("../inputs/d01-test.txt");
    assert_eq!(res.0, 24000);
    assert_eq!(res.1, 45000);
  }
}
