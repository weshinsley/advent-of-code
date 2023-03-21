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
mod tools;

fn main() {
    tools::print_day(1, d01::solve());
    tools::print_day(2, d02::solve());
    tools::print_day(3, d03::solve());
    tools::print_day(4, d04::solve());
    tools::print_day(5, d05::solve());
    tools::print_day(6, d06::solve());
    tools::print_day(7, d07::solve());
    tools::print_day(8, d08::solve());
    tools::print_day(9, d09::solve());
    tools::print_day(10, d10::solve());
}
