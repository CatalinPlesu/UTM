// use rand::Rng;
use rand::{Rng, SeedableRng, rngs::StdRng};
use std::time::Instant;
use std::fmt::Display;
use colored::*;
use thousands::Separable;
// use std::fs::File;
use std::io::Write;
use std::fs::OpenOptions;
// use std::io::prelude::*;
// use std::env;
mod bubble_sort; 
mod quick_sort; 
mod merge_sort; 
mod insertion_sort; 
mod counting_sort; 
mod tim_sort; 
mod merge_sort_threads; 
mod merge_sort_log_threads; 
mod merge_sort_n_threads; 


#[allow(dead_code)]
fn gen_rand_vect (size: usize, max: i32) -> Vec<i32> {
    // let mut rng = rand::thread_rng();
    let mut rng = StdRng::seed_from_u64(size as u64);
    let mut vec: Vec<i32> = vec![0; size];
    for x in vec.iter_mut() {
        *x = rng.gen_range(0..max * 2 + 1) - max;
    }
    vec
}

#[allow(dead_code)]
fn gen_asc_rand_vec (size: usize, max: i32) -> Vec<i32> {
    let mut vec: Vec<i32> = vec![0; size];
    let mut rng = StdRng::seed_from_u64(size as u64);
    for (i, x) in vec.iter_mut().enumerate() {
        if i < size / 2usize {
            *x = max - (max - i as i32);
        } else {
            *x = rng.gen_range(0..max * 2 + 1) - max;
        }
    }
    vec
}

#[allow(dead_code)]
fn gen_almost_sorted_vect (size: usize, max: i32) -> Vec<i32> {
    let mut vec: Vec<i32> = vec![0; size];
    for (i, x) in vec.iter_mut().enumerate() {
        *x = max - (max - i as i32);
    }
    vec[size / 2usize] = -1;
    vec
}

#[allow(dead_code)]
fn gen_ascending_vect (size: usize, max: i32) -> Vec<i32> {
    let mut vec: Vec<i32> = vec![0; size];
    for (i, x) in vec.iter_mut().enumerate() {
        *x = max - (max - i as i32);
    }
    vec
}

#[allow(dead_code)]
fn gen_descending_vect (size: usize, max: i32) -> Vec<i32> {
    let mut vec: Vec<i32> = vec![0; size];
    for (i, x) in vec.iter_mut().enumerate() {
        *x = max - i as i32;
    }
    vec
}

#[allow(dead_code)]
fn timer<T: Ord>(vec: &mut [T], sort_fn: fn(&mut [T]) -> u128) -> (usize, u128, u128){
    let time = Instant::now();
    let comp = sort_fn(vec);
    (vec.len(), comp, time.elapsed().as_millis())
}

#[allow(dead_code)]
fn pretty_print(tuple: (usize, u128, u128)) {
    println!("{} of {} elements sorted in {} comparisons which took {} milliseconds or {} seconds",
             "Array".to_string().bold().magenta(),
            tuple.0.separate_with_commas().bold().blue(),
            tuple.1.separate_with_commas().bold().yellow(),
            tuple.2.separate_with_commas().bold().red(),
            (tuple.2 / 1000u128).separate_with_commas().bold().cyan());
}


#[allow(dead_code)]
fn stringify_row<T: Display>(label: &str, row: &[T]) -> String {
    let mut x = String::from(label);
    for z in row.iter() {
        x = format!("{},{}", x, z);
    }
    x = format!("{}\n", x);
    x
}

#[allow(dead_code)]
fn create_csv_file(filename: &str, row: &str) {
    // let mut file = File::create(filename);
    let mut file = std::fs::File::create(filename).expect("create failed");
   file.write_all(row.as_bytes()).expect("write failed");
}

#[allow(dead_code)]
fn append_to_csv(filename: &str, element: &str) {
    let mut file = OpenOptions::new()
        .write(true)
        .append(true)
        .open(filename)
        .unwrap();

    file.write(element.as_bytes()).expect("write failed");
}

fn main() {
    println!("works ^-^");

    // let n = [10, 100, 1000, 10000, 100000, 1000000, 10000000];
    // let n = [10, 100, 1000, 10000, 100000, 1000000];
    // let n = [ 10000000];
    // let n = [10, 100, 1000, 10000, 100000, 1000000, 10000000];
    const SIZE: usize = 100;
    let step: usize = 10000;
    let mut n: [usize; SIZE] = [0usize; SIZE];
    for i in 0..SIZE {
        n[i] = (1usize + i) * step;
    }

    let mut vec = gen_rand_vect(123usize, 1000000);    
    let mut tuple;
    

    let mut array_gen_method: &str;
    for array_met in 1..=5 {
        match array_met {
            1 => array_gen_method = "random",
            2 => array_gen_method = "partial",
            3 => array_gen_method = "one_element",
            4 => array_gen_method = "ascending",
            5 => array_gen_method = "descending",
            _ => return,
        }
        let time_file = &format!("{}_exec_time.csv", array_gen_method);
        create_csv_file(time_file, &stringify_row("n", &n)); 

        let mut alg: &str;
        for a in [1, 5, 7] {
            match a {
                1 => alg = "merge sort",
                2 => alg = "tim sort",
                3 => alg = "counting sort",
                4 => alg = "quick sort",
                5 => alg = "merge 2 thr",
                6 => alg = "merge log thr",
                7 => alg = "merge 8 thr",
                _ => return,
            }
            println!("{}   {}", alg.bold().on_blue().yellow(),
                           array_gen_method.bold().on_cyan().red());
            append_to_csv(time_file, alg); 
            for x in n {
                match array_met {
                    1 => vec = gen_rand_vect(x, 10000000),
                    2 => vec = gen_asc_rand_vec(x, 10000000),
                    3 => vec = gen_almost_sorted_vect(x, 1000000000),
                    4 => vec = gen_ascending_vect(x, 10000000),
                    5 => vec = gen_descending_vect(x, 10000000),
                    _ => println!("W_W"),
                }
                match a {
                    1 => tuple = timer(&mut vec, merge_sort::ascending),
                    2 => tuple = timer(&mut vec, tim_sort::ascending),
                    3 => tuple = timer(&mut vec, counting_sort::ascending),
                    4 => tuple = timer(&mut vec, quick_sort::ascending),
                    5 => tuple = timer(&mut vec, merge_sort_threads::ascending),
                    6 => tuple = timer(&mut vec, merge_sort_log_threads::ascending),
                    7 => tuple = timer(&mut vec, merge_sort_n_threads::ascending),
                    _ => return,
                }
                pretty_print(tuple);
                append_to_csv(time_file, &format!(",{}", tuple.2)); 
            }
            append_to_csv(time_file, "\n"); 

        }
    }
}


#[test]
fn insertion_sort_test() {
    let mut vec = vec![-3, 10, 4, 0, -4, -5, -4, -7, 6, 1];
    insertion_sort::ascending(&mut vec);
    println!("{:?}", vec);
    assert_eq!(vec, 
        [-7, -5, -4, -4, -3, 0, 1, 4, 6, 10]);
}

#[test]
fn merge_sort_test() {
    let mut vec = vec![-3, 10, 4, 0, -4, -5, -4, -7, 6, 1];
    merge_sort::ascending(&mut vec);
    println!("{:?}", vec);
    assert_eq!(vec, 
        [-7, -5, -4, -4, -3, 0, 1, 4, 6, 10]);
}

#[test]
fn quick_sort_test() {
    let mut vec = vec![-3, 10, 4, 0, -4, -5, -4, -7, 6, 1];
    quick_sort::ascending(&mut vec);
    println!("{:?}", vec);
    assert_eq!(vec, 
        [-7, -5, -4, -4, -3, 0, 1, 4, 6, 10]);
}

#[test]
fn bubble_sort_test() {
    let mut vec = vec![-3, 10, 4, 0, -4, -5, -4, -7, 6, 1];
    bubble_sort::ascending(&mut vec);
    println!("{:?}", vec);
    assert_eq!(vec, 
        [-7, -5, -4, -4, -3, 0, 1, 4, 6, 10]);
}

#[test]
fn counting_sort_test() {
    let mut vec = vec![-3, 10, 4, 0, -4, -5, -4, -7, 6, 1];
    counting_sort::ascending(&mut vec);
    println!("{:?}", vec);
    assert_eq!(vec, 
        [-7, -5, -4, -4, -3, 0, 1, 4, 6, 10]);
}

#[test]
fn tim_sort_test() {
    let mut vec = vec![-3, 10, 4, 0, -4, -5, -4, -7, 6, 1];
    tim_sort::ascending(&mut vec);
    println!("{:?}", vec);
    assert_eq!(vec, 
        [-7, -5, -4, -4, -3, 0, 1, 4, 6, 10]);
}

#[test]
fn tim_sort_str_test() {
    let mut vec = vec!["ion", "danu", "catalin", "alex"];
    tim_sort::ascending(&mut vec);
    println!("{:?}", vec);
    assert_eq!(vec, 
        ["alex", "catalin", "danu", "ion"]);
}

#[test]
fn merge_sort_threads_test() {
    let mut vec = vec![-3, 10, 4, 0, -4, -5, -4, -7, 6, 1];
    merge_sort_threads::ascending(&mut vec);
    println!("{:?}", vec);
    assert_eq!(vec, 
        [-7, -5, -4, -4, -3, 0, 1, 4, 6, 10]);
}

#[test]
fn merge_sort_log_threads_test() {
    let mut vec = vec![-3, 10, 4, 0, -4, -5, -4, -7, 6, 1];
    merge_sort_log_threads::ascending(&mut vec);
    println!("{:?}", vec);
    assert_eq!(vec, 
        [-7, -5, -4, -4, -3, 0, 1, 4, 6, 10]);
}

#[test]
fn merge_sort_n_threads_test() {
    let mut vec = vec![-3, 10, 4, 0, -4, -5, -4, -7, 6, 1];
    merge_sort_n_threads::ascending(&mut vec);
    println!("{:?}", vec);
    assert_eq!(vec, 
        [-7, -5, -4, -4, -3, 0, 1, 4, 6, 10]);
}
