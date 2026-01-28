use std::time::{Duration, Instant};
use std::thread::sleep;
use std::env;

fn main() {
    println!("Hello World!");
    let args: Vec<String> = env::args().collect();
    // println!("{:?}", args[1]);

    if args.len() > 1{
        let my_int: i32 = args[1].parse().unwrap();
        println!("{} => {} ", my_int, fib2(my_int));
    }
    let test :[i32; 8] = [10, 20, 30, 40, 50, 55, 100, 110]; 

    // for n in 1..200{
    // println!("{} => {} ", n, fib2(n));
    // }

    // println!("log 2 n");
    // for n in test{ 
    //     let now = Instant::now();
    //     print!("{} {} ", n, fib3(n));
    //     println!("{}", now.elapsed().as_micros());
    // }
    // println!();

    // println!("n");
    // for n in test{ 
    //     let now = Instant::now();
    //     print!("{} {} ", n, fib2(n));
    //     println!("{}", now.elapsed().as_micros());
    // }
    // println!();

    // println!("recursive paint");
    // for n in test{ 
    //     let now = Instant::now();
    //     print!("{} {} ", n, fib1(n));
    //     println!("{}", now.elapsed().as_micros());
    // }
    // println!();

}

fn fib1(n: i32) -> u128{
	if n < 2 {
		return n as u128;
    }
	else{
		return fib1(n - 1) + fib1(n - 2);
    }
}

fn fib2(n: i32) -> u128{
    let mut i :u128 = 1;
    let mut j :u128 = 0;

    for _k in 1..(n+1){
        j = i + j;
        i = j - i;
    }
	return j;
}

fn fib3(mut n :i32)->u128
{
    let mut i :u128 = 1;
    let mut j :u128 = 0;
    let mut k :u128 = 0;
    let mut h :u128 = 1;
    let mut t :u128 = 0;
	while n > 0
	{
		if n % 2 != 0
		{
			t = j * h;
			j = i * h + j * k + t;
            i = i * k + t;
		}
		t = h.pow(2);
		h = 2 * k * h + t;
		k = k.pow(2) + t;
		n = n / 2;
	}
	return j;
}
