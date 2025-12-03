use crate::tools;

pub struct Puzzle {
    pub start : (i16, i16),
    pub finish : (i16, i16),
    pub map : Vec<Vec<u16>>,
    pub dist : Vec<Vec<u16>>,
    pub wid : i16,
    pub hei : i16,
}

pub fn parse(input: &str) -> Puzzle {
    let mut grid = tools::read_file_contents_as_ascii_grid(input);
    let mut end_pos = (0, 0);
    let mut start_pos = (0, 0);
    let mut found = 0;
    let hei = grid.len();
    let wid = grid[0].len();

    for (j, row) in grid.iter_mut().enumerate().take(hei) {
        for (i, col) in row.iter_mut().enumerate().take(wid) {
            match col {
                83 => {
                    start_pos = (i as i16, j as i16);
                    found += 1;
                    *col = 97;
                },
                69 => {
                    end_pos = (i as i16, j as i16);
                    found += 1;
                    *col = 122;
                }
                _ => {}
            }
            if found == 2 {
                break;
            }
        }
        if found == 2 {
            break;
        }
    }

    let mut empty_grid = Vec::new();
    for _j in 0..hei {
        empty_grid.push(vec![32767; wid]);
    }

    Puzzle {
        start: start_pos,
        finish: end_pos,
        map: grid,
        dist: empty_grid,
        wid : wid as i16,
        hei : hei as i16,
    }
}

pub fn _solve(file : &str) -> (u16, u16) {
    let mut puz = parse(file);
    let mut jobs = Vec::new();
    jobs.push((puz.finish.0, puz.finish.1));
    puz.dist[puz.finish.1 as usize][puz.finish.0 as usize] = 0;
    let dx : [i16 ; 4] = [0, 1, 0, -1];
    let dy : [i16 ; 4] = [-1, 0, 1, 0];
    let mut best_p2 : u16 = 32767;
    let mut best_p1 : u16 = 32767;

    while !jobs.is_empty() {
        let pos = jobs.pop().unwrap();
        let dist_so_far = puz.dist[pos.1 as usize][pos.0 as usize];
        let my_height = puz.map[pos.1 as usize][pos.0 as usize];
        if my_height == 97 {             // We reached an 'a' - is it the best?
            if dist_so_far < best_p2 {
                best_p2 = dist_so_far;
            }
            if pos.0 == puz.start.0 && pos.1 == puz.start.1 { // We reached 'S'
                if dist_so_far < best_p1 {
                    best_p1 = dist_so_far;
                }
            }
        }

        if dist_so_far > best_p1 { // If worse than the best so far to 'S', prune.
            continue
        }

        for dir in 0..4 {
            let next_x = pos.0 + dx[dir];
            let next_y = pos.1 + dy[dir];
            if next_x >= 0 && next_x < puz.wid && next_y >= 0 && next_y < puz.hei {
                let next_ux = next_x as usize;
                let next_uy = next_y as usize;
                let next_height = puz.map[next_uy][next_ux];
                let next_dist = puz.dist[next_uy][next_ux];
                if next_height >= (my_height - 1) && next_dist > (dist_so_far + 1) {
                    jobs.push((next_x, next_y));
                    puz.dist[next_uy][next_ux] = dist_so_far + 1;
                }
            }
        }
    }
    (best_p1, best_p2)
}

pub fn solve() -> (u16, u16) {
    _solve(&tools::find_input_path("12"))
}
