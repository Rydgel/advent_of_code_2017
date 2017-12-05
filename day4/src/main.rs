const INPUT: &str = include_str!("../input.txt");

fn dups(slice: Vec<String>) -> bool {
    (1..slice.len()).any(|i| slice[i..].contains(&slice[i - 1]))
}

fn sort_word(word: &str) -> String {
    let mut chars: Vec<_> = word.chars().collect();
    chars.sort();
    chars.iter().cloned().collect::<String>()
}

fn check_dups(row: &str) -> bool {
    !dups(row.split(" ").map(|w| w.to_string()).collect())
}

fn check_anagram(row: &str) -> bool {
    !dups(row.split(" ").map(|w| sort_word(w)).collect())
}

fn solve_1(input: &str) -> usize {
    input.lines().filter(|r| check_dups(r)).count()
}

fn solve_2(input: &str) -> usize {
    input.lines().filter(|r| check_anagram(r)).count()
}

fn main() {
    println!("{:?}", solve_1(INPUT));
    println!("{:?}", solve_2(INPUT));
}
