use std::cmp::max;
use crate::tools;

pub struct BluePrint {
    id: u16,
    ore_costs_ore: u16,
    clay_costs_ore: u16,
    obs_costs_ore: u16,
    obs_costs_clay: u16,
    geo_costs_ore: u16,
    geo_costs_obs: u16
}

#[derive(Copy, Clone)]
pub struct State {
    at_end_of_minute: u16,
    ore_robots : u16,
    ore : u16,
    clay_robots : u16,
    clay : u16,
    obs_robots : u16,
    obs : u16,
    geode_robots : u16,
    geodes : u16,
}

fn state_timestep(state: &mut State) {
    state.at_end_of_minute += 1;
    state.ore += state.ore_robots;
    state.clay += state.clay_robots;
    state.obs += state.obs_robots;
    state.geodes += state.geode_robots;
}

pub fn parse(input : String) -> Vec<BluePrint> {
    let mut blueprints = Vec::new();
    for line in input.split('\n') {
        if line.is_empty() { continue; }
        let line = line
            .replace("Blueprint ", "")
            .replace(": Each ore robot costs ", ",")
            .replace(" ore. Each clay robot costs ", ",")
            .replace(" ore. Each obsidian robot costs ", ",")
            .replace(" ore and ", ",")
            .replace(" clay. Each geode robot costs ", ",")
            .replace(" obsidian.", "");
        let mut nums = Vec::new();
        for bit in line.split(',') {
            nums.push(bit.parse::<u16>().unwrap());
        }
        blueprints.push(BluePrint{
            id : nums[0],
            ore_costs_ore : nums[1],
            clay_costs_ore : nums[2],
            obs_costs_ore : nums[3],
            obs_costs_clay : nums[4],
            geo_costs_ore : nums[5],
            geo_costs_obs : nums[6]});
    }
    blueprints
}

pub fn _run(blueprint : &BluePrint, end_time : u16) -> u16 {
    let mut best = 0;

    // Prime queue with the events for building ore/clay robot.

    let mut queue = Vec::new();

    queue.push(State{at_end_of_minute : 0,
        ore_robots : 1, ore : 0, clay_robots : 0, clay : 0,
        obs_robots : 0, obs : 0, geode_robots : 0, geodes : 0});

    // Process queue and decide where to explore next.

    while !queue.is_empty() {
        let mut state = queue.pop().unwrap();

        if state.at_end_of_minute >= end_time {
            continue;
        }

        // What if we can't beat the best?

        let mut tmp_geode_robots = state.geode_robots;
        let mut tmp_geodes = state.geodes;
        for _t in state.at_end_of_minute .. end_time {
            tmp_geodes += tmp_geode_robots;
            tmp_geode_robots += 1;
        }

        if best > tmp_geodes {
            continue;
        }

        best = max(best, state.geodes);

        // If we can build a geode per timestep, then we can short-cut to
        // the end, as we can't do any better.

        if state.ore_robots >= blueprint.geo_costs_ore &&
            state.obs_robots >= blueprint.geo_costs_obs &&
            state.ore >= blueprint.geo_costs_ore &&
            state.obs >= blueprint.geo_costs_obs {

            while state.at_end_of_minute < end_time {
                state.geodes += state.geode_robots;
                state.geode_robots += 1;
                state.at_end_of_minute += 1;
            }
            best = max(best, state.geodes);
            continue;
        }

        // Schedule building of geode nodes

        if state.obs_robots > 0 {
            let mut state2 = state;
            while state2.at_end_of_minute < end_time {
                if state2.obs >= blueprint.geo_costs_obs &&
                    state2.ore >= blueprint.geo_costs_ore {
                        state_timestep(&mut state2);
                        state2.geode_robots += 1;
                        state2.obs -= blueprint.geo_costs_obs;
                        state2.ore -= blueprint.geo_costs_ore;
                        queue.push(state2);
                        break;
                }
                state_timestep(&mut state2);

            }
        }

        // Schedule building of obsidian nodes

        if state.clay_robots > 0 && state.obs_robots < blueprint.geo_costs_obs {
            let mut state2 = state;
            while state2.at_end_of_minute <= end_time {
                if state2.ore >= blueprint.obs_costs_ore && state2.clay >= blueprint.obs_costs_clay {
                    state_timestep(&mut state2);
                    state2.obs_robots += 1;
                    state2.ore -= blueprint.obs_costs_ore;
                    state2.clay -= blueprint.obs_costs_clay;
                    queue.push(state2);
                    break;
                }
                state_timestep(&mut state2);
            }
        }

        // Schedule building of clay robots
        if state.clay_robots < blueprint.obs_costs_clay {
            let mut state2 = state;
            while state2.at_end_of_minute <= end_time {
                if state2.ore >= blueprint.clay_costs_ore {
                    state_timestep(&mut state2);
                    state2.clay_robots += 1;
                    state2.ore -= blueprint.clay_costs_ore;
                    queue.push(state2);
                    break;
                }
                state_timestep(&mut state2);
            }
        }

        // Schedule building of ore robots
        if state.ore_robots < blueprint.ore_costs_ore + blueprint.clay_costs_ore + blueprint.obs_costs_ore + blueprint.geo_costs_ore {
            let mut state2 = state;
            while state2.at_end_of_minute < end_time {
                if state2.ore >= blueprint.ore_costs_ore {
                    state_timestep(&mut state2);
                    state2.ore_robots += 1;
                    state2.ore -= blueprint.ore_costs_ore;
                    queue.push(state2);
                    break;
                }
                state_timestep(&mut state2);
            }
        }

        // Calculate "do nothing until the end"
        while state.at_end_of_minute < end_time {
            state.geodes += state.geode_robots;
            state.at_end_of_minute += 1;
        }
        best = max(best, state.geodes);
    }

    best
}

pub fn run(blueprints : &[BluePrint], part : u16) -> u16 {
    let mut res = if part == 1 { 0 } else { 1 };
    let time = if part == 1 { 24 } else { 32 };

    for blueprint in blueprints.iter() {
        if part == 1 {
            let r = _run(blueprint, time);
            res += r * blueprint.id;
        } else {
            res *= _run(blueprint, time);
        }
    }
    res
}

pub fn _solve(input : String) -> (u16, u16) {
    let mut blueprints = parse(input);
    let part1 = run(&blueprints, 1);
    while blueprints.len() > 3 {
        blueprints.remove(blueprints.len() - 1);
    }
    (part1,run(&blueprints, 2))
}

pub fn solve() -> (u16, u16) {
    _solve(tools::read_file_contents(&tools::find_input_path("19")))
}
