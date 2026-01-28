pub fn merge_sort<T: PartialOrd + Clone>(vec: &mut [T], comp: &mut u128) {
     
    let length = vec.len();
    if length < 2 {
        return; }

    let tmp = vec.split_at(length/2);
    let mut left = tmp.0.to_vec();
    let mut right = tmp.1.to_vec();

    merge_sort(&mut left, comp);
    merge_sort(&mut right, comp);
    merge(vec, &mut left, &mut right, comp);
}

pub fn merge<T: PartialOrd + Clone>(vec: &mut [T], left: &mut [T], right: &mut [T], comp: &mut u128) {
    let mut x = 0;
    let mut y = 0;
    let mut i = 0;
    while x < left.len() && y < right.len() {
        *comp += 1u128;

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
pub fn ascending<T: Ord + Clone>(vec: &mut [T]) -> u128 {
    let mut comp: u128 = 0;
    // let n = vec.len();
    // println!("Array of {} elements merge sort sort", n);
    merge_sort(vec, &mut comp);
    comp
}
