use crate::tools;
use std::cmp;

pub fn make_map(input : String) -> ([[u8; 700]; 200], usize) {
    let mut grid = [[0u8; 700]; 200];
    let mut maxy = 0;
    for line in input.split('\n') {
        if line.is_empty() {
            break;
        }
        let mut oldx = 0;
        let mut oldy = 0;
        for (i, point) in line.split(" -> ").enumerate() {
            let mut coord = [0 ,0];
            for (dim, num) in point.split(',').enumerate() {
                coord[dim] = num.parse().unwrap();
                maxy = cmp::max(maxy, coord[1]);
            }
            if i > 0 {
                for x in cmp::min(oldx, coord[0])..=cmp::max(oldx, coord[0]) {
                    for cell in grid.iter_mut().take(cmp::max(oldy, coord[1]) + 1).skip(cmp::min(oldy, coord[1])) {
                        cell[x] = 1;
                    }
                }
            }
            oldx = coord[0];
            oldy = coord[1];
        }
    }
    (grid, maxy)
}

pub fn _solve(input : String) -> (u32, u32) {
    let map = make_map(input);
    let mut grid = map.0;
    let maxy = map.1;
    let mut p1_result = 0;
    let mut sand_count = 0;
    loop {
        let mut sandx = 500;
        let mut sandy = 0;
        if grid[sandy][sandx] != 0 {
            break;
        }
        loop {
            if sandy == maxy && p1_result == 0 {
                p1_result = sand_count;
            } else if sandy == maxy + 1 {
                grid[sandy][sandx] = 2;
                break;
            }

            if grid[sandy + 1][sandx] == 0 {
                sandy += 1
            } else if grid[sandy + 1][sandx - 1] == 0 {
                sandx -= 1;
                sandy += 1;
            } else if grid[sandy + 1][sandx + 1] == 0 {
                sandx += 1;
                sandy += 1;
            } else {
                grid[sandy][sandx] = 2;
                break;
            }
        }
        sand_count += 1;
    }
    (p1_result, sand_count)
}

pub fn solve() -> (u32, u32) {
    _solve(tools::read_file_contents(&tools::find_input_path("14")))
}
