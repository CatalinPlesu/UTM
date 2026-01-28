use std::thread;

pub fn merge_sort<T: 'static + PartialOrd + Send + Clone + Copy>(vec: &mut [T]) -> &mut [T]{
     
    let length = vec.len();
    if length < 2 {
        return vec; }

    let tmp = vec.split_at(length/2);
    let mut left = tmp.0.to_vec();
    let mut right = tmp.1.to_vec();

    merge_sort(&mut left);
    merge_sort(&mut right);
    merge(vec, &mut left, &mut right);
    vec
}

pub fn merge<T: 'static + PartialOrd + Send + Clone + Copy>(vec: &mut [T], left: &mut [T], right: &mut [T]) {
    let mut x = 0;
    let mut y = 0;
    let mut i = 0;
    while x < left.len() && y < right.len() {

        if left[x] <= right[y] {
            vec[i] = left[x].clone();
            x += 1;
            i += 1;
        } else if left[x] > right[y] {
            vec[i] = right[y].clone();
            y += 1;
            i += 1;
        }
    }
    while x < left.len() {
        vec[i] = left[x].clone();
        x += 1;
        i += 1;
    }
    while y < right.len() {
        vec[i] = right[y].clone();
        y += 1;
        i += 1;
    }
}

#[allow(dead_code)]
pub fn ascending<T: 'static + Ord + Send + Clone + Copy + std::fmt::Debug>(vec: &mut [T]) -> u128 {
    // let n = vec.len();
    // println!("Array of {} elements merge sort sort", n);
    // merge_sort(vec);

    let length = vec.len();
    if length < 2 {
        return 0u128; }

    let tmp = vec.split_at(length/2);
    let mut left = tmp.0.to_vec();
    let mut right = tmp.1.to_vec();

    let handle = thread::spawn(move || {
        merge_sort(&mut left).to_vec()
    });
    
    merge_sort(&mut right);

    let mut left = handle.join().unwrap();
    merge(vec, &mut left, &mut right);

    0u128
}
