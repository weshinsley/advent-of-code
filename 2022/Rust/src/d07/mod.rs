use crate::tools;

pub struct Node {
    pub files : u32,
    pub inner_files : u32,
    pub child_indexes : Vec<usize>,
    pub parent_index : usize,
}

pub fn parse(input : String) -> Vec<Node> {
    let mut file_system = Vec::new();

    file_system.push(Node {
        parent_index : 0,
        child_indexes : Vec::new(),
        files : 0,
        inner_files : 0,
    });

    let mut current_node : usize = 0;

    for line in input.split('\n') {
        if line == "$ cd /" || line == "$ ls" || line.starts_with("dir ") || line.is_empty() {
            continue;
        }

        if line == "$ cd .." {
            let inner = file_system[current_node].inner_files;
            current_node = file_system[current_node].parent_index;
            file_system[current_node].inner_files += inner;
            continue;
        }

        if line.starts_with("$ cd ") {
            let new_node = file_system.len();
            file_system.push(Node {
                parent_index : current_node,
                child_indexes : Vec::new(),
                files : 0,
                inner_files : 0,
            });

            file_system[current_node].child_indexes.push(new_node);
            current_node = new_node;
            continue;
        }

        let parts : Vec<String> = line.split(' ').map(str::to_string).collect();
        let file_size = parts[0].parse::<u32>().unwrap();
        file_system[current_node].files += file_size;
        file_system[current_node].inner_files += file_size;
    }

    while current_node != 0 {
        let inner = file_system[current_node].inner_files;
        current_node = file_system[current_node].parent_index;
        file_system[current_node].inner_files += inner;
    }
    file_system
}

fn part1(fs : &[Node]) -> u32 {
    let mut total = 0;
    for i in fs.iter() {
        if i.inner_files <= 100000 {
            total += i.inner_files
        }
    }
    total
}

fn part2(fs : &[Node]) -> u32 {
    let space_needed = 30000000 - (70000000 - fs[0].inner_files);
    let mut best = fs[0].inner_files;
    for i in fs.iter() {
        if (i.inner_files > space_needed) & (i.inner_files < best) {
            best = i.inner_files;
        }
    }
    best
}

pub fn _solve(input : String) -> (u32, u32) {
    let fs = parse(input);
    (part1(&fs), part2(&fs))
}
pub fn solve() -> (u32, u32) {
    _solve(tools::read_file_contents(&tools::find_input_path("07")))
}

#[cfg(test)]
mod tests {
    use crate::*;
    #[test]
    fn test_day7() {
        let data = tools::read_file_contents("../inputs/d07-test.txt");
        let res = d07::_solve(data);
        assert_eq!(res.0, 95437);
        assert_eq!(res.1, 24933642);
    }
}
