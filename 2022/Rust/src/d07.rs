use crate::tools;

pub struct Node {
    pub inner_files : u32,            // Size of files in current and subfolders
    pub child_indexes : Vec<usize>,   // Indexes of subfolders in file_system vector
    pub parent_index : usize,         // Index of my parent in file_system vector
}

pub fn parse(input : String) -> Vec<Node> {

    let mut file_system = Vec::new();  // All the Nodes in the file system...

    file_system.push(Node {            // Add the root node at index 0
        parent_index : 0,
        child_indexes : Vec::new(),
        inner_files : 0,
    });

    let mut current_node : usize = 0;  // Our current folder

    for line in input.split('\n') {

        // Ignore tehse lines:-

        if line == "$ cd /" || line == "$ ls" || line.starts_with("dir ") || line.is_empty() {
            continue;
        }

        // If we go back a folder, add my inner size (my files, and my children's files) to the
	// inner size of my parent, and current node becomes my parent.
	
	if line == "$ cd .." {
            let inner = file_system[current_node].inner_files;
            current_node = file_system[current_node].parent_index;
            file_system[current_node].inner_files += inner;
            continue;
        }

	// Use cd to start a new folder. The input data is very well behaved...
	// Create a new child node, with the current node as its parent,
	// and push the index of that new node onto the vector of my children,
	// then move into the child folder

        if line.starts_with("$ cd ") {
            let new_node = file_system.len();
            file_system.push(Node {
                parent_index : current_node,
                child_indexes : Vec::new(),
                inner_files : 0,
            });

            file_system[current_node].child_indexes.push(new_node);
            current_node = new_node;
            continue;
        }

	// This is the left-over case - "file_size file_name"
	// Extract just the size, and add it to my filesize counter

        let parts : Vec<String> = line.split(' ').map(str::to_string).collect();
        let file_size = parts[0].parse::<u32>().unwrap();
        file_system[current_node].inner_files += file_size;
    }

    // File is now finished, but need to move back to the root folder,
    // adding the file sizes to each parent folder we move through.

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
