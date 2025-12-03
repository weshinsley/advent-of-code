use crate::tools;

pub fn part2(tower_heights : Vec<u32>) -> u64 {
    let mut diff_ints = Vec::new();
    for i in 1..tower_heights.len() {
        let diff = tower_heights[i] - tower_heights[i - 1];
        diff_ints.push(diff);
    }

    let burn_in = 500;
    let tot_cycles: i64 = 1000000000000;
    let mut try_start = burn_in + 1;

    loop {
        while diff_ints[try_start] != diff_ints[burn_in] {
            try_start += 1;
        }
        let mut success = true;
        let mut match_len = 1;
        while match_len < 1000 {
            if diff_ints[try_start + match_len] != diff_ints[burn_in + match_len] {
                success = false;
                break;
            }
            match_len += 1;
        }
        if success {
            break;
        }
        try_start += 1;
    }

    let cycle_height: i64 = tower_heights[try_start] as i64 - tower_heights[burn_in] as i64;
    let cycle_len = try_start as i64- burn_in as i64;
    let cycle_count = (tot_cycles - burn_in as i64) / cycle_len;
    let leftover_cycles = (tot_cycles - burn_in as i64) - (cycle_count * cycle_len);

    (tower_heights[burn_in] as i64 +
        (cycle_count * cycle_height) +
        tower_heights[burn_in + leftover_cycles as usize] as i64 - tower_heights[burn_in] as i64) as u64
}

pub fn _solve(input : String) -> (usize, u64) {
    let mut tower = vec![127, 0, 0, 0, 0];    // The tower, where index 0 = base (1111111).
    let mut tower_heights = vec![0; 5002]; // Record of tower height per drop
    let mut tower_top = 0;                    // Highest non-zero row in tower.

    let mut moves : Vec<char> = input.chars().collect();   // '<' or '>' -
    moves.pop(); // deal with empty at the end
    let mut move_no = 0;                         // Current position in move list.

    // The shapes, represented as bits in their initial position
    // And the current shape no...

    let shapes = vec![vec![30], vec![8, 28, 8], vec![4, 4, 28],
                                   vec![16, 16, 16, 16], vec![24, 24]];

    // Storage for current shape being dropped (which might get shifted left/right)
    // Allocate once with space for biggest shape

    let mut current_shape = vec![0, 0, 0, 0];
    let mut current_shape_height ;
    let mut shape_no = 0;

    // Loop for each new shape that gets dropped

    loop {

        // Copy shape into current_shape and remember the length.

        let shape_tmp = shapes.get(shape_no % 5).unwrap();
        current_shape_height = shape_tmp.len();
        let mut shape_bottom = tower_top + 4;     // Skip three blank lines.
        let mut shape_top = shape_bottom + (current_shape_height - 1);

        current_shape[..current_shape_height].copy_from_slice(&shape_tmp[..current_shape_height]);

        // Make sure that there's enough space in the tower for
        // three blank lines, plus this new shape.

        while tower_top + 3 + current_shape_height >= tower.len() {
            tower.push(0);
        }

        // Move shape until it rests.
        loop {

            // Horizontal movement

            let the_move = *moves.get(move_no).unwrap();

            if the_move == '<' {
                let mut move_left = true;
                for i in 0..current_shape_height  {
                    if current_shape[i] & 64 > 0 ||
                       tower[shape_top - i] & (current_shape[i] << 1) > 0 {
                        move_left = false;
                        break;
                    }
                }
                if move_left {
                    for line in current_shape.iter_mut() {
                        *line <<= 1;
                    }
                }
            } else {
                let mut move_right = true;
                for i in 0..current_shape_height {
                    if current_shape[i] & 1 > 0 ||
                        tower[shape_top - i] & (current_shape[i] >> 1) > 0 {
                        move_right = false;
                        break;
                    }
                }
                if move_right {
                    for line in current_shape.iter_mut() {
                        *line >>= 1;
                    }
                }
            }

            move_no = (move_no + 1) % moves.len();

            // Move vertically
            let mut move_down = true;
            for i in 0..current_shape_height {
                if tower[shape_top - (i + 1)] & current_shape[i] > 0 {
                    move_down = false;
                    break;
                }
            }

            if !move_down {
                break;
            }

            shape_top -= 1;
            shape_bottom -= 1;
        }
        for i in 0..current_shape_height {
            tower[shape_top - i] |= current_shape[i];
        }
        tower_top = tower.len() - 1;
        while tower[tower_top] == 0 {
            tower_top -= 1;
        }

        shape_no += 1;
        tower_heights[shape_no] = tower_top as u32;
        if shape_no == 5001 {
            return (tower_heights[2022] as usize, part2(tower_heights));
        }
    }
}

pub fn solve() -> (usize, u64) {
    _solve(tools::read_file_contents(&tools::find_input_path("17")))
}
