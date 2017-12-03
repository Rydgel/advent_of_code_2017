const INPUT: &str = include_str!("../input.txt");

fn convert_input(input: &str) -> Vec<u32> {
    input.chars().filter_map(|s| s.to_digit(10)).collect()
}

fn solver(digits: &[u32], step: usize) -> u32 {
    digits.iter().enumerate().fold(0, |acc, (index, &current)| {
        let next = digits[(index + step) % digits.len()];
        if current == next { acc + current } else { acc }
    })
}

fn main() {
    let digits = convert_input(INPUT);
    println!("{:?}", solver(&digits, 1));
    println!("{:?}", solver(&digits, digits.len() / 2));
}
