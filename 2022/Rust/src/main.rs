extern crate core;

mod d01;
mod d02;
mod d03;
mod d04;
mod d05;
mod d06;
mod d07;
mod d08;
mod d09;
mod d10;
mod d11;
mod d12;
mod d13;
mod tools;

fn run_day(i : i8) {
    match i {
        1 => tools::print_day(1, d01::solve()),
        2 => tools::print_day(2, d02::solve()),
        3 => tools::print_day(3, d03::solve()),
        4 => tools::print_day(4, d04::solve()),
        5 => tools::print_day(5, d05::solve()),
        6 => tools::print_day(6, d06::solve()),
        7 => tools::print_day(7, d07::solve()),
        8 => tools::print_day(8, d08::solve()),
        9 => tools::print_day(9, d09::solve()),
        10 => tools::print_day(10, d10::solve()),
        11 => tools::print_day(11, d11::solve()),
        12 => tools::print_day(12, d12::solve()),
        13 => tools::print_day(13, d13::solve()),
        _ => println!("Day {i} not implemented"),
    }
}
fn main() {

    for i in 1..14 {
        run_day(i)
    }
}
