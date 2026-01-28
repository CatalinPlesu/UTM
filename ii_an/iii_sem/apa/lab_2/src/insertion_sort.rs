#[allow(dead_code)]
pub fn insertion_sort<T: Ord + Copy>(vec: &mut [T]) -> u128{
    let mut comp: u128 = 0;
    for i in 1..vec.len() {
        let val = vec[i];
        let mut j = i;
        let pos = vec[..i].binary_search(&val).unwrap_or_else(|pos| pos);
        while j > pos {
            comp += 1u128;
            vec.swap(j - 1, j);
            j -= 1;
        }
    }
    comp
}

#[allow(dead_code)]
pub fn ascending<T: Ord + Copy>(vec: &mut [T]) -> u128 {
    let n = vec.len();
    println!("Array of {} elements insertion sort", n);
    insertion_sort(vec)
}
