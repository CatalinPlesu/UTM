use std::cmp::min;

#[allow(dead_code)]
pub fn tim_sort<T: Ord + Copy>(arr: &mut [T], comp: &mut u128) {
    let len = arr.len();
    let mini_run_len = 16;
    for i in (0..arr.len()).step_by(mini_run_len) {
        let hi = min(i + mini_run_len - 1, len - 1);
        insertion_sort_by_index(arr, i, hi, comp);
    }
    let mut run = mini_run_len;
    while run < len {
        for i in (0..len).step_by(2 * run) {
            let mid = min(i + run - 1, len - 1);
            let hi = min((i + 2 * run) - 1, len - 1);
            merge_by_index(arr, i, mid, hi, comp);
        }
        run *= 2;
    }
}

#[allow(dead_code)]
pub fn insertion_sort_by_index<T: Ord>(arr: &mut [T], left: usize, right: usize, comp: &mut u128) {
    for i in left + 1..=right {
        let mut j = i;
        *comp += 1u128;
        while j > left && arr[j - 1] > arr[j] {
            arr.swap(j, j - 1);
            j -= 1;
        }
    };
}

#[allow(dead_code)]
pub fn merge_by_index<T: Ord + Copy>(arr: &mut [T], lo: usize, mid: usize, hi: usize, comp: &mut u128) {
    let mut tmp = arr[lo..=hi].to_vec();
    let mut index = 0;
    let mut left_index = lo;
    let mut right_index = mid + 1;
    while left_index <= mid && right_index <= hi {
        *comp += 1u128;
        if arr[left_index] < arr[right_index] {
            tmp[index] = arr[left_index];
            left_index += 1;
            index += 1;
        } else {
            tmp[index] = arr[right_index];
            right_index += 1;
            index += 1;
        }
    }
    if left_index <= mid {
        tmp[index..].copy_from_slice(&arr[left_index..=mid]);
    }
    if right_index <= hi {
        tmp[index..].copy_from_slice(&arr[right_index..=hi]);
    }
    arr[lo..=hi].copy_from_slice(&tmp[..]);
}
 
 
#[allow(dead_code)]
pub fn ascending<T: Ord + Copy>(vec: &mut [T]) -> u128 {
    let mut comp: u128 = 0;
    let n = vec.len();
    println!("Array of {} elements tim sort", n);
    tim_sort(vec, &mut comp);
    comp
}
