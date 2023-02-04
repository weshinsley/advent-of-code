extern crate core;

mod tools;
mod d01;
mod d02;

fn main() {
  tools::print_day(1, d01::solve());
  tools::print_day(2, d02::solve());
}


