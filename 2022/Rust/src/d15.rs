use crate::tools;
use std::collections::HashSet;

pub struct Sensor {
    x : i32,
    y : i32,
    bx : i32,
    by : i32,
    md : i32,
}

pub fn parse(input : String) -> Vec<Sensor> {
    let mut res = Vec::new();
    for line in input.split('\n') {
        if line.is_empty() {
            continue;
        }
        let new_str = line.replace("Sensor at x=", "").
            replace(", y=", ",").
            replace(": closest beacon is at x=", ",");

        let bits : Vec<&str> = new_str.split(',').collect();
        let x = bits[0].parse().unwrap();
        let y = bits[1].parse().unwrap();
        let bx = bits[2].parse().unwrap();
        let by = bits[3].parse().unwrap();
        let md = i32::abs(x - bx) + i32::abs(y - by);
        res.push(Sensor {x, y, bx, by, md});
    }
    res
}

pub fn part1(sensors : &[Sensor], yval : i32) -> u32 {
    let mut beaconxs = HashSet::new();
    for sensor in sensors.iter() {
        if sensor.by == yval && !beaconxs.contains(&sensor.bx) {
            beaconxs.insert(&sensor.bx);
        }
    }

    let mut ranges = Vec::new();
    for sensor in sensors.iter() {
        if yval >= sensor.y - sensor.md && yval <= sensor.y + sensor.md {
            let xdist = i32::abs(sensor.md - i32::abs(sensor.y - yval));
            ranges.push((sensor.x - xdist, sensor.x + xdist));
        }
    }
    ranges.sort_by(|a, b| Ord::cmp(&a.0, &b.0));

    let mut row1 = 0;
    let mut row2 = 1;
    let mut range1 = *ranges.get(row1).unwrap();
    let mut range2 = *ranges.get(row2).unwrap();
    let mut count = (range1.1 - range1.0) + 1;

    loop {
        if range2.1 <= range1.1 {  // if range2 is inside range 1, ignore it.
            row2 += 1;

        } else if range2.0 > range1.1 { // if range2 is fully after range 1, count it.
            count += (range2.1 - range2.0) + 1;
            row1 = row2;
            range1 = *ranges.get(row1).unwrap();
            row2 += 1;

        } else {  // Else overlap - adjust left hand to avoid double-count
            range2.0 = range1.1 + 1;
            count += (range2.1 - range2.0) + 1;
            row1 = row2;
            let nextx = range1.1 + 1;
            range1 = *ranges.get(row1).unwrap();
            range1.0 = nextx;
            row2 += 1;
        }
        if row2 == ranges.len() {
            break;
        }
        range2 = *ranges.get(row2).unwrap();
    }
    (count -  (beaconxs.len() as i32)) as u32
}

pub fn check_inside(px : i32, py : i32, sensors : &[Sensor], exclude : usize, range : i32) -> Option<u64> {
    if px < 0 || px > range || py < 0 || py > range {
        return None;
    }

    for (i, sensor) in sensors.iter().enumerate() {
        if i == exclude {
            continue;
        }
        if i32::abs(sensor.x - px) + i32::abs(sensor.y - py) <= sensor.md {
            return None
        }
    }
    Some(((px as u64) * 4000000) + py as u64)
}

pub fn part2(sensors : &[Sensor], range : i32) -> u64 {
    for (i, s) in sensors.iter().enumerate() {
        for d in 0..s.md {
            if let Some(res) = check_inside(s.x + d, ((s.y - s.md) - 1) + d, sensors, i, range) {
                return res;
            }
            if let Some(res) = check_inside((s.x + s.md + 1) - d, s.y + d, sensors, i, range) {
                return res;
            }
            if let Some(res) = check_inside(s.x - d, (s.y + s.md + 1) - d, sensors, i, range) {
                return res;
            }
            if let Some(res) = check_inside(((s.x - s.md) - 1) + d, s.y - d, sensors, i, range) {
                return res;
            }
        }
    }
    0
}

pub fn _solve(input : String, part1_y : i32, part2_range : i32) -> (u32, u64) {
    let sensors = parse(input);
    (part1(&sensors, part1_y), part2(&sensors, part2_range))
}

pub fn solve() -> (u32, u64) {
    _solve(tools::read_file_contents(&tools::find_input_path("15")), 2000000, 4000000)
}
