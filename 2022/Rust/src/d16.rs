use crate::tools;
use std::collections::HashSet;
use std::collections::HashMap;

// For a named room, find the shortest distance to all other rooms.

pub struct JourneySoFar {
    valve : usize,
    steps : usize,
}

pub fn shortest_paths(origin : usize,
                      reduce_map : &Vec<usize>,
                      connections : &Vec<Vec<usize>>) -> Vec<usize> {

    let mut queue = Vec::new();
    let mut best : Vec<usize> = Vec::new();

    // Best distance so far to all other valves, so we can prune
    // if we previously did better.

    for _i in 0..connections.len() {
        best.push(999);
    }

    // Pre-load the queue with start room (AA), and zero steps
    queue.push(JourneySoFar { valve : origin, steps : 0});

    while !queue.is_empty() {
        let current = queue.pop().unwrap();
        if best[current.valve] <= current.steps {
            continue;
        }

        best[current.valve] = current.steps;

        // Consider each place we could go to next.

        for con in connections[current.valve].iter() {
            if best[*con] > current.steps + 1 {
                queue.push(JourneySoFar { valve: *con, steps: current.steps + 1 });
            }
        }
    }

    // Reduce to just the interesting valves.
    let mut res = Vec::new();
    for i in reduce_map {
        res.push(best[*i]);
    }
    res
}


// Parse input file into vector of strings,
// valve_name,valve_rate,v1,v2...
// Ensure AA is first in the vector.

pub fn parse_file(input : String) -> Vec<String> {
    let mut res = Vec::new();
    for line in input.split('\n') {
        if line.is_empty() {
            continue;
        }
        let squidge = String::from(line).replace("Valve ", "").
            replace(" has flow rate=", ",").
            replace("; tunnel leads to valve ", ",").
            replace("; tunnels lead to valves ", ",").
            replace(' ', "");

        if squidge.starts_with("AA") {
            res.insert(0, squidge);
        } else {
            res.push(squidge);
        }
    }
    res
}

// Turn results of parse_file into a distance network of interesting valves

pub fn parse(input : String) -> (Vec<Vec<usize>>, Vec<u8>) {
    let mut valve_names = Vec::new();              // Index of names
    let mut valve_lookup = HashMap::new(); // Lookup names -> index
    let mut valve_rates = Vec::new();
    let mut valve_cons = Vec::new();

    for (n, line) in parse_file(input).iter().enumerate() {
        for (i, b) in line.split(',').enumerate() {
            let bit = String::from(b);
            if i == 0 { // Parse the name of the valve
                valve_lookup.insert(bit.clone(), n);
                valve_names.push(bit.clone());
                valve_cons.push(HashSet::new());

            } else if i == 1 { // Parse the rate of the valve
                let irate = bit.parse::<u8>().unwrap();
                valve_rates.push(irate);

            } else { // Parse what valves are connected to this one
                valve_cons[n].insert(bit.clone());
            }
        }
    }

    // Now we know what all the valves are, convert strings to indexes.

    let mut valve_cons_int = Vec::new();
    for exits in valve_cons.iter() {
        let mut exits_int = Vec::new();
        for exit in exits {
            let exit_int = *valve_lookup.get(exit).unwrap();
            exits_int.push(exit_int);
        }

        valve_cons_int.push(exits_int);

    }

    // We also need to reduce the problem size for recursion by only
    // considering interesting valves where rate > 0 - plus the
    // origin valve. Create sparse map from all nodes -> interesting ones.

    let mut reduce_map = Vec::new();
    let mut valve_list = Vec::new();
    reduce_map.push(0);
    valve_list.push(0);

    for (i, rate) in valve_rates.iter().enumerate() {
        if *rate > 0 {
            reduce_map.push(i);
            valve_list.push(*rate);
        }
    }

    // Next, we want to build an origin-destination matrix of just
    // the interesting places, via the non-interesting ones.

    let mut od = Vec::new();
    let reduce_map_copy = reduce_map.clone();
    for origin in reduce_map.iter_mut() {
        od.push(shortest_paths(*origin, &reduce_map_copy, &valve_cons_int));
    }

    // And now the rest of the problem works on just that origin-dest matrix,
    // and the list of useful valve values.
    (od, valve_list)
}

// State in my depth-first search:-

#[derive(Copy, Clone)]
pub struct StackState {
    position : usize,
    time_left : usize,
    valve_states : usize,
    tot_pressure : u32,
    prev_path : i8,
}

impl StackState {
    fn new(position : usize, time_left : usize, valve_states : usize,
           tot_pressure : u32, prev_path : i8) -> StackState {

        StackState { position, time_left, valve_states, tot_pressure, prev_path }
    }
}

pub fn dfs(od : &Vec<Vec<usize>>, valves : &Vec<u8>, time : usize) -> Vec<u32> {

    // So this is going to be a fairly grubby depth-first search with some
    // pruning, to avoid having to borrow or clone. Better ways surely must
    // exist, but they are probably in some later chapter...

    let pow2 = [1, 2, 4, 8, 16, 32, 64, 128,
                       256, 512, 1024, 2048, 4096, 8192, 16384, 32768];

    let mut best = Vec::new();
    let combos = 1 << valves.len();

    for _i in 0..combos {
        best.push(0);
    }

    let valve_count = od.len() as i8;
    let mut stack = Vec::new();

    // Seed the search. We're at position 0 at time 0 (time_left = time).
    // No valves turned on
    // Total pressure = 0, and we've not looked at any other paths from this state yet.

    stack.push(StackState::new(0, time, 0, 0, -1));

    // The DFS loop...

    while !stack.is_empty() {

        // Pop the state - we'll need to read it so we can backtrack...

        let mut state = stack.pop().unwrap();

        if state.tot_pressure > best[state.valve_states] {
            best[state.valve_states] = state.tot_pressure;
        }
        let mut new_state = state;

        // Decide next place to visit.
        // First update the state of the current place for backtracking...

        state.prev_path += 1;

        while state.prev_path < valve_count {
            if state.valve_states & pow2[state.prev_path as usize] == 0 {
                break;
            }
            state.prev_path += 1;
        }

        if state.prev_path == valve_count {
            continue;
        }

        stack.push(state);

        // Work out state for the room we'll move into...

        new_state.position = state.prev_path as usize;
        let new_time_left: i32 = (state.time_left as i32 - 1) - (od[state.position][new_state.position] as i32);

        if new_time_left > 0 {
            new_state.time_left = new_time_left as usize;
            new_state.tot_pressure += (new_time_left as u32) * (valves[new_state.position] as u32);
            new_state.valve_states |= pow2[new_state.position];
            new_state.prev_path = -1;
            stack.push(new_state);
        }
    }
    best
}

pub fn part1(res : Vec<u32>) -> u32 {
    let mut max = res[0];
    for num in res.iter().skip(1) {
        if *num > max {
            max = *num;
        }
    }
    max
}

pub fn part2(res : Vec<u32>) -> u32 {
    let max_num = res.len();
    let big = part1(res.clone());

    let mut best = 0;
    let mut bits = Vec::new();

    for i in 0..res.len() {
        if res[i] == 0 || res[i] + big < best {
            continue;
        }


        // Find all the numbers bitwise disjoint from i.

        bits.clear();

        let mut bit = 1;
        let mut cycles = 1;
        while bit < max_num {
            if (i & bit) == 0 {
                bits.push(bit);
                cycles *= 2;
            }
            bit *= 2;
        }

        // So say max_num is 127 (1111111), and i is 65 (1000001)
        // then bits will now contain (2,4,8,16,32) - matching the zeroes,
        // and cycles will be 32, as there are 32 combinations of 5 bits.

        for j in 0..cycles {
            let mut adj = 0;
            let mut bit = 1;
            let mut index = 0;
            while bit <= j {
                if (j & bit) >= 1 {
                    adj += bits[index];
                }
                index += 1;
                bit *= 2;
            }

            if res[adj] != 0 {
                let x = res[i] + res[adj];
                if x > best {
                    best = x;
                }
            }
        }
    }

    best
}

pub fn _solve(input : String) -> (u32, u32) {
    let (od, valves) = parse(input);
    (part1(dfs(&od, &valves, 30)), part2(dfs(&od, &valves, 26)))
}

pub fn solve() -> (u32, u32) {
    _solve(tools::read_file_contents(&tools::find_input_path("16")))
}

#[cfg(test)]
mod tests {
    use crate::*;
    #[test]
    fn test_day16() {
        let res = d16::_solve(tools::read_file_contents("../inputs/d16-test.txt"));
        assert_eq!(res.0, 1651);
        assert_eq!(res.1, 1707);
    }
}