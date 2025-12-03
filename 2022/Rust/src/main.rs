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
mod d14;
mod d15;
mod d16;
mod d17;
mod d18;
mod d19;
mod d20;
mod d21;
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
        14 => tools::print_day(14, d14::solve()),
        15 => tools::print_day(15, d15::solve()),
        16 => tools::print_day(16, d16::solve()),
        17 => tools::print_day(17, d17::solve()),
        18 => tools::print_day(18, d18::solve()),
        19 => tools::print_day(19, d19::solve()),
        20 => tools::print_day(20, d20::solve()),
        21 => tools::print_day(21, d21::solve()),
        _ => println!("Day {i} not implemented"),
    }
}
fn main() {

    for i in 1..=21 {
        run_day(i)
    }
}
