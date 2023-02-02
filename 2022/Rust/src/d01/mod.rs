use crate::tools;

pub fn solve() -> (u32, u32) {
    _solve("../inputs/d01-input.txt")
}

fn _solve(file : &str) -> (u32, u32) {
    let mut elves = Vec::new();

    for elf in tools::read_file_contents(file).split("\n\n") {
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



#[cfg(test)]
mod tests {
    use crate::*;
    #[test]
    fn test_day1() {
        let res = d01::_solve("../inputs/d01-test.txt");
        assert_eq!(res.0, 24000);
        assert_eq!(res.1, 45000);
    }
}
