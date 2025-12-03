use crate::tools;

struct Task{x : usize, y : usize, dx : i8, dy : i8, tallest : i8, xlast : usize, ylast : usize}

pub fn part1(input : &Vec<Vec<u8>>) -> u32 {
    let mut visited = input.clone();
    let size = input.len() - 1;
    let duff = size + 5;
    let mut tasks = Vec::new();
    for n in 1..size {   // Skip first and last. Below: RDLU
        tasks.push(Task {x : 0, y : n, dx : 1, dy : 0, tallest : -1, xlast : size, ylast : duff});
        tasks.push(Task {x : n, y : 0, dx : 0, dy : 1, tallest : -1, xlast : duff, ylast : size});
        tasks.push(Task {x : size, y : n, dx : -1, dy : 0, tallest : -1, xlast : 0, ylast : duff});
        tasks.push(Task {x : n, y : size, dx : 0, dy : -1, tallest : -1, xlast : duff, ylast : 0});
    }
    let mut total = 4;
    while !tasks.is_empty() {
        let mut task = tasks.pop().unwrap();
        loop {
            let tree_height = input[task.y][task.x] as i8;
            if tree_height > task.tallest {
                if visited[task.y][task.x] < 10 {
                    visited[task.y][task.x] = 10;
                    total += 1
                }
                task.tallest = tree_height;
            }
            if tree_height == 9 || task.x == task.xlast || task.y == task.ylast {
                break;
            }
            task.x = (task.x as i16 + task.dx as i16) as usize;
            task.y = (task.y as i16 + task.dy as i16) as usize;
        }
    }
    total
}

pub fn go_see(input : &[Vec<u8>], x: usize, y : usize, dx : i8, dy : i8, xlast : usize, ylast : usize) -> u32 {
    let my_height = input[y][x];
    let mut mx = x;
    let mut my = y;
    let mut count = 0;
    loop {
        mx = (mx as i16 + dx as i16) as usize;
        my = (my as i16 + dy as i16) as usize;
        count += 1;
        if (mx == xlast) || (my == ylast) || (input[my][mx] >= my_height) {
            break;
        }
    }
    count
}

pub fn part2(input : &Vec<Vec<u8>>) -> u32 {
    let size = input.len();
    let mut best = 0;
    for x in 1..size - 1 {
        for y in 1..size - 1 {
            let mut count = 1;
            count *= go_see(input, x, y, 1, 0, size - 1, 101);
            count *= go_see(input, x, y, -1, 0, 0, 101);
            count *= go_see(input, x, y, 0, 1, 101, size - 1);
            count *= go_see(input, x, y, 0, -1, 101, 0);
            if count > best {
                best = count;
            }
         }
    }
    best
}

pub fn _solve(input : Vec<Vec<u8>>) -> (u32, u32) {
    (part1(&input), part2(&input))
}

pub fn solve() -> (u32, u32) {
    _solve(tools::read_file_contents_as_u8_grid(&tools::find_input_path("08")))
}
