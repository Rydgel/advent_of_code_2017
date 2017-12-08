#![feature(non_ascii_idents)]

const INPUT: &str = include_str!("../input.txt");
type Memory = Vec<u32>;

fn parse_input(input: &str) -> Memory {
    input.split_whitespace().filter_map(|d| d.parse().ok()).collect()
}

/**
 * https://en.wikipedia.org/wiki/Cycle_detection#Floyd's_Tortoise_and_Hare
 */
fn floyd<T: PartialEq + Clone>(x0: T, f: &Fn(T) -> T) -> (u32, u32) {
    let mut tortoise = f(x0.clone());
    let mut hare = f(f(x0.clone()));
    while tortoise != hare {
        tortoise = f(tortoise);
        hare = f(f(hare));
    }

    let mut μ = 0;
    tortoise = x0;
    while tortoise != hare {
        tortoise = f(tortoise);
        hare = f(hare);
        μ += 1;
    }

    let mut λ = 1;
    hare = f(tortoise.clone());
    while tortoise != hare {
        hare = f(hare);
        λ += 1;
    }

    (μ, λ)
}

fn realloc_cycle(memory: Memory) -> Memory {
    let len = memory.len();
    let mut new_memory = memory.clone();
    if let Some((i, &val)) = new_memory.iter().enumerate()
        .max_by_key(|&(i, val)| (val, -(i as isize))) {
        // Remove the blocks from that bank
        new_memory[i] = 0;

        // Redistribute, starting with the next index
        for j in 0..(val as usize) {
            new_memory[(i + j + 1) % len] += 1;
        }
    }

    (&*new_memory).to_vec()
}

fn realloc_cycle_count(initial_memory: Memory) -> u32 {
    let (μ, λ) = floyd(initial_memory, &realloc_cycle);
    μ + λ
}

fn realloc_cycle_loop(initial_memory: Memory) -> u32 {
    let (_, λ) = floyd(initial_memory, &realloc_cycle);
    λ
}

fn main() {
    let memory: Vec<u32> = parse_input(INPUT);
    let memory2 = memory.clone();
    println!("{:?}", realloc_cycle_count(memory));
    println!("{:?}", realloc_cycle_loop(memory2));
}
