const INPUT: &str = include_str!("../input.txt");

fn convert_input(input: &str) -> Vec<Vec<u32>> {
    input.lines().map(parse_line).collect()
}

fn parse_line(input: &str) -> Vec<u32> {
    input
        .split_whitespace()
        .map(|s| s.parse().unwrap())
        .collect()
}

fn solve_1(input: &str) -> u32 {
    convert_input(input).iter().fold(0, |acc, row| {
        let max = row.iter().max().unwrap();
        let min = row.iter().min().unwrap();
        acc + max - min
    })
}

fn solve_2(input: &str) -> u32 {
    convert_input(input).iter().fold(0, |acc, row| {
        let mut checksum = 0;
        for b in row {
            for a in row {
                if b % a == 0 && b != a {
                    checksum = b / a;
                }
            }
        }
        acc + checksum
    })
}

fn main() {
    println!("{:?}", solve_1(INPUT));
    println!("{:?}", solve_2(INPUT));
}
