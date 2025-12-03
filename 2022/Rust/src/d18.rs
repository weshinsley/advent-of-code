use std::cmp::max;
use std::collections::HashSet;
use crate::tools;

pub fn xyz_to_index(x : i32, y : i32, z : i32, dims : (i32, i32, i32)) -> i32 {
  x + (y * dims.0) + (z * dims.0 * dims.1)
}

pub fn bv(z : bool) -> i32 {
    if z { 1 } else { 0 }
}

pub struct Gubbins {
    cubes : Vec<(i32, i32, i32)>,
    map : HashSet<i32>,
    dims : (i32, i32, i32)
}

pub fn parse(input : String) -> Gubbins {
    let mut cubes = Vec::new();
    let mut dims = (0, 0, 0);
    for cube in input.split('\n') {
        if cube.is_empty() {
            continue
        }
        let mut xyz = Vec::new();
        for coord in cube.split(',') {
            xyz.push(coord.parse::<i32>().unwrap());
        }
        cubes.push((xyz[0] + 1, xyz[1] + 1, xyz[2] + 1));
        let xyz= cubes.last().unwrap();
        dims.0 = max(dims.0, xyz.0 + 2);
        dims.1 = max(dims.1, xyz.1 + 2);
        dims.2 = max(dims.2, xyz.2 + 2);
    }

    let mut map = HashSet::new();
    for cube in cubes.iter_mut() {
        map.insert(xyz_to_index(cube.0, cube.1, cube.2, dims));
    }
    Gubbins{ cubes, map, dims}
}

pub fn part1(cubes : &[(i32, i32, i32)], map : &HashSet<i32>, dims : &(i32, i32, i32)) -> i32 {
    let deltas: [[i32 ; 6] ; 3] = [[-1, 1, 0, 0, 0, 0], [0, 0, -1, 1, 0, 0], [0, 0, 0, 0, -1, 1]];
    let mut total = 0;
    for cube in cubes.iter() {
        for face in 0..6 {
            let nx = cube.0 + deltas[0][face];
            let ny = cube.1 + deltas[1][face];
            let nz = cube.2 + deltas[2][face];

            total += bv(!map.contains(
                &xyz_to_index(nx, ny, nz, *dims)));
        }
    }
    total
}

pub fn part2(map : &HashSet<i32>, dims : &(i32, i32, i32)) -> i32 {
    let deltas: [[i32 ; 6] ; 3] = [[-1, 1, 0, 0, 0, 0], [0, 0, -1, 1, 0, 0], [0, 0, 0, 0, -1, 1]];
    let mut queue = Vec::new();
    let mut visited = HashSet::new();
    let mut total = 0;
    queue.push((0, 0, 0));
    visited.insert(xyz_to_index(0, 0, 0, *dims));
    while !queue.is_empty() {
        let cube = queue.pop().unwrap();
        for face in 0..6 {
            let nx = cube.0 + deltas[0][face];
            let ny = cube.1 + deltas[1][face];
            let nz = cube.2 + deltas[2][face];
            if nx < 0 || ny < 0 || nz < 0 { continue; };
            if nx >= dims.0 || ny >= dims.1 || nz >= dims.2 { continue; }

            let index = xyz_to_index(nx, ny, nz, *dims);
            if map.contains( &index) {
                total += 1;
            } else if !visited.contains(&index) {
                queue.push((nx, ny, nz));
                visited.insert(index);
            }
        }
    }

    total
}

pub fn _solve(input : String) -> (i32, i32) {
    let d = parse(input);
    (part1(&d.cubes, &d.map, &d.dims),part2(&d.map, &d.dims))
}

pub fn solve() -> (i32, i32) {
    _solve(tools::read_file_contents(&tools::find_input_path("18")))
}
