use crate::tools;

pub fn parse(s : String) -> Vec<i32> {
    let mut x = 1;
    let mut time_series = Vec::new();
    time_series.push(0);
    time_series.push(x);
    for line in s.split('\n') {
        if line.is_empty() {
            continue;
        }
        if line.starts_with("noop") {
            time_series.push(x);

        } else {
            time_series.push(x);
            let val : i32 = line.split(' ').nth(1).unwrap().parse().unwrap();
            x += val;
            time_series.push(x);
        }
    }
    time_series
}

pub fn solve() -> (u32, String) {
    _solve(parse(tools::read_file_contents(&tools::find_input_path("10"))))
}

pub fn _solve(time_series : Vec<i32>) -> (u32, String) {
    let mut res1 : i32 = 0;
    let mut screen =  ".".repeat(249);
    screen.replace_range(0..2, "\n\n");
    screen.replace_range(247..249, "\n\n");
    for i in (20..221).step_by(40) {
        res1 += (i as i32) * time_series[i];
    }
    let mut cursor = 2;
    for (i, val) in time_series.iter().enumerate().take(240).skip(1) {
        if (((i - 1) % 40) as i32 - val).abs() <= 1 {
            screen.replace_range(cursor..(cursor + 1), "#");
        }
        cursor += 1;
        if (i  % 40) == 0 {
            screen.replace_range(cursor..(cursor + 1), "\n");
            cursor += 1;
        }
    }
    (res1 as u32, screen.to_string())
}
