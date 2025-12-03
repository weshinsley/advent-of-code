use crate::tools;
use std::cmp;
use std::cmp::Ordering;
use std::rc::Rc;
use std::cell::RefCell;

// Inspired by (and quite often copied from)
// https://applied-math-coding.medium.com/a-tree-structure-implemented-in-rust-8344783abd75

pub struct Element {
    number: Option<u32>,
    list: Vec<Rc<RefCell<Element>>>,
    parent : Option<Rc<RefCell<Element>>>,
}

impl Element {

    // Create an empty orphan ready to be set.

    pub fn new() -> Element {
        Element {
            number : None,
            list : vec![],
            parent : None,
        }
    }
}

// Now parse an expression.

pub fn parse_expr(expr : String) -> Rc<RefCell<Element>> {

    // Result : one Element to rule them all.

    let result = Rc::new(RefCell::new(Element::new()));

    // Now make a pointer to the element we're currently thinking about -
    // the "result" element at first. Clone the "address of" the result.
    // This will point to different things - hence mutable

    let mut element_pointer = Rc::clone(&result);

    // Split the string into chars, then we'll want a while loop, as we
    // might have to jump two at a time.

    let chars : Vec<char> = expr.chars().collect();
    let mut i : usize = 0;
    while i < chars.len() {
        let char = *chars.get(i).unwrap();

        if char == '[' {
            // We parse a '[' - so we need to create a list type of element,
            // add it the current list of things, and move the element_pointer to the new one.

            let new_element = Rc::new(RefCell::new(Element::new()));
            element_pointer.borrow_mut().list.push(Rc::clone(&new_element));
            new_element.borrow_mut().parent = Some(Rc::clone(&element_pointer));
            element_pointer = new_element;
            i += 1;

        } else if char == ']' {

            // We parse a ']' - all done here - move outwards.
            // We need element_pointer to now point to its parent.

            let element_pointer_clone = Rc::clone(&element_pointer);
            element_pointer = Rc::clone(element_pointer_clone.borrow().parent.as_ref().unwrap());
            i += 1;


        } else if char == ',' {
            i += 1;

        } else {
            // It's a digit - possibly two digits (10 is  the only example).
            // Create node, set value, add to list. No need for parent as we never
            // recurse into value nodes, only list nodes.

            let mut num  = char.to_digit(10).unwrap();
            i += 1;
            if chars.get(i).unwrap().is_numeric() {
                num *= 10;
                i += 1;
            }

            let val_element = Rc::new(RefCell::new(Element::new()));
            val_element.borrow_mut().number = Some(num);
            element_pointer.borrow_mut().list.push(Rc::clone(&val_element));
        }
    }

    result
}

pub fn compare_num(num1 : u32, num2 : u32) -> u32 {
    match num1.cmp(&num2) {
        Ordering::Less => 1,
        Ordering::Equal => 2,
        _ => 3
    }
}

pub fn compare(d1 : Rc<RefCell<Element>>, d2 : Rc<RefCell<Element>>) ->  u32 {
    if let Some(num1) = d1.borrow().number {
        if let Some(num2) = d2.borrow().number {
            return compare_num(num1, num2);        // Both numbers.
        }
        // num2 is list, num1 is not - so wrap num1 in a list and compare them.
        let d1_list = Rc::new(RefCell::new(Element::new()));
        d1_list.borrow_mut().list.push(Rc::clone(&d1));
        compare(d1_list, d2)

    } else { // So num1 was a list. How about num2?
        if d2.borrow().number.is_some() {
            let d2_list = Rc::new(RefCell::new(Element::new()));
            d2_list.borrow_mut().list.push(Rc::clone(&d2));
            return compare(Rc::clone(&d1), d2_list);
        }

        // They are both lists. Compare as many elements as possible...

        let smallest = cmp::min(d1.borrow().list.len(), d2.borrow().list.len());
        for i in 0..smallest {
            let res = compare(Rc::clone(&d1.borrow().list[i]),
                              Rc::clone(&d2.borrow().list[i]));

            if res !=2 { // If they're not equal, we have a result.
                return res;
            }
        }

        // Finally - everything was equal, and it comes down to differing length.

        compare_num(d1.borrow().list.len() as u32, d2.borrow().list.len() as u32)
    }

}

pub fn _solve(input : String) -> (u32, u32) {
    let mut data = Vec::new();
    for line in input.split('\n') {
        if !line.is_empty() {
            data.push(parse_expr(String::from(line)));
        }
    }

    let mut p1_correct = 0;
    for i in (0..data.len()).step_by(2) {
        if compare(Rc::clone(&data[i]), Rc::clone(&data[i + 1])) == 1 {
            p1_correct += (i / 2) + 1;
        }
    }

    let packet_2 = parse_expr(String::from("[[2]]"));
    let packet_6 = parse_expr(String::from("[[6]]"));

    let mut before_p2 = 1; // First index is 1
    let mut before_p6 = 2; // And also the new p2 comes before p6

    for entry in data {
        before_p2 += compare(Rc::clone(&packet_2), Rc::clone(&entry)) / 3;
        before_p6 += compare(Rc::clone(&packet_6), Rc::clone(&entry)) / 3;
    }

    (p1_correct as u32, before_p2 * before_p6)
}

pub fn solve() -> (u32, u32) {
    _solve(tools::read_file_contents(&tools::find_input_path("13")))
}

