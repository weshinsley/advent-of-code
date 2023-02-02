fn solve(file : &str) -> (u32, u32) {
  
  let input = std::fs::read_to_string(file).expect("Fatal Elf Error");
  let mut elves = Vec::new();

  for elf in input.split("\n\n") {
    let mut elf_total: u32 = 0;
    for weight in elf.split("\n") {
      if weight!= "" {
        let int_weight: u32 = weight.parse().unwrap();
        elf_total += int_weight;
       }
    }
    elves.push(elf_total);
  }

  elves.sort();
  elves.reverse();
  (elves[0], elves[0] + elves[1] + elves[2])
}

fn main() {
  let res = solve("../../../inputs/d01-input.txt");
  println!("Part 1: {}", res.0);
  println!("Part 2: {}", res.1);
}
