use crate::tools;

pub enum Op {Add, Mul, Square}

pub struct Monkey {
    pub id : usize,
    pub holding : Vec<u32>,
    pub op : Op,
    pub op_param : u32,
    pub div_test : u32,
    pub true_monkey : usize,
    pub false_monkey : usize,
}

pub fn parse_single(id_s : &String, holding_s: &String, op_s : &String, div_test_s : &String,
                    true_monkey_s : &String, false_monkey_s : &String) -> Monkey {
    let mut worries = Vec::new();
    for worry in holding_s[18..(*holding_s).len()].split(", ") {
        worries.push(worry.parse().unwrap());
    }

    Monkey { id : id_s[7..8].parse().unwrap(),
             holding : worries,
             op : if &op_s[23..24] == "+" { Op::Add }
                  else if &op_s[25..26] == "o" { Op::Square }
                  else { Op::Add},
             op_param : if &op_s[25..26] == "o" { 1 }
                        else { op_s[25..(*op_s).len()].parse().unwrap()},
             div_test : div_test_s[21..(*div_test_s).len()].parse().unwrap(),
             true_monkey : true_monkey_s[29..(*true_monkey_s).len()].parse().unwrap(),
             false_monkey : false_monkey_s[30..(*false_monkey_s).len()].parse().unwrap(),
    }
}

pub fn parse(input : &String) -> (Vec<Monkey>, u32) {
    let mut monkeys = Vec::new();
    let mut super_mod = 1;
    let mut line_no = 0;

    for monkey in input.split("\n\n") {
        let parts : Vec<String> = monkey.split('\n').map(str::to_string).collect();
        let new_monkey = parse_single(&parts[0], &parts[1], &parts[2], &parts[3], &parts[4], &parts[5]);
        super_mod *= new_monkey.div_test;
        monkeys.push(new_monkey);
    }
    println!("{}", super_mod);
    (monkeys, super_mod)
}

pub fn _solve(input : &String, rounds : u32, divisor : u32) -> u32 {
    let mut monkeys = parse(input);
    let mut monkey_business = Vec::new();
    for _i in &monkeys.0 {
        monkey_business.push(0);
    }
    for round in 0..rounds {
        for monkey in &mut monkeys.0 {
            monkey_business[monkey.id] += monkey.holding.len() as u32;
            for worry in &monkey.holding {
                let mut new_worry = worry / divisor;
                match monkey.op {
                    Op::Add => new_worry += monkey.op_param,
                    Op::Mul => new_worry *= monkey.op_param,
                    Op::Square => new_worry *= new_worry,
                }
                new_worry %= monkeys.1;
                if new_worry % monkey.div_test == 0 {
                    monkeys.0[monkey.true_monkey].holding.push(new_worry);
                } else {
                    monkeys.0[monkey.false_monkey].holding.push(new_worry)
                }
            }
            monkey.holding.clear();
        }
    }
    monkey_business.sort();
    monkey_business[0] * monkey_business[1]
}

pub fn solve() -> (u32, u32) {
    let input = tools::read_file_contents(&tools::find_input_path("11"));
    (_solve(&input, 20, 3), _solve(&input, 10000, 1))
}

#[cfg(test)]
mod tests {
    use crate::*;
    #[test]
    fn test_day11() {
        let input = tools::read_file_contents("../inputs/d11-test.txt");
        let res = (d11::_solve(&input, 20, 3), d11::_solve(&input, 10000, 1));
        assert_eq!(res.0, 10605);
        assert_eq!(res.1, 2713310158);
    }
}
