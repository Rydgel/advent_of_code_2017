use std::collections::HashMap;


const INPUT: i32 = 368078;

fn solve_1() -> i32 {
    let mut total: i32 = 1;
    let mut level: i32 = 1;

    while total < INPUT {
        level += 2;
        total = level.pow(2);
    }

    let offset = total - INPUT;
    let steps = offset % (level - 1);
    (level - 1) / 2 + ((level / 2) - steps).abs()
}

fn solve_2() -> i32 {
    let coords = vec![
        (1, 0),
        (1, -1),
        (0, -1),
        (-1, -1),
        (-1, 0),
        (-1, 1),
        (0, 1),
        (1, 1),
    ];

    let mut grid: HashMap<(i32, i32), i32> = HashMap::new();
    let mut x: i32 = 0;
    let mut y: i32 = 0;
    let mut dx: i32 = 0;
    let mut dy: i32 = -1;
    let mut total: i32;

    loop {
        total = 0;
        for offset in &coords {
            let &(ox, oy) = offset;
            match grid.get(&(x + ox, y + oy)) {
                Some(&value) => total += value,
                None => {}
            }
        }

        if total > INPUT {
            return total;
        }
        if (x, y) == (0, 0) {
            grid.insert((0, 0), 1);
        } else {
            grid.insert((x, y), total);
        }

        if (x == y) || (x < 0 && x == -y) || (x > 0 && x == 1 - y) {
            let (dx_tmp, dy_tmp) = (-dy, dx);
            dx = dx_tmp;
            dy = dy_tmp;
        }

        x += dx;
        y += dy;
    }
}

fn main() {
    println!("{:?}", solve_1());
    println!("{:?}", solve_2());
}
