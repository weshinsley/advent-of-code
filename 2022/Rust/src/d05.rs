use crate::tools;

pub struct CraneTask {
    stack_9000 : Vec<Vec<char>>,
    stack_9001 : Vec<Vec<char>>,
    instructions : Vec<(u32, usize, usize)>,
}

pub fn parse(input : Vec<Vec<char>>) -> CraneTask {
    let mut job = CraneTask {
        instructions : Vec::new(),
        stack_9000 : Vec::new(),
        stack_9001 : Vec::new(),
    };

    let mut blank_line = 0;

    // Find the blank line underneath the 1 2 3 row.

    while !input.get(blank_line).unwrap().is_empty() {
        blank_line += 1;
    }

    let name_line = blank_line - 1;

    // Parse the stacks from the bottom, so last element pushed
    // to the vector will be the top-most.
    let stack_names = input.get(name_line).unwrap();
    for i in (1..(*stack_names).len()).step_by(4) {
        let mut stack = Vec::new();
        for j in (0..name_line).rev() {
            let ch = *input.get(j).unwrap().get(i).unwrap();
            if ch != ' ' {
                stack.push(ch);
            }
        }
        job.stack_9000.push(stack.clone()); // push adds onto the end of a vector...!
        job.stack_9001.push(stack);
    }

    // Parse the instructions, which are all "move n from a to b"
    for inst_line in (blank_line + 1)..(input.len()) {
        let line = input.get(inst_line).unwrap();
        if line.is_empty() {
            continue;
        }
        let mut n = char::to_digit(*line.get(5).unwrap(), 10).unwrap();
        let mut extra = 0;
        if *line.get(6).unwrap() != ' ' {
            extra = 1;
            n = n * 10 + char::to_digit(*line.get(6).unwrap(), 10).unwrap();
        }
        let from = char::to_digit(*line.get(12 + extra).unwrap(), 10).unwrap() - 1;
        let to = char::to_digit(*line.get(17 + extra).unwrap(), 10).unwrap() - 1;
        job.instructions.push((n, usize::try_from(from).unwrap(), usize::try_from(to).unwrap()));
    }
    job
}

pub fn move_crates(instruction : (u32, usize, usize), stack : &mut [Vec<char>], one_by_one : bool) {
    let mut holding: Vec<char> = Vec::new();

    for _ in 0..instruction.0 {
        let ch = stack[instruction.1].pop().unwrap();
        holding.push(ch);
    }
    if one_by_one {
        holding.reverse();
    }
    for _ in 0..instruction.0 {
        stack[instruction.2].push(holding.pop().unwrap());
    }
}

pub fn tops(stacks : Vec<Vec<char>>) -> String {
    let mut res = String::new();
    for stack in stacks {
        res.push(*stack.last().unwrap());
    }
    res
}

pub fn solve() -> (String, String) {
    let data_path = tools::find_input_path("05");
    let data = tools::read_file_contents_as_char_grid(&data_path);
    _solve(data)
}

pub fn _solve(data : Vec<Vec<char>>) -> (String, String) {
    let mut job = parse(data);
    for inst in job.instructions {
        move_crates(inst, &mut job.stack_9000, true);
        move_crates(inst, &mut job.stack_9001, false);
    }
    (tops(job.stack_9000), tops(job.stack_9001))
}
