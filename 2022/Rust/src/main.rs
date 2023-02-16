extern crate core;

mod tools;
mod d01;
mod d02;
mod d03;
mod d04;
mod d05;
mod d06;

fn main() {
  tools::print_day(1, d01::solve());
  tools::print_day(2, d02::solve());
  tools::print_day(3, d03::solve());
  tools::print_day(4, d04::solve());
  tools::print_day_str(5, d05::solve());
  tools::print_day(6, d06::solve());
}


