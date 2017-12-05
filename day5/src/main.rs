const INPUT: &str = include_str!("../input.txt");

fn parse_input(input: &str) -> Vec<i64> {
    input.lines().filter_map(|n| n.parse().ok()).collect()
}

fn solver(input: &str, part2: bool) -> usize {
    let mut list = parse_input(input);
    let mut steps = 0;
    let mut index = 0;

    while let Some(i) = list.get_mut(index as usize) {
        index += *i;
        if *i >= 3 && part2 {
            *i -= 1;
        } else {
            *i += 1;
        }
        steps += 1;
    }

    steps
}

fn main() {
    println!("{:?}", solver(INPUT, false));
    println!("{:?}", solver(INPUT, true));
}
