use std::collections::HashMap;
use crate::tools;

pub enum MonkeyOp {
    Add, Mul, Sub, Div
}

pub enum MonkeyShout {
    Value(i64),
    Func(MonkeyOp, String, String),
}

pub fn parse(input : String) -> HashMap<String, MonkeyShout> {
    let mut dictionary = HashMap::new();
    for line in input.split('\n') {
        if line.is_empty() {
           continue;
        }
        if let Some((key, value)) = line.split_once(": ") {
            if value.len() < 10 {
                let val : i64 = value.parse().unwrap();
                dictionary.insert(key.to_string(), MonkeyShout::Value(val));
                continue;
            }

            if let Some((lhs, rest)) = value.split_once(' ') {
                if let Some((op, rhs)) = rest.split_once(' ') {
                    let mop = match op {
                        "*" => MonkeyOp::Mul,
                        "+" => MonkeyOp::Add,
                        "-" => MonkeyOp::Sub,
                        "/" => MonkeyOp::Div,
                        _ => panic!("Unrecognised op")
                    };
                    dictionary.insert(key.to_string(),
                                      MonkeyShout::Func(mop, lhs.to_string(),
                                                        rhs.to_string()));

                }
            }

        }
    }
    dictionary
}

pub fn eval1(id : &String, dict : &HashMap<String, MonkeyShout>) -> i64 {
    let node = (*dict).get(id).unwrap();
    match node {
        MonkeyShout::Value(x) => *x,
        MonkeyShout::Func(op, lhs, rhs) => {
            let lhs_val = eval1(lhs, dict);
            let rhs_val = eval1(rhs, dict);
            match op {
                MonkeyOp::Add => lhs_val + rhs_val,
                MonkeyOp::Sub => lhs_val - rhs_val,
                MonkeyOp::Mul => lhs_val * rhs_val,
                MonkeyOp::Div => lhs_val / rhs_val,
            }
        }
   }
}

pub fn part1(dict : &HashMap<String, MonkeyShout>) -> i64 {
    eval1(&"root".to_string(), dict)
}

pub fn can_calculate(id : &String, dict : &HashMap<String, MonkeyShout>) -> bool {
    if id == "humn" {
        return false;
    }
    let node = (*dict).get(id).unwrap();
    match node {
        MonkeyShout::Value(_x) => true,
        MonkeyShout::Func(_op, lhs, rhs) =>
            can_calculate(lhs, dict) & can_calculate(rhs, dict)
    }
}

pub fn eval2(id : &String, answer : i64, dict: &HashMap<String, MonkeyShout>) -> i64 {
    if id == "humn" {
        return answer;
    }
    let node = (*dict).get(id).unwrap();
    match node {
        MonkeyShout::Value(x) => *x,
        MonkeyShout::Func(op, lhs, rhs) => {
            if can_calculate(lhs, dict) {
                let lhs_val = eval1(lhs, dict);
                match op {
                    MonkeyOp::Add => eval2(rhs, answer - lhs_val, dict),
                    MonkeyOp::Sub => eval2(rhs, lhs_val - answer, dict),
                    MonkeyOp::Mul => eval2(rhs, answer / lhs_val, dict),
                    MonkeyOp::Div => eval2(rhs, lhs_val / answer, dict),
                }
            } else {
                let rhs_val = eval1(rhs, dict);
                match op {
                    MonkeyOp::Add => eval2(lhs, answer - rhs_val, dict),
                    MonkeyOp::Sub => eval2(lhs, rhs_val + answer, dict),
                    MonkeyOp::Mul => eval2(lhs, answer / rhs_val, dict),
                    MonkeyOp::Div => eval2(lhs, rhs_val * answer, dict),
                }
            }
        }
    }
}

pub fn part2(dict : &mut HashMap<String, MonkeyShout>) -> i64 {
    dict.remove("humn");
    let node = dict.get("root").unwrap();
    if let MonkeyShout::Func(_op, lhs, rhs) = node {
        dict.insert("root".to_string(),
                    MonkeyShout::Func(MonkeyOp::Sub,
                                      lhs.to_string(),
                                      rhs.to_string()));
    }

    eval2(&"root".to_string(), 0, dict)
}

pub fn _solve(input : String) -> (i64, i64) {
    let mut dict = parse(input);
    let p1 = part1(&dict);
    let p2 = part2(&mut dict);
    (p1, p2)

}

pub fn solve() -> (i64, i64) {
    _solve(tools::read_file_contents(&tools::find_input_path("21")))
}
