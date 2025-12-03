use crate::tools;

pub enum Op {Add, Mul, Square}

pub struct Monkey {
    pub id : usize,
    pub holding : Vec<u64>,
    pub op : Op,
    pub op_param : u64,
    pub div_test : u64,
    pub true_monkey : usize,
    pub false_monkey : usize,
}

pub fn parse_single(id_s : &str, holding_s: &String, op_s : &String, div_test_s : &String,
                    true_monkey_s : &String, false_monkey_s : &String) -> Monkey {
    let mut worries = Vec::new();
    for worry in holding_s[18..(*holding_s).len()].split(", ") {
        worries.push(worry.parse().unwrap());
    }

    Monkey { id : id_s[7..8].parse().unwrap(),
             holding : worries,
             op : if &op_s[23..24] == "+" { Op::Add }
                  else if &op_s[25..26] == "o" { Op::Square }
                  else { Op::Mul },
             op_param : if &op_s[25..26] == "o" { 1 }
                        else { op_s[25..(*op_s).len()].parse().unwrap()},
             div_test : div_test_s[21..(*div_test_s).len()].parse().unwrap(),
             true_monkey : true_monkey_s[29..(*true_monkey_s).len()].parse().unwrap(),
             false_monkey : false_monkey_s[30..(*false_monkey_s).len()].parse().unwrap(),
    }
}

pub fn parse(input : &str) -> (Vec<Monkey>, u64) {
    let mut monkeys = Vec::new();
    let mut super_mod = 1;

    for monkey in input.split("\n\n") {
        let parts : Vec<String> = monkey.split('\n').map(str::to_string).collect();
        let new_monkey = parse_single(&parts[0], &parts[1], &parts[2], &parts[3], &parts[4], &parts[5]);
        super_mod *= new_monkey.div_test;
        monkeys.push(new_monkey);
    }
    (monkeys, super_mod)
}

pub fn _solve(input : &str, rounds : u32, divisor : u64) -> u64 {
    let mut monkeys = parse(input);
    let monkey_count = monkeys.0.len();
    let mut monkey_business = Vec::new();
    for _i in &monkeys.0 {
        monkey_business.push(0);
    }
    for _round in 0..rounds {
        for m in 0..monkey_count {
            monkey_business[monkeys.0[m].id] += monkeys.0[m].holding.len() as u64;
            let monkey_items = monkeys.0[m].holding.len();
            for item_no in 0..monkey_items {
                let mut new_worry = monkeys.0[m].holding[item_no];
                match monkeys.0[m].op {
                    Op::Add => new_worry += monkeys.0[m].op_param,
                    Op::Mul => new_worry *= monkeys.0[m].op_param,
                    Op::Square => new_worry *= new_worry,
                }
                new_worry /= divisor;
                new_worry %= monkeys.1;
                if new_worry % monkeys.0[m].div_test == 0 {
                    let dest = monkeys.0[m].true_monkey;
                    monkeys.0[dest].holding.push(new_worry);
                } else {
                    let dest = monkeys.0[m].false_monkey;
                    monkeys.0[dest].holding.push(new_worry);
                }
            }
            monkeys.0[m].holding.clear();
        }
    }
    monkey_business.sort();
    monkey_business.reverse();
    monkey_business[0] * monkey_business[1]
}

pub fn solve() -> (u64, u64) {
    let input = tools::read_file_contents(&tools::find_input_path("11"));
    (_solve(&input, 20, 3), _solve(&input, 10000, 1))
}
