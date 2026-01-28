use rand::Rng;

#[allow(dead_code)]
fn partition<T: Ord + Copy>(vec: &mut [T], low: isize, high: isize, comp: &mut u128) -> isize { 
    let pivot = vec[high as usize];
    let mut i = low - 1isize;

    for j in low..high { 
        *comp += 1u128;
        if vec[j as usize] < pivot 
        { 
            i += 1;
            vec.swap(i as usize, j as usize); 
        } 
    } 
    vec.swap((i + 1 as isize) as usize, high as usize); 
    return i + 1isize
} 

#[allow(dead_code)]
fn partition_r<T: Ord + Copy>(vec: &mut [T], low: isize, high: isize, comp: &mut u128) -> isize {
    let mut rng = rand::thread_rng();
    let r = rng.gen_range(low..high);
    vec.swap(r as usize, high as usize);
    partition(vec, low, high, comp)
}

#[allow(dead_code)]
fn quick_sort<T: Ord + Copy>(vec: &mut [T], low: isize, high: isize , comp: &mut u128) { 
    if low < high { 
        let piv = partition_r(vec, low, high, comp); 
        quick_sort(vec, low, piv - 1isize, comp); 
        quick_sort(vec, piv + 1isize, high, comp); 
    } 
} 


#[allow(dead_code)]
pub fn ascending<T: Ord + Copy>(vec: &mut [T]) -> u128 {
    let mut comp: u128 = 0;
    let n = vec.len();
    // println!("vector of {} elements quick sort", n);
    quick_sort(vec, 0isize, (n - 1usize) as isize, &mut comp);
    comp
}
