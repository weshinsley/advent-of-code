use crate::tools;

pub fn solve() -> (u32, u32) {
    let data = tools::read_file_contents(&tools::find_input_path("04"));
    _solve(data)
}

pub fn _solve(data : String) -> (u32, u32) {
    let mut p1 = 0;
    let mut p2 = 0;
    for line in data.split('\n') {
        if line.is_empty() {
            continue;
        }
        let mut i = 0;
        let mut ints : [i32; 4] = [0, 0, 0, 0];
        for parts in line.split(',') {
            for coords in parts.split('-') {
                ints[i] = str::parse(coords).unwrap();
                i += 1;
            }
        }

        if (ints[0] <= ints[2]) && (ints[1] >= ints[3]) ||
           (ints[2] <= ints[0]) && (ints[3] >= ints[1]) {
            p1 += 1;
            p2 += 1;

        } else if (ints[0] <= ints[3]) && (ints[1] >= ints[2]) {
            p2 += 1;
        }
    }

    (p1, p2)
}
