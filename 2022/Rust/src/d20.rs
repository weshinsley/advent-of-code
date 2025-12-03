use crate::tools;

pub fn run(input : &mut [i64], key : i64, rounds : u16) -> i64 {
    let mut zero_index = 0;
    let lenm1 : i64 = (input.len() - 1) as i64;
    for (n, element) in input.iter_mut().enumerate() {
        *element *= key;
        if *element == 0 {
            zero_index = n;
        }
    }

    let mut next_index = Vec::new();
    let mut prev_index = Vec::new();
    next_index.push(1);
    prev_index.push(input.len() - 1);
    for n in 1..input.len() {
        next_index.push(n + 1);
        prev_index.push(n - 1);
    }

    next_index[input.len() - 1] = 0;

    for _r in 0..rounds {
        for n in 0..input.len() {
            let steps = input[n] % lenm1;
            next_index[prev_index[n]] = next_index[n];
            prev_index[next_index[n]] = prev_index[n];
            let mut ptr = next_index[n];
            for _x in 0..steps.abs() {
                if steps < 0 {
                    ptr = prev_index[ptr];
                } else {
                    ptr = next_index[ptr];
                }
            }

            next_index[n] = ptr;
            prev_index[n] = prev_index[next_index[n]];
            next_index[prev_index[n]] = n;
            prev_index[next_index[n]] = n;
        }
    }

    let mut sum : i64 = 0;
    let mut n = zero_index;
    for _j in 0..3 {
        for _i in 0..1000 {
            n = next_index[n];
        }
        sum += input[n];
    }
    sum
}

pub fn _solve(input : &mut [i64]) -> (i64, i64) {
    (run(input, 1, 1), run(input, 811589153, 10))
}

pub fn solve() -> (i64, i64) {
    _solve(&mut tools::read_file_contents_as_i64s(&tools::find_input_path("20")))
}
